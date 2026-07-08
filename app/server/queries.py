"""Safe, parameterised queries the chat assistant can run.

Single source of truth for the vetted queries. Both the LLM tool-executor
(``llm.py``) and the rule-based fallback (``chat.py``) call these — the model
never writes SQL, it only picks a function and fills in arguments.
"""

import datetime
import re

import db
from live import STAGE_LABELS

PLAYER_SELECT = """
  SELECT p.id, p.full_name, p.shirt_name, p.position, p.jersey_number,
         p.date_of_birth, p.age, p.club, p.caps, p.goals, t.fifa_ranking,
         c.name AS country, c.code AS country_code, c.flag_emoji
  FROM players p
  JOIN teams t      ON t.id = p.team_id
  JOIN countries c  ON c.id = t.country_id
"""

POSITION_LABEL = {"GK": "goalkeepers", "DF": "defenders", "MF": "midfielders", "FW": "forwards"}

POSITION_WORDS = {
    "GK": ["gk", "goalkeeper", "goalkeepers", "keeper", "keepers"],
    "DF": ["df", "defender", "defenders", "defence", "defense", "back", "fullback"],
    "MF": ["mf", "midfielder", "midfielders", "midfield"],
    "FW": ["fw", "forward", "forwards", "striker", "strikers", "attacker", "attackers"],
}


def normalize_position(value) -> str | None:
    """Accept "GK", "goalkeeper", "Goalkeepers", etc. -> canonical code or None."""
    if not value:
        return None
    s = str(value).strip().lower()
    if s in ("gk", "df", "mf", "fw"):
        return s.upper()
    for code, words in POSITION_WORDS.items():
        if s in words:
            return code
    return None


async def _resolve_country(value) -> dict | None:
    """Resolve a free-form country name to a row, tolerant of partial matches
    (e.g. "USA" / "United States", "Korea")."""
    if not value:
        return None
    name = str(value).strip()
    exact = await db.fetch(
        "SELECT id, name, flag_emoji FROM countries WHERE name ILIKE $1 OR code ILIKE $1 LIMIT 1",
        name,
    )
    if exact:
        return exact[0]
    fuzzy = await db.fetch(
        "SELECT id, name, flag_emoji FROM countries WHERE name ILIKE $1 ORDER BY length(name) LIMIT 1",
        f"%{name}%",
    )
    return fuzzy[0] if fuzzy else None


async def search_players(country=None, position=None, name=None, club=None, limit=50, **_) -> dict:
    params: list = []
    where: list[str] = []
    country_row = None

    if country:
        country_row = await _resolve_country(country)
        if not country_row:
            return {"answer": f'I couldn\'t find a country called "{country}".', "players": []}
        params.append(country_row["id"])
        where.append(f"c.id = ${len(params)}")

    pos = normalize_position(position)
    if pos:
        params.append(pos)
        where.append(f"p.position = ${len(params)}")
    if name:
        params.append(f"%{name}%")
        where.append(f"(p.full_name ILIKE ${len(params)} OR p.shirt_name ILIKE ${len(params)})")
    if club:
        params.append(f"%{club}%")
        where.append(f"p.club ILIKE ${len(params)}")

    where_sql = f"WHERE {' AND '.join(where)}" if where else ""
    params.append(min(int(limit or 50), 100))
    rows = await db.fetch(
        f"{PLAYER_SELECT} {where_sql} "
        f"ORDER BY p.jersey_number NULLS LAST, p.full_name LIMIT ${len(params)}",
        *params,
    )

    plural = POSITION_LABEL[pos] if pos else "players"
    what = plural.rstrip("s") if len(rows) == 1 else plural
    scope = f" for {country_row['flag_emoji']} {country_row['name']}" if country_row else ""
    answer = (
        f"Found {len(rows)} {what}{scope}:" if rows else f"No {plural} found{scope}."
    )
    return {"answer": answer, "players": rows}


