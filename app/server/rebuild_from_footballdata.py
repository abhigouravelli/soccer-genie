"""One-time rebuild of the soccer2026 DB from footballdata.io's real WC2026 feed.

The DB previously held a *simulated* WC2026 bracket whose 48 teams and group
draw did not match reality (only 3/72 group matchups overlapped footballdata.io).
This script realigns the database to the real tournament (league 50, season 618):

  * drops the 11 teams that did not actually qualify,
  * adds the 8 real qualifiers that were missing,
  * re-derives the 12 groups from the real round-robin fixtures,
  * replaces every match with the real fixtures + scores,
  * recomputes the group standings.

What footballdata.io's feed does NOT provide (left as-is / empty):
  * player rosters  -> the 8 new teams get empty squads (existing squads kept),
  * goal scorers    -> match_events is cleared,
  * penalty-shootout scores, coaches, FIFA rankings for new teams,
  * official group letters -> group *membership* is exact; the A–L labels are
    assigned deterministically (earliest kickoff first) and may not match FIFA's.

Usage:  python rebuild_from_footballdata.py            # dry run (rolls back)
        python rebuild_from_footballdata.py commit      # applies the changes
Take a pg_dump backup first (see backups/).
"""

import asyncio
import json
import os
import ssl
import sys
import unicodedata
import urllib.request
from datetime import datetime, timezone

import asyncpg


def _load_dotenv() -> None:
    """Populate os.environ from the sibling ``.env`` file (real env wins).

    Kept dependency-free to match ``live.py``. Only sets keys that are not
    already present, so an explicitly exported variable always takes precedence.
    """
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env")
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

# footballdata.io API key — read from the environment (see .env / .env.example).
KEY = os.getenv("FOOTBALLDATA_API_KEY", "").strip()
UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/126.0 Safari/537.36")
API_URL = "https://footballdata.io/api/v1/matches?league_id=50&season_id=618&limit=200"

# API country name -> our canonical countries.name
COUNTRY_ALIAS = {"USA": "United States", "Congo DR": "DR Congo"}

# The 8 real qualifiers missing from the DB: canonical name -> (code, confederation, flag)
NEW_COUNTRIES = {
    "Cape Verde":     ("CPV", "CAF", "\U0001F1E8\U0001F1FB"),
    "Curaçao":        ("CUW", "CONCACAF", "\U0001F1E8\U0001F1FC"),
    "Czech Republic": ("CZE", "UEFA", "\U0001F1E8\U0001F1FF"),
    "Ghana":          ("GHA", "CAF", "\U0001F1EC\U0001F1ED"),
    "Haiti":          ("HAI", "CONCACAF", "\U0001F1ED\U0001F1F9"),
    "Paraguay":       ("PAR", "CONMEBOL", "\U0001F1F5\U0001F1FE"),
    "Qatar":          ("QAT", "AFC", "\U0001F1F6\U0001F1E6"),
    "Tunisia":        ("TUN", "CAF", "\U0001F1F9\U0001F1F3"),
}

# Teams to drop (did not qualify for the real WC2026).
REMOVE = ["Italy", "Serbia", "Poland", "Ukraine", "Denmark", "Chile",
          "Cameroon", "Honduras", "Jamaica", "Mali", "Nigeria"]

# API venue name -> our stadiums.name (only where they differ).
STADIUM_ALIAS = {
    "BC Place Stadium": "BC Place",
    "Estadio BBVA Bancomer": "Estadio BBVA",
    "Estadio Banorte": "Estadio Azteca",     # WC2026 sponsor rename of the Azteca
    "Mercedes-Benz Stadium": "Mercedes Benz Stadium",
    "Estadio AKRON": "Estadio Akron",
}


def _norm(s: str) -> str:
    """Accent/case-insensitive key so 'Curaçao' == 'Curacao'."""
    return "".join(c for c in unicodedata.normalize("NFKD", s or "")
                   if not unicodedata.combining(c)).strip().lower()


def fetch_games() -> list[dict]:
    if not KEY:
        sys.exit(
            "FOOTBALLDATA_API_KEY is not set. Add it to app/server/.env "
            "(see .env.example) or export it before running this script."
        )
    req = urllib.request.Request(API_URL, headers={"Authorization": f"Bearer {KEY}", "User-Agent": UA})
    with urllib.request.urlopen(req, timeout=30, context=ssl.create_default_context()) as r:
        return json.load(r)["data"]


