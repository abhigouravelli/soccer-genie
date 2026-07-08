"""Live match / overview data with a pluggable provider.

By default the overview is served from the local Postgres database, so it works
fully offline. If ``WC2026_API_TOKEN`` is set (or ``LIVE_PROVIDER=api``), it
instead pulls real-time scores from the free worldcup26.ir REST API
(https://github.com/rezarahiminia/worldcup2026), falling back to the DB on any
error. The React client only ever talks to our own ``/api/overview`` endpoint,
so the token stays server-side and there are no CORS issues.
"""

import os
import time
from datetime import date, datetime, timezone

import httpx

import db


def _load_dotenv() -> None:
    """Populate os.environ from a sibling ``.env`` file (real env wins).

    Kept dependency-free so we don't add python-dotenv. Only sets keys that are
    not already present, so an explicitly exported variable always takes
    precedence over the file.
    """
    path = os.path.join(os.path.dirname(__file__), ".env")
    try:
        with open(path, encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                key, val = line.split("=", 1)
                os.environ.setdefault(key.strip(), val.strip().strip('"').strip("'"))
    except FileNotFoundError:
        pass


_load_dotenv()

STAGE_LABELS = {
    "Group": "Group Stage",
    "R32": "Round of 32",
    "R16": "Round of 16",
    "QF": "Quarter-finals",
    "SF": "Semi-finals",
    "Third_Place": "Third-place Play-off",
    "Final": "Final",
}

# Order knockout rounds after the group stage when grouping the day's fixtures.
STAGE_ORDER = {s: i for i, s in enumerate(STAGE_LABELS)}

_MATCH_SELECT = """
  SELECT m.id, m.stage::text AS stage, m.status::text AS status, m.match_date,
         m.home_score, m.away_score, m.home_pens, m.away_pens,
         s.name AS stadium, s.city,
         hc.name AS home_name, hc.code AS home_code, hc.flag_emoji AS home_flag,
         ac.name AS away_name, ac.code AS away_code, ac.flag_emoji AS away_flag
  FROM matches m
  JOIN stadiums  s  ON s.id = m.stadium_id
  LEFT JOIN teams     ht ON ht.id = m.home_team_id
  LEFT JOIN teams     at ON at.id = m.away_team_id
  LEFT JOIN countries hc ON hc.id = ht.country_id
  LEFT JOIN countries ac ON ac.id = at.country_id
"""


def _use_api() -> bool:
    return bool(os.getenv("WC2026_API_TOKEN")) or os.getenv("LIVE_PROVIDER", "").lower() == "api"


# ── Database provider ──────────────────────────────────────────────────────

async def _scorers_by_match(match_ids: list[int]) -> dict[int, list[dict]]:
    """Goal events for the given matches, grouped by match id."""
    if not match_ids:
        return {}
    rows = await db.fetch(
        """SELECT me.match_id, c.code AS team_code,
                  COALESCE(p.shirt_name, p.full_name) AS name, me.minute, me.event::text AS event
           FROM match_events me
           JOIN players   p ON p.id = me.player_id
           JOIN teams     t ON t.id = p.team_id
           JOIN countries c ON c.id = t.country_id
           WHERE me.match_id = ANY($1::int[])
             AND me.event IN ('Goal', 'Penalty_Goal', 'Own_Goal')
           ORDER BY me.minute""",
        match_ids,
    )
    out: dict[int, list[dict]] = {}
    for r in rows:
        out.setdefault(r["match_id"], []).append(
            {
                "team_code": r["team_code"],
                "name": r["name"],
                "minute": r["minute"],
                "is_penalty": r["event"] == "Penalty_Goal",
                "is_own_goal": r["event"] == "Own_Goal",
            }
        )
    return out


def _db_match(r: dict, scorers: dict[int, list[dict]]) -> dict:
    evs = scorers.get(r["id"], [])
    home = [e for e in evs if e["team_code"] and e["team_code"] == r["home_code"]]
    away = [e for e in evs if e["team_code"] and e["team_code"] == r["away_code"]]
    return {
        "id": r["id"],
        "stage": r["stage"],
        "stage_label": STAGE_LABELS.get(r["stage"], r["stage"]),
        "status": r["status"],
        "kickoff": r["match_date"].isoformat() if r["match_date"] else None,
        "stadium": r["stadium"],
        "city": r["city"],
        "home": {
            "name": r["home_name"] or "TBD",
            "code": r["home_code"],
            "flag_emoji": r["home_flag"],
            "score": r["home_score"],
            "pens": r["home_pens"],
            "scorers": home,
        },
        "away": {
            "name": r["away_name"] or "TBD",
            "code": r["away_code"],
            "flag_emoji": r["away_flag"],
            "score": r["away_score"],
            "pens": r["away_pens"],
            "scorers": away,
        },
    }


async def _db_overview(target: date) -> dict:
    today_rows = await db.fetch(
        f"{_MATCH_SELECT} WHERE m.match_date::date = $1 ORDER BY m.match_date", target
    )
    live_rows = await db.fetch(
        f"{_MATCH_SELECT} WHERE m.status = 'In_Progress' ORDER BY m.match_date"
    )
    recent_rows = await db.fetch(
        f"{_MATCH_SELECT} WHERE m.status = 'Completed' ORDER BY m.match_date DESC LIMIT 6"
    )

    ids = [r["id"] for r in today_rows + live_rows + recent_rows]
    scorers = await _scorers_by_match(ids)

    today = [_db_match(r, scorers) for r in today_rows]
    today.sort(key=lambda m: (STAGE_ORDER.get(m["stage"], 99), m["kickoff"] or ""))

    return {
        "date": target.isoformat(),
        "source": "database",
        "live": [_db_match(r, scorers) for r in live_rows],
        "today": today,
        "recent": [_db_match(r, scorers) for r in recent_rows],
        "generated_at": datetime.now(timezone.utc).isoformat(),
    }


# ── worldcup26.ir provider ─────────────────────────────────────────────────

_API_BASE = os.getenv("WC2026_API_BASE", "https://worldcup26.ir")
_TYPE_TO_STAGE = {
    "group": "Group",
    "r32": "R32",
    "r16": "R16",
    "qf": "QF",
    "sf": "SF",
    "third": "Third_Place",
    "final": "Final",
}


def _first(d: dict, *keys, default=None):
    for k in keys:
        if d.get(k) not in (None, ""):
            return d[k]
    return default


def _api_match(g: dict) -> dict:
    """Normalise a worldcup26.ir game into our match shape.

    Field names are best-effort; adjust the keys here once you can inspect a
    real ``/get/games`` response with your token (see README).
    """
    raw_type = str(_first(g, "type", "stage", default="")).lower()
    stage = _TYPE_TO_STAGE.get(raw_type, raw_type.upper() or "Group")
    finished = bool(_first(g, "finished", "is_finished", default=False))
    minute = _first(g, "time_elapsed", "minute", "elapsed")
    if finished:
        status = "Completed"
    elif minute:
        status = "In_Progress"
    else:
        status = "Scheduled"

    def side(prefix: str) -> dict:
        return {
            "name": _first(g, f"{prefix}_team", f"{prefix}_team_name", f"{prefix}_name", default="TBD"),
            "code": _first(g, f"{prefix}_code", f"{prefix}_team_code"),
            "flag_emoji": _first(g, f"{prefix}_flag", f"{prefix}_flag_emoji"),
            "score": _first(g, f"{prefix}_score", f"{prefix}_goals"),
            "pens": _first(g, f"{prefix}_pens", f"{prefix}_penalties"),
            "scorers": [
                {"name": s, "minute": None} if isinstance(s, str) else s
                for s in (_first(g, f"{prefix}_scorers", default=[]) or [])
            ],
        }

    kickoff = _first(g, "local_date", "date", "match_date", "kickoff")
    return {
        "id": _first(g, "id", "match_number", default=None),
        "stage": stage,
        "stage_label": STAGE_LABELS.get(stage, stage),
        "status": status,
        "minute": minute,
        "kickoff": kickoff,
        "stadium": _first(g, "stadium", "venue"),
        "city": _first(g, "city"),
        "home": side("home"),
        "away": side("away"),
    }


async def _api_overview(target: date) -> dict:
    token = os.getenv("WC2026_API_TOKEN", "")
    headers = {"Authorization": f"Bearer {token}"} if token else {}
    async with httpx.AsyncClient(timeout=10) as client:
        res = await client.get(f"{_API_BASE}/get/games", headers=headers)
        res.raise_for_status()
        payload = res.json()

    games = payload.get("data", payload) if isinstance(payload, dict) else payload
    matches = [_api_match(g) for g in games]

    iso = target.isoformat()
    today = [m for m in matches if (m["kickoff"] or "").startswith(iso)]
    today.sort(key=lambda m: (STAGE_ORDER.get(m["stage"], 99), m["kickoff"] or ""))
    live = [m for m in matches if m["status"] == "In_Progress"]
    recent = [m for m in matches if m["status"] == "Completed"][:6]

    return {
        "date": iso,
        "source": "worldcup26.ir",
        "live": live,
        "today": today,
        "recent": recent,
        "generated_at": datetime.now(timezone.utc).isoformat(),
    }


# ── footballdata.io provider ───────────────────────────────────────────────
#
# The primary real-time source. When ``FOOTBALLDATA_API_KEY`` is set we pull the
# real World Cup 2026 fixtures & scores from footballdata.io. The DB fixtures are
# a separate (simulated) bracket, so we don't try to reconcile the two per-match;
# footballdata.io simply becomes the live source, with the DB as the offline
# fallback. The whole tournament comes back in one request, so we fetch it once
# and cache it — the free plan only allows ~1000 requests/month.

_FD_BASE = os.getenv("FOOTBALLDATA_API_BASE", "https://footballdata.io/api/v1")
# footballdata.io sits behind Cloudflare, which 403s the default httpx UA.
_FD_UA = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/126.0 Safari/537.36"
)
# footballdata.io status strings that mean a match is currently being played.
_FD_LIVE = {"live", "in_play", "inplay", "in_progress", "inprogress",
            "1h", "2h", "ht", "et", "bt", "pen", "p", "susp"}