async def count_players(country=None, position=None, **_) -> dict:
    params: list = []
    where: list[str] = []
    country_row = None

    if country:
        country_row = await _resolve_country(country)
        if not country_row:
            return {"answer": f'I couldn\'t find a country called "{country}".', "players": []}
        params.append(country_row["id"])
        where.append(f"c.id = ${len(params)}")

    pos = normalize_position(position)
    if pos:
        params.append(pos)
        where.append(f"p.position = ${len(params)}")

    where_sql = f"WHERE {' AND '.join(where)}" if where else ""
    rows = await db.fetch(
        f"SELECT count(*)::int AS n "
        f"FROM players p "
        f"JOIN teams t ON t.id = p.team_id "
        f"JOIN countries c ON c.id = t.country_id {where_sql}",
        *params,
    )

    what = POSITION_LABEL[pos] if pos else "players"
    scope = f"{country_row['flag_emoji']} {country_row['name']} has" if country_row else "There are"
    return {"answer": f"{scope} {rows[0]['n']} {what} in the database.", "players": []}


async def top_scorers(country=None, limit=10, **_) -> dict:
    params: list = []
    where = "WHERE p.goals > 0"
    country_row = None

    if country:
        country_row = await _resolve_country(country)
        if not country_row:
            return {"answer": f'I couldn\'t find a country called "{country}".', "players": []}
        params.append(country_row["id"])
        where += f" AND c.id = ${len(params)}"

    params.append(min(int(limit or 10), 25))
    rows = await db.fetch(
        f"{PLAYER_SELECT} {where} ORDER BY p.goals DESC, p.caps DESC LIMIT ${len(params)}",
        *params,
    )

    scope = f" for {country_row['flag_emoji']} {country_row['name']}" if country_row else ""
    answer = f"Top scorers{scope}:" if rows else f"No goalscorers found{scope}."
    return {"answer": answer, "players": rows}


async def find_teams(group=None, country=None, **_) -> dict:
    """List national teams, or find which group a given team is in."""
    import re

    params: list = []
    where: list[str] = []
    group_name = None
    country_row = None

    if group:
        group_name = re.sub(r"[^A-L]", "", str(group).strip().upper())[:1]
        if group_name:
            params.append(group_name)
            where.append(f"g.name = ${len(params)}")
    if country:
        country_row = await _resolve_country(country)
        if not country_row:
            return {"answer": f'I couldn\'t find a country called "{country}".', "players": []}
        params.append(country_row["id"])
        where.append(f"c.id = ${len(params)}")

    where_sql = f"WHERE {' AND '.join(where)}" if where else ""
    rows = await db.fetch(
        f"SELECT t.id, c.name AS full_name, c.code AS country_code, c.flag_emoji, g.name AS grp, "
        f"       t.fifa_ranking, t.coach "
        f"FROM teams t "
        f"JOIN groups g    ON g.id = t.group_id "
        f"JOIN countries c ON c.id = t.country_id "
        f"{where_sql} "
        f"ORDER BY g.name, t.fifa_ranking NULLS LAST",
        *params,
    )

    # Shape team rows so the chat list (PlayerLine) renders them: the small box
    # shows the group letter, and the right column shows the FIFA ranking.
    players = [
        {
            "id": r["id"],
            "full_name": r["full_name"],
            "country_code": r["country_code"],
            "flag_emoji": r["flag_emoji"],
            "position": r["grp"],
            "country": f"FIFA #{r['fifa_ranking']}" if r["fifa_ranking"] else f"Group {r['grp']}",
        }
        for r in rows
    ]

    if country_row and len(rows) == 1:
        t = rows[0]
        coach = f" (coach: {t['coach']})" if t["coach"] else ""
        answer = f"{t['flag_emoji']} {t['full_name']} is in Group {t['grp']}{coach}."
    elif group_name:
        answer = (
            f"Group {group_name} — {len(rows)} teams:"
            if rows
            else f"No teams found for Group {group_name}."
        )
    else:
        answer = f"{len(rows)} teams:" if rows else "No teams found."
    return {"answer": answer, "players": players}