def _fix_mojibake(s: str) -> str:
    """footballdata.io serves some names double-encoded ('CuraÃ§ao'); recover them."""
    try:
        repaired = s.encode("latin-1").decode("utf-8")
        return repaired if any(ord(c) > 127 for c in repaired) or repaired == s else repaired
    except (UnicodeDecodeError, UnicodeEncodeError):
        return s


def resolve_country(api_name: str) -> str:
    name = _fix_mojibake(api_name)
    return COUNTRY_ALIAS.get(name, name)


class UnionFind:
    def __init__(self):
        self.p = {}

    def find(self, x):
        self.p.setdefault(x, x)
        while self.p[x] != x:
            self.p[x] = self.p[self.p[x]]
            x = self.p[x]
        return x

    def union(self, a, b):
        self.p[self.find(a)] = self.find(b)


def build_plan(games: list[dict]) -> dict:
    """Turn the raw API games into normalized rows + derived groups + stages."""
    norm_games = []
    for g in games:
        home = resolve_country(g["home_team"]["country"])
        away = resolve_country(g["away_team"]["country"])
        complete = str(g.get("status", "")).lower() == "complete"
        sc = g.get("score") or {}
        venue = (g.get("venue") or {}).get("name")
        norm_games.append({
            "home": home, "away": away,
            "gw": g.get("game_week") or 0,
            "round_id": g.get("round_id"),
            "unix": g.get("date_unix"),
            "kickoff": datetime.fromtimestamp(g["date_unix"], tz=timezone.utc) if g.get("date_unix") else None,
            "complete": complete,
            "home_score": sc.get("home") if complete else None,
            "away_score": sc.get("away") if complete else None,
            "attendance": (g.get("venue") or {}).get("attendance") if complete else None,
            "stadium": STADIUM_ALIAS.get(venue, venue),
        })

    # Derive 12 groups from the round-robin (game_week 1-3) via connected components.
    uf = UnionFind()
    for g in norm_games:
        if g["gw"] and g["gw"] >= 1:
            uf.union(g["home"], g["away"])
    comps: dict[str, list[str]] = {}
    for g in norm_games:
        if g["gw"] and g["gw"] >= 1:
            comps.setdefault(uf.find(g["home"]), [])
    # earliest kickoff per component, to order the A–L labels deterministically
    comp_first: dict[str, datetime] = {}
    comp_members: dict[str, set] = {}
    for g in norm_games:
        if g["gw"] and g["gw"] >= 1:
            root = uf.find(g["home"])
            comp_members.setdefault(root, set()).update((g["home"], g["away"]))
            if g["kickoff"] and (root not in comp_first or g["kickoff"] < comp_first[root]):
                comp_first[root] = g["kickoff"]
    ordered_roots = sorted(comp_members, key=lambda r: comp_first.get(r, datetime.max.replace(tzinfo=timezone.utc)))
    letters = [chr(ord("A") + i) for i in range(len(ordered_roots))]
    team_group: dict[str, str] = {}
    for letter, root in zip(letters, ordered_roots):
        for t in comp_members[root]:
            team_group[t] = letter

    # Map knockout round_ids -> stage codes, ordered by earliest kickoff.
    ko_first: dict = {}
    for g in norm_games:
        if not (g["gw"] and g["gw"] >= 1) and g["round_id"] is not None:
            k = g["round_id"]
            if g["kickoff"] and (k not in ko_first or g["kickoff"] < ko_first[k]):
                ko_first[k] = g["kickoff"]
    ko_order = ["R32", "R16", "QF", "SF", "Final"]
    round_stage = {}
    for i, rid in enumerate(sorted(ko_first, key=lambda k: ko_first[k])):
        round_stage[rid] = ko_order[i] if i < len(ko_order) else "Final"

    def stage_of(g):
        if g["gw"] and g["gw"] >= 1:
            return "Group"
        return round_stage.get(g["round_id"], "R32")

    for g in norm_games:
        g["stage"] = stage_of(g)
        g["group"] = team_group.get(g["home"]) if g["stage"] == "Group" else None

    return {"games": norm_games, "team_group": team_group,
            "n_groups": len(ordered_roots), "round_stage": round_stage}


