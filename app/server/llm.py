"""Local LLM (Qwen via Ollama) natural-language understanding.

The model chooses one of our vetted tools and fills in its arguments; we then run
the corresponding safe query. The model never writes SQL. If Ollama is offline or
unsure, we fall back to the deterministic rule-based interpreter in ``chat.py``.
"""

import json
import os
import re

import httpx

from chat import interpret as rule_based
from queries import TOOLS

OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen2.5-coder:7b")
TIMEOUT_MS = int(os.getenv("OLLAMA_TIMEOUT_MS", "20000"))

TOOL_SCHEMAS = [
    {
        "type": "function",
        "function": {
            "name": "search_players",
            "description": (
                "List or look up FIFA World Cup 2026 players. Use for questions naming a country, "
                "a position, a player's name, or a club. Returns matching players."
            ),
            "parameters": {
                "type": "object",
                "properties": {
                    "country": {"type": "string", "description": "Country / national team name, e.g. 'Brazil'."},
                    "position": {"type": "string", "enum": ["GK", "DF", "MF", "FW"], "description": "Player position."},
                    "name": {"type": "string", "description": "Full or partial player name."},
                    "club": {"type": "string", "description": "Club name, e.g. 'Real Madrid'."},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "count_players",
            "description": "Count players (how many / number of). Optionally filtered by country and/or position.",
            "parameters": {
                "type": "object",
                "properties": {
                    "country": {"type": "string"},
                    "position": {"type": "string", "enum": ["GK", "DF", "MF", "FW"]},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "top_scorers",
            "description": "List the top goalscorers, optionally for a specific country.",
            "parameters": {
                "type": "object",
                "properties": {
                    "country": {"type": "string"},
                    "limit": {"type": "integer", "description": "How many to return (default 10)."},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "match_results",
            "description": (
                "Look up match results and scores — who won, the final score, a head-to-head "
                "between two teams, all results in a stage (group, round of 32/16, quarter-final, "
                "semi-final, final), or every match on a specific date. Use for any question about "
                "matches, results, scores, fixtures on a day, or who won / beat / lost / drew."
            ),
            "parameters": {
                "type": "object",
                "properties": {
                    "team": {"type": "string", "description": "A team/country whose matches to look up."},
                    "opponent": {"type": "string", "description": "Second team, for a head-to-head."},
                    "stage": {
                        "type": "string",
                        "description": "Stage, e.g. 'Group', 'Round of 32', 'Quarter-final', 'Final'.",
                    },
                    "day": {
                        "type": "string",
                        "description": "A specific date to list matches for, e.g. '2026-07-01' or 'July 1'.",
                    },
                    "limit": {"type": "integer"},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "find_teams",
            "description": (
                "List national teams in a tournament group, or find which group a team is in. "
                "Use for any question about groups A–L, e.g. 'which teams are in group A' or "
                "'what group is Brazil in'."
            ),
            "parameters": {
                "type": "object",
                "properties": {
                    "group": {"type": "string", "description": "Group letter A–L."},
                    "country": {"type": "string", "description": "Country/team name to find the group of."},
                },
            },
        },
    },
]

SYSTEM_PROMPT = (
    "You are the query router for a FIFA World Cup 2026 squad database. "
    "For every user message, call exactly ONE tool that best answers it. "
    "Map words to positions: goalkeeper=GK, defender=DF, midfielder=MF, forward/striker=FW. "
    "Use count_players for 'how many' / 'number of'. Use top_scorers for 'top/leading scorer' or 'most goals'. "
    "Use match_results for questions about played matches — who won, the score, head-to-head, or a stage's results. "
    "Use find_teams for questions about groups (A–L) — which teams are in a group, or what group a team is in. "
    "Otherwise use search_players. Respond with only the tool call."
)


def _safe_json(s):
    try:
        return json.loads(s)
    except Exception:
        return None


def _extract_tool_call(message: dict | None):
    """Qwen via Ollama sometimes returns the call in message.tool_calls and
    sometimes as JSON text in message.content. Normalise both into
    ``{name, arguments}``."""
    message = message or {}
    tool_calls = message.get("tool_calls") or []
    if tool_calls:
        c = tool_calls[0]["function"]
        raw = c.get("arguments")
        args = _safe_json(raw) if isinstance(raw, str) else raw
        return {"name": c["name"], "arguments": args or {}}

    content = (message.get("content") or "").strip()
    if not content:
        return None
    # Pull the first {...} block out of the content (handles ```json fences too).
    match = re.search(r"\{[\s\S]*\}", content)
    if not match:
        return None
    parsed = _safe_json(match.group(0))
    if parsed and parsed.get("name") and parsed["name"] in TOOLS:
        return {
            "name": parsed["name"],
            "arguments": parsed.get("arguments") or parsed.get("parameters") or {},
        }
    return None


async def _call_ollama(message: str) -> dict:
    async with httpx.AsyncClient(timeout=TIMEOUT_MS / 1000) as client:
        res = await client.post(
            f"{OLLAMA_URL}/api/chat",
            json={
                "model": OLLAMA_MODEL,
                "stream": False,
                "options": {"temperature": 0},
                "messages": [
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": message},
                ],
                "tools": TOOL_SCHEMAS,
            },
        )
        res.raise_for_status()
        data = res.json()
        return data["message"]


async def interpret(message: str) -> dict:
    text = (message or "").strip()
    if not text:
        return {
            "answer": "Ask me something like “Show players from Argentina” or “Who is Messi?”",
            "players": [],
        }

    try:
        msg = await _call_ollama(text)
        call = _extract_tool_call(msg)
        if call and call["name"] in TOOLS:
            result = await TOOLS[call["name"]](**(call["arguments"] or {}))
            return {**result, "via": "qwen", "tool": call["name"]}
        # Model answered without a tool — fall through to the deterministic interpreter.
    except Exception as e:
        print(f"LLM interpret failed, falling back to rules: {e}")

    # Fallback keeps the chat working if Ollama is offline or unsure.
    result = await rule_based(text)
    return {**result, "via": "rules"}