MATCH_SELECT = """
  SELECT m.id, m.stage::text AS stage, m.status::text AS status, m.match_date,
         m.home_score, m.away_score, m.home_pens, m.away_pens,
         hc.name AS home_name, hc.code AS home_code, hc.flag_emoji AS home_flag,
         ac.name AS away_name, ac.code AS away_code, ac.flag_emoji AS away_flag
  FROM matches m
  JOIN teams     ht ON ht.id = m.home_team_id
  JOIN teams     at ON at.id = m.away_team_id
  JOIN countries hc ON hc.id = ht.country_id
  JOIN countries ac ON ac.id = at.country_id
"""

# Free-form stage words -> canonical stage code. Order matters ("semi"/"quarter"
# before the bare "final" they contain).
_STAGE_PATTERNS = [
    (r"group", "Group"),
    (r"round of 32|last 32|r32", "R32"),
    (r"round of 16|last 16|r16", "R16"),
    (r"quarter", "QF"),
    (r"semi", "SF"),
    (r"third|3rd", "Third_Place"),
    (r"final", "Final"),
]


def normalize_stage(value) -> str | None:
    if not value:
        return None
    s = str(value).lower()
    for pattern, code in _STAGE_PATTERNS:
        if re.search(pattern, s):
            return code
    return None


_MONTHS = {
    "jan": 1, "january": 1, "feb": 2, "february": 2, "mar": 3, "march": 3,
    "apr": 4, "april": 4, "may": 5, "jun": 6, "june": 6, "jul": 7, "july": 7,
    "aug": 8, "august": 8, "sep": 9, "sept": 9, "september": 9, "oct": 10,
    "october": 10, "nov": 11, "november": 11, "dec": 12, "december": 12,
}
_MONTH_RE = "|".join(sorted(_MONTHS, key=len, reverse=True))


def _mk_date(y: int, mo: int, d: int) -> str | None:
    try:
        return datetime.date(y, mo, d).isoformat()
    except ValueError:
        return None


def _year(g: str | None) -> int:
    if not g:
        return 2026  # tournament year when unspecified
    y = int(g)
    return y + 2000 if y < 100 else y


def parse_date(text) -> str | None:
    """Find a date in free text (ISO, M/D/Y, or 'July 1') -> 'YYYY-MM-DD' or None."""
    if not text:
        return None
    s = str(text).lower()
    m = re.search(r"\b(\d{4})-(\d{1,2})-(\d{1,2})\b", s)
    if m:
        return _mk_date(int(m[1]), int(m[2]), int(m[3]))
    m = re.search(r"\b(\d{1,2})/(\d{1,2})(?:/(\d{2,4}))?\b", s)  # US M/D/Y
    if m:
        return _mk_date(_year(m[3]), int(m[1]), int(m[2]))
    m = re.search(rf"\b({_MONTH_RE})\.?\s+(\d{{1,2}})(?:,?\s*(\d{{4}}))?\b", s)
    if m:
        return _mk_date(_year(m[3]), _MONTHS[m[1]], int(m[2]))
    m = re.search(rf"\b(\d{{1,2}})\s+({_MONTH_RE})(?:,?\s*(\d{{4}}))?\b", s)
    if m:
        return _mk_date(_year(m[3]), _MONTHS[m[2]], int(m[1]))
    return None


def _shape_match(r: dict) -> dict:
    hs, as_ = r["home_score"], r["away_score"]
    winner = None
    if hs is not None and as_ is not None:
        if hs > as_:
            winner = "home"
        elif as_ > hs:
            winner = "away"
        elif r["home_pens"] is not None and r["away_pens"] is not None and r["home_pens"] != r["away_pens"]:
            winner = "home" if r["home_pens"] > r["away_pens"] else "away"
        else:
            winner = "draw"
    return {
        "id": r["id"],
        "stage": r["stage"],
        "stage_label": STAGE_LABELS.get(r["stage"], r["stage"]),
        "status": r["status"],
        "date": r["match_date"].date().isoformat() if r["match_date"] else None,
        "winner": winner,
        "home": {"name": r["home_name"], "code": r["home_code"], "flag_emoji": r["home_flag"],
                 "score": hs, "pens": r["home_pens"]},
        "away": {"name": r["away_name"], "code": r["away_code"], "flag_emoji": r["away_flag"],
                 "score": as_, "pens": r["away_pens"]},
    }