_FD_DONE = {"complete", "finished", "ft", "aet", "pen_finished"}
# footballdata.io country names that differ from our DB's countries.name.
_FD_COUNTRY_ALIASES = {"USA": "United States", "Congo DR": "DR Congo"}

_fd_cache: dict = {"at": 0.0, "games": None}
_country_meta: dict | None = None


def _api_key() -> str:
    return os.getenv("FOOTBALLDATA_API_KEY", "").strip()


async def _country_lookup() -> dict[str, tuple[str | None, str | None]]:
    """Map country name -> (code, flag_emoji) from our DB, to enrich API rows."""
    global _country_meta
    if _country_meta is None:
        rows = await db.fetch("SELECT name, code, flag_emoji FROM countries")
        _country_meta = {r["name"]: (r["code"], r["flag_emoji"]) for r in rows}
    return _country_meta


async def _fd_fetch_games() -> list[dict]:
    """Fetch (and cache) the whole 2026 tournament from footballdata.io."""
    ttl = int(os.getenv("FOOTBALLDATA_TTL", "120"))
    now = time.time()
    if _fd_cache["games"] is not None and now - _fd_cache["at"] < ttl:
        return _fd_cache["games"]

    params = {
        "league_id": os.getenv("FOOTBALLDATA_LEAGUE_ID", "50"),
        "season_id": os.getenv("FOOTBALLDATA_SEASON_ID", "618"),
        "limit": "200",
    }
    headers = {"Authorization": f"Bearer {_api_key()}", "User-Agent": _FD_UA}
    async with httpx.AsyncClient(timeout=15) as client:
        res = await client.get(f"{_FD_BASE}/matches", headers=headers, params=params)
        res.raise_for_status()
        payload = res.json()

    games = payload.get("data") if isinstance(payload, dict) else payload
    games = games or []
    _fd_cache.update(at=now, games=games)
    return games


