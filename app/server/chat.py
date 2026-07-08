"""A lightweight natural-language interpreter that maps free-form questions onto
safe, parameterised SQL queries against the soccer2026 database. It is
deliberately rule-based (no external LLM needed) so the chat window works fully
offline while still feeling conversational.
"""

import re

import db
from queries import match_results, normalize_stage, parse_date

POSITIONS = {
    "GK": ["goalkeeper", "goalkeepers", "keeper", "keepers", "gk"],
    "DF": ["defender", "defenders", "defence", "defense", "back", "df"],
    "MF": ["midfielder", "midfielders", "midfield", "mf"],
    "FW": ["forward", "forwards", "striker", "strikers", "attacker", "attackers", "fw"],
}

PLAYER_SELECT = """
  SELECT p.id, p.full_name, p.shirt_name, p.position, p.jersey_number,
         p.date_of_birth, p.age, p.club, p.caps, p.goals,
         c.name AS country, c.code AS country_code, c.flag_emoji
  FROM players p
  JOIN teams t      ON t.id = p.team_id
  JOIN countries c  ON c.id = t.country_id
"""

POSITION_LABEL = {"GK": "goalkeepers", "DF": "defenders", "MF": "midfielders", "FW": "forwards"}

_country_cache: list[dict] | None = None


async def _get_countries() -> list[dict]:
    global _country_cache
    if _country_cache is None:
        _country_cache = await db.fetch("SELECT id, name, flag_emoji FROM countries")
    return _country_cache


def _detect_position(text: str) -> str | None:
    for code, words in POSITIONS.items():
        if any(re.search(rf"\b{w}\b", text, re.IGNORECASE) for w in words):
            return code
    return None


async def _detect_country(text: str) -> dict | None:
    countries = await _get_countries()
    lower = text.lower()
    # Longest country name first so "United States" wins over a shorter substring.
    for c in sorted(countries, key=lambda c: len(c["name"]), reverse=True):
        if c["name"].lower() in lower:
            return c
    return None


async def _detect_countries(text: str, limit: int = 2) -> list[dict]:
    """Up to `limit` distinct countries named in the text (for head-to-head)."""
    countries = await _get_countries()
    lower = text.lower()
    found: list[dict] = []
    for c in sorted(countries, key=lambda c: len(c["name"]), reverse=True):
        if c["name"].lower() in lower and all(c["id"] != f["id"] for f in found):
            found.append(c)
            if len(found) >= limit:
                break
    return found


_MATCH_INTENT = re.compile(
    r"\b(who won|winner|won|wins?|beat|beaten|defeat(?:ed)?|result|results|final score|"
    r"score|scored|drew|draw|lost|vs|versus|against|fixtures?)\b"
)


async def interpret(message: str) -> dict:
    text = (message or "").strip()
    if not text:
        return {
            "answer": "Ask me something like “Show players from Argentina” or “Who is Messi?”",
            "players": [],
        }

    lower = text.lower()
    country = await _detect_country(text)
    position = _detect_position(lower)
    is_count = bool(re.search(r"\bhow many\b|\bnumber of\b|\bcount\b", lower))
    is_top_scorer = bool(
        re.search(r"\btop scorer|most goals|leading scorer|top scorers|best scorer", lower)
    )

    # 1) "How many players from X" -> aggregate count
    if is_count:
        if country:
            rows = await db.fetch(
                "SELECT count(*)::int AS n FROM players p "
                "JOIN teams t ON t.id = p.team_id WHERE t.country_id = $1",
                country["id"],
            )
            extra = f" {POSITION_LABEL[position]}" if position else ""
            n = rows[0]["n"]
            players: list[dict] = []
            if position:
                r = await db.fetch(
                    f"{PLAYER_SELECT} WHERE c.id = $1 AND p.position = $2 ORDER BY p.jersey_number",
                    country["id"],
                    position,
                )
                players = r
                n = len(players)
            return {
                "answer": f"{country['flag_emoji']} {country['name']} has {n}{extra} in the squad.",
                "players": players,
            }
        rows = await db.fetch("SELECT count(*)::int AS n FROM players")
        return {"answer": f"There are {rows[0]['n']} players in the database.", "players": []}

    # 2) Top scorers (optionally scoped to a country)
    if is_top_scorer:
        params: list = []
        where = "WHERE p.goals > 0"
        if country:
            params.append(country["id"])
            where += f" AND c.id = ${len(params)}"
        rows = await db.fetch(
            f"{PLAYER_SELECT} {where} ORDER BY p.goals DESC, p.caps DESC LIMIT 10",
            *params,
        )
        scope = f" for {country['flag_emoji']} {country['name']}" if country else ""
        return {
            "answer": f"Top scorers{scope}:" if rows else f"No goalscorers found{scope}.",
            "players": rows,
        }

    # 2b) Match results — who won, scores, head-to-head, by stage, or by date.
    day = parse_date(text)
    if day or _MATCH_INTENT.search(lower):
        teams = await _detect_countries(text)
        stage = normalize_stage(lower)
        if day or teams or stage or re.search(r"\b(results?|scores?|who won|recent|fixtures?|matches?)\b", lower):
            return await match_results(
                team=teams[0]["name"] if teams else None,
                opponent=teams[1]["name"] if len(teams) > 1 else None,
                stage=stage,
                day=day,
            )

    # 3) Country (+ optional position) listing
    if country:
        params = [country["id"]]
        where = "WHERE c.id = $1"
        if position:
            params.append(position)
            where += " AND p.position = $2"
        rows = await db.fetch(
            f"{PLAYER_SELECT} {where} ORDER BY p.jersey_number NULLS LAST, p.full_name",
            *params,
        )
        what = POSITION_LABEL[position] if position else "players"
        return {
            "answer": (
                f"{country['flag_emoji']} {len(rows)} {what} for {country['name']}:"
                if rows
                else f"No {what} found for {country['name']}."
            ),
            "players": rows,
        }

    # 4) Position only (across all countries) -> keep it sane, limit results
    if position:
        rows = await db.fetch(
            f"{PLAYER_SELECT} WHERE p.position = $1 ORDER BY p.goals DESC, p.full_name LIMIT 25",
            position,
        )
        return {
            "answer": f"Showing {len(rows)} {POSITION_LABEL[position]} (top by goals):",
            "players": rows,
        }

    # 5) Name lookup: "who is X", "find X", or just a name
    name_query = lower
    name_query = re.sub(r"who('?s| is| are)\b", "", name_query)
    name_query = re.sub(
        r"\b(find|show|search|look up|lookup|tell me about|player|players|me)\b", "", name_query
    )
    name_query = re.sub(r"[?.!]", "", name_query).strip()

    if len(name_query) >= 2:
        rows = await db.fetch(
            f"{PLAYER_SELECT} WHERE p.full_name ILIKE $1 OR p.shirt_name ILIKE $1 "
            f"ORDER BY p.caps DESC LIMIT 15",
            f"%{name_query}%",
        )
        if rows:
            return {
                "answer": (
                    f"Found {rows[0]['full_name']} — {rows[0]['flag_emoji']} {rows[0]['country']}."
                    if len(rows) == 1
                    else f"Found {len(rows)} players matching “{name_query}”:"
                ),
                "players": rows,
            }

    return {
        "answer": (
            "I couldn't find a match. Try “players from Brazil”, “goalkeepers from Mexico”, "
            "“how many players from France”, “top scorers”, “who won Mexico vs Ecuador”, "
            "“Round of 32 results”, or a player's name."
        ),
        "players": [],
    }