def _describe_match(m: dict) -> str:
    h, a = m["home"], m["away"]
    stage = m["stage_label"]
    if m["winner"] == "draw":
        return f"{h['flag_emoji']} {h['name']} drew with {a['flag_emoji']} {a['name']} {h['score']}–{a['score']} in the {stage}."
    win, lose = (h, a) if m["winner"] == "home" else (a, h)
    pens = ""
    if h["score"] == a["score"] and win["pens"] is not None and lose["pens"] is not None:
        pens = f" ({win['pens']}–{lose['pens']} on penalties)"
    return (
        f"{win['flag_emoji']} {win['name']} beat {lose['flag_emoji']} {lose['name']} "
        f"{win['score']}–{lose['score']}{pens} in the {stage}."
    )


def _date_label(iso: str) -> str:
    dt = datetime.date.fromisoformat(iso)
    return f"{dt:%B} {dt.day}, {dt.year}"


def _summarize_matches(matches, team_row, opp_row, stage_code, iso_day=None) -> str:
    scope = ""
    if team_row and opp_row:
        scope = f" between {team_row['name']} and {opp_row['name']}"
    elif team_row:
        scope = f" for {team_row['flag_emoji']} {team_row['name']}"
    elif stage_code:
        scope = f" in the {STAGE_LABELS.get(stage_code, stage_code)}"

    if not matches:
        if iso_day:
            return f"No matches found on {_date_label(iso_day)}{scope}."
        return f"No matches found{scope} yet."

    if len(matches) == 1 and matches[0]["winner"]:
        return _describe_match(matches[0])

    if iso_day:
        return f"Matches on {_date_label(iso_day)}{scope}:"
    if team_row and opp_row:
        return f"{team_row['name']} vs {opp_row['name']} — {len(matches)} matches:"
    if team_row:
        return f"{team_row['flag_emoji']} {team_row['name']} — recent results:"
    if stage_code:
        return f"{STAGE_LABELS.get(stage_code, stage_code)} — results:"
    return "Recent results:"


async def match_results(team=None, opponent=None, stage=None, day=None, limit=10, **_) -> dict:
    """Match results: who won, final scores, head-to-head, by stage, or by date."""
    params: list = []
    where: list[str] = []
    team_row = opp_row = None

    iso_day = parse_date(day) if day else None
    if iso_day:
        # A specific day: show that day's fixtures (any status).
        params.append(datetime.date.fromisoformat(iso_day))
        where.append(f"m.match_date::date = ${len(params)}")
    else:
        # Otherwise only matches that have actually been played (have a score).
        where.append("m.home_score IS NOT NULL AND m.away_score IS NOT NULL")

    if team:
        team_row = await _resolve_country(team)
        if not team_row:
            return {"answer": f'I couldn\'t find a team called "{team}".', "matches": []}
        params.append(team_row["id"])
        where.append(f"(ht.country_id = ${len(params)} OR at.country_id = ${len(params)})")

    if opponent:
        opp_row = await _resolve_country(opponent)
        if not opp_row:
            return {"answer": f'I couldn\'t find a team called "{opponent}".', "matches": []}
        params.append(opp_row["id"])
        where.append(f"(ht.country_id = ${len(params)} OR at.country_id = ${len(params)})")

    stage_code = normalize_stage(stage)
    if stage_code:
        params.append(stage_code)
        where.append(f"m.stage = ${len(params)}")

    order = "ASC" if iso_day else "DESC"
    params.append(min(int(limit or 10), 25))
    rows = await db.fetch(
        f"{MATCH_SELECT} WHERE {' AND '.join(where)} "
        f"ORDER BY m.match_date {order} LIMIT ${len(params)}",
        *params,
    )
    matches = [_shape_match(r) for r in rows]
    return {
        "answer": _summarize_matches(matches, team_row, opp_row, stage_code, iso_day),
        "matches": matches,
    }


# Registry the LLM layer dispatches into by tool name.
TOOLS = {
    "search_players": search_players,
    "count_players": count_players,
    "top_scorers": top_scorers,
    "find_teams": find_teams,
    "match_results": match_results,
}