def _fd_status(g: dict) -> str:
    raw = str(g.get("status", "")).lower()
    if raw in _FD_DONE:
        return "Completed"
    if raw in _FD_LIVE:
        return "In_Progress"
    # The free footballdata.io feed has NO in-play state — a game reads
    # "incomplete"/Scheduled until it flips straight to "complete". So the only
    # way to surface a "Live now" game is a time window: treat a not-yet-complete
    # game as live from kickoff until kickoff + FOOTBALLDATA_LIVE_WINDOW_MIN
    # (default 180m, enough for 90' + stoppage + knockout extra time + penalties).
    ux = g.get("date_unix")
    if raw != "cancelled" and ux:
        window_s = int(os.getenv("FOOTBALLDATA_LIVE_WINDOW_MIN", "180")) * 60
        elapsed = datetime.now(timezone.utc).timestamp() - float(ux)
        if 0 <= elapsed < window_s:
            return "In_Progress"
    return "Scheduled"


# Knockout rounds in bracket order; the feed has no round names, so we assign
# these by the order the rounds are played (earliest kickoff first).
_FD_KO_ORDER = ["R32", "R16", "QF", "SF", "Final"]


def _fd_round_stages(games: list[dict]) -> dict:
    """Map each game_week-0 round_id -> stage code (R32/R16/QF/SF/Final).

    footballdata.io doesn't label knockout rounds, but they play in order, so we
    sort the distinct knockout round_ids by their earliest kickoff and label them
    R32, R16, QF, … in sequence.
    """
    first: dict = {}
    for g in games:
        gw = g.get("game_week") or 0
        rid = g.get("round_id")
        if gw >= 1 or rid is None:
            continue
        ux = g.get("date_unix") or float("inf")
        if rid not in first or ux < first[rid]:
            first[rid] = ux
    ordered = sorted(first, key=lambda r: first[r])
    return {rid: _FD_KO_ORDER[min(i, len(_FD_KO_ORDER) - 1)] for i, rid in enumerate(ordered)}