async def run(commit: bool):
    games = fetch_games()
    plan = build_plan(games)
    ng = plan["games"]
    api_countries = {g["home"] for g in ng} | {g["away"] for g in ng}

    conn = await asyncpg.connect(host="localhost", port=5433, user="soccer_admin",
                                 password="soccer2026", database="soccer2026")
    tr = conn.transaction()
    await tr.start()
    try:
        # ---- countries: insert the 8 new ones -------------------------------
        existing = {r["name"] for r in await conn.fetch("SELECT name FROM countries")}
        inserted_countries = 0
        for name in sorted(api_countries):
            if name in existing:
                continue
            match = next((k for k in NEW_COUNTRIES if _norm(k) == _norm(name)), None)
            if not match:
                raise RuntimeError(f"Unknown new country with no metadata: {name!r}")
            code, conf, flag = NEW_COUNTRIES[match]
            await conn.execute(
                "INSERT INTO countries(name, code, confederation, flag_emoji) VALUES($1,$2,$3::confederation_type,$4)",
                match, code, conf, flag)
            inserted_countries += 1

        # ---- wipe derived/relational data (rebuilt below) -------------------
        await conn.execute("DELETE FROM match_events")
        await conn.execute("DELETE FROM group_standings")
        await conn.execute("DELETE FROM matches")

        # ---- drop the 11 non-qualifiers (+ their players & team rows) -------
        rem_team_ids = [r["id"] for r in await conn.fetch(
            """SELECT t.id FROM teams t JOIN countries c ON c.id=t.country_id
               WHERE c.name = ANY($1)""", REMOVE)]
        deleted_players = 0
        if rem_team_ids:
            deleted_players = int((await conn.fetchval(
                "SELECT count(*) FROM players WHERE team_id = ANY($1)", rem_team_ids)) or 0)
            await conn.execute("DELETE FROM players WHERE team_id = ANY($1)", rem_team_ids)
            await conn.execute("DELETE FROM teams WHERE id = ANY($1)", rem_team_ids)
        await conn.execute("DELETE FROM countries WHERE name = ANY($1)", REMOVE)

        # ---- groups + teams: ensure a team row per country, set group_id ----
        group_id_by_letter = {r["name"].strip(): r["id"] for r in await conn.fetch("SELECT id, name FROM groups")}
        country_id = {r["name"]: r["id"] for r in await conn.fetch("SELECT id, name FROM countries")}
        team_by_country: dict[str, int] = {}
        inserted_teams = 0
        for name in sorted(api_countries):
            letter = plan["team_group"].get(name)
            gid = group_id_by_letter.get(letter) if letter else None
            row = await conn.fetchrow(
                "SELECT id FROM teams WHERE country_id=$1", country_id[name])
            if row:
                tid = row["id"]
                if gid is not None:
                    await conn.execute("UPDATE teams SET group_id=$1 WHERE id=$2", gid, tid)
            else:
                tid = await conn.fetchval(
                    "INSERT INTO teams(country_id, group_id) VALUES($1,$2) RETURNING id",
                    country_id[name], gid)
                inserted_teams += 1
            team_by_country[name] = tid

        # ---- stadiums lookup -------------------------------------------------
        stadium_id = {r["name"].strip(): r["id"] for r in await conn.fetch("SELECT id, name FROM stadiums")}
        missing_venues = sorted({g["stadium"] for g in ng if g["stadium"] and g["stadium"] not in stadium_id})
        # Future knockout fixtures have no venue yet -> route them to a TBD stadium.
        venue_less = any(not g["stadium"] for g in ng)
        tbd_stadium_id = None
        if venue_less:
            tbd_stadium_id = stadium_id.get("TBD") or await conn.fetchval(
                """INSERT INTO stadiums(name, city, host_country, capacity)
                   VALUES('TBD','TBD','TBD',0) RETURNING id""")

        # ---- matches ---------------------------------------------------------
        ng_sorted = sorted(ng, key=lambda g: g["kickoff"] or datetime.max.replace(tzinfo=timezone.utc))
        inserted_matches = 0
        for i, g in enumerate(ng_sorted, start=1):
            sid = stadium_id.get(g["stadium"]) if g["stadium"] else tbd_stadium_id
            if sid is None:
                raise RuntimeError(f"No stadium row for venue {g['stadium']!r}")
            gid = group_id_by_letter.get(g["group"]) if g["group"] else None
            await conn.execute(
                """INSERT INTO matches(match_number, stage, group_id, home_team_id, away_team_id,
                       stadium_id, match_date, home_score, away_score, status, attendance)
                   VALUES($1,$2::match_stage,$3,$4,$5,$6,$7,$8,$9,$10::match_status,$11)""",
                i, g["stage"], gid, team_by_country[g["home"]], team_by_country[g["away"]],
                sid, g["kickoff"], g["home_score"], g["away_score"],
                "Completed" if g["complete"] else "Scheduled", g["attendance"])
            inserted_matches += 1

        # ---- group standings (recompute from completed group games) ---------
        from collections import defaultdict
        st = defaultdict(lambda: dict(p=0, w=0, d=0, l=0, gf=0, ga=0))
        for g in ng:
            if g["stage"] != "Group" or not g["complete"]:
                continue
            h, a = team_by_country[g["home"]], team_by_country[g["away"]]
            hs, as_ = g["home_score"], g["away_score"]
            for t, gf, ga in ((h, hs, as_), (a, as_, hs)):
                s = st[t]; s["p"] += 1; s["gf"] += gf; s["ga"] += ga
                if gf > ga: s["w"] += 1
                elif gf < ga: s["l"] += 1
                else: s["d"] += 1
        team_group_id = {r["id"]: r["group_id"] for r in await conn.fetch("SELECT id, group_id FROM teams")}
        for tid, s in st.items():
            # goal_diff and points are GENERATED columns — don't insert them.
            await conn.execute(
                """INSERT INTO group_standings(group_id, team_id, played, won, drawn, lost,
                       goals_for, goals_against)
                   VALUES($1,$2,$3,$4,$5,$6,$7,$8)""",
                team_group_id[tid], tid, s["p"], s["w"], s["d"], s["l"], s["gf"], s["ga"])

        # ---- summary ---------------------------------------------------------
        totals = {
            "countries": await conn.fetchval("SELECT count(*) FROM countries"),
            "teams": await conn.fetchval("SELECT count(*) FROM teams"),
            "players": await conn.fetchval("SELECT count(*) FROM players"),
            "matches": await conn.fetchval("SELECT count(*) FROM matches"),
            "matches_scored": await conn.fetchval("SELECT count(*) FROM matches WHERE home_score IS NOT NULL"),
            "standings": await conn.fetchval("SELECT count(*) FROM group_standings"),
        }
        empty_squads = [r["name"] for r in await conn.fetch(
            """SELECT c.name FROM teams t JOIN countries c ON c.id=t.country_id
               LEFT JOIN players p ON p.team_id=t.id
               GROUP BY c.name HAVING count(p.id)=0 ORDER BY c.name""")]

        print("=== REBUILD SUMMARY ===")
        print(f"derived groups: {plan['n_groups']}  | knockout stage map: {plan['round_stage']}")
        print(f"countries inserted: {inserted_countries}  removed: {len(REMOVE)}")
        print(f"teams inserted: {inserted_teams}  players deleted: {deleted_players}")
        print(f"matches inserted: {inserted_matches}")
        print(f"missing venues (need manual stadium rows): {missing_venues or 'none'}")
        print(f"final counts: {totals}")
        print(f"teams with empty squads: {empty_squads}")

        # sanity checks before committing
        assert plan["n_groups"] == 12, f"expected 12 groups, got {plan['n_groups']}"
        assert totals["countries"] == 48 and totals["teams"] == 48, "expected 48 teams/countries"
        assert not missing_venues, "unmapped venues"

        if commit:
            await tr.commit()
            print("\nCOMMITTED.")
        else:
            await tr.rollback()
            print("\nDRY RUN — rolled back. Re-run with 'commit' to apply.")
    except Exception:
        await tr.rollback()
        raise
    finally:
        await conn.close()


if __name__ == "__main__":
    asyncio.run(run(commit=len(sys.argv) > 1 and sys.argv[1] == "commit"))