def _fd_match(g: dict, cmeta: dict, round_stage: dict) -> dict:
    status = _fd_status(g)
    gw = g.get("game_week") or 0
    stage = "Group" if gw and gw >= 1 else round_stage.get(g.get("round_id"), "R32")
    sc = g.get("score") or {}
    venue = g.get("venue") or {}
    kickoff = (g.get("match_date") or "").replace(" ", "T") or None

    def side(which: str) -> dict:
        team = g.get(f"{which}_team") or {}
        country = team.get("country") or team.get("team_name") or "TBD"
        code, flag = cmeta.get(_FD_COUNTRY_ALIASES.get(country, country), (None, None))
        # footballdata.io reports 0–0 for unplayed games; only show a real score.
        score = sc.get(which) if status != "Scheduled" else None
        return {
            "name": country,
            "code": code,
            "flag_emoji": flag,
            "score": score,
            "pens": None,
            "scorers": [],
            "logo": team.get("team_logo"),
        }

    return {
        "id": g.get("match_id"),
        "stage": stage,
        "stage_label": STAGE_LABELS.get(stage, stage),
        "status": status,
        "minute": None,
        "kickoff": kickoff,
        "stadium": venue.get("name"),
        "city": venue.get("location"),
        "home": side("home"),
        "away": side("away"),
    }


async def _footballdata_overview(target: date) -> dict:
    games = await _fd_fetch_games()
    try:
        cmeta = await _country_lookup()
    except Exception as e:  # noqa: BLE001 — flags are cosmetic; live scores still render
        print(f"country lookup failed (scores will show without flags): {e}")
        cmeta = {}
    round_stage = _fd_round_stages(games)
    matches = [_fd_match(g, cmeta, round_stage) for g in games]

    iso = target.isoformat()
    today = [m for m in matches if (m["kickoff"] or "").startswith(iso)]
    today.sort(key=lambda m: (STAGE_ORDER.get(m["stage"], 99), m["kickoff"] or ""))
    live = [m for m in matches if m["status"] == "In_Progress"]
    live.sort(key=lambda m: m["kickoff"] or "")
    recent = sorted(
        (m for m in matches if m["status"] == "Completed"),
        key=lambda m: m["kickoff"] or "",
        reverse=True,
    )[:6]

    return {
        "date": iso,
        "source": "footballdata.io",
        "live": live,
        "today": today,
        "recent": recent,
        "generated_at": datetime.now(timezone.utc).isoformat(),
    }


# ── Public entry point ─────────────────────────────────────────────────────

async def get_overview(target: date | None = None) -> dict:
    target = target or date.today()
    # Prefer footballdata.io for real live scores; the DB is the offline fallback
    # (used automatically on any network / quota / parse error). See [[.env]].
    if _api_key():
        try:
            return await _footballdata_overview(target)
        except Exception as e:  # noqa: BLE001 — always degrade to the DB
            print(f"footballdata.io failed, falling back to database: {e}")
    if _use_api():
        try:
            return await _api_overview(target)
        except Exception as e:  # noqa: BLE001 — always degrade to the DB
            print(f"Live API failed, falling back to database: {e}")
    return await _db_overview(target)
