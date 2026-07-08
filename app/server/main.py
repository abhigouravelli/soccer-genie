"""soccer2026 FastAPI backend.

A REST API over the FIFA World Cup 2026 squad database. Serves the React + MUI client
(which runs separately on port 5173). Replaces the previous Express/node-postgres
server while keeping the exact same endpoints and JSON shapes.
"""

from contextlib import asynccontextmanager
from datetime import date

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse, JSONResponse

import db
from live import get_overview
from llm import interpret
from rag import answer as rag_answer

PLAYER_SELECT = """
  SELECT p.id, p.full_name, p.shirt_name, p.position, p.jersey_number,
         p.date_of_birth, p.age, p.club, p.caps, p.goals,
         t.country_id, t.fifa_ranking, c.name AS country, c.code AS country_code, c.flag_emoji
  FROM players p
  JOIN teams t      ON t.id = p.team_id
  JOIN countries c  ON c.id = t.country_id
"""

UPDATABLE_FIELDS = [
    "full_name",
    "shirt_name",
    "position",
    "jersey_number",
    "club",
    "caps",
    "goals",
    "age",
]


@asynccontextmanager
async def lifespan(_app: FastAPI):
    yield
    await db.close_pool()


app = FastAPI(title="soccer2026 API", lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# Match the Express error shape: JSON body with an `error` key the client reads.
@app.exception_handler(HTTPException)
async def _http_exception_handler(_request: Request, exc: HTTPException):
    return JSONResponse(status_code=exc.status_code, content={"error": exc.detail})


@app.exception_handler(Exception)
async def _generic_exception_handler(_request: Request, exc: Exception):
    return JSONResponse(status_code=500, content={"error": str(exc)})


# Friendly root so visiting the API host directly isn't a bare 404.
@app.get("/", response_class=HTMLResponse)
async def root():
    return """
    <html><head><title>soccer2026 API</title>
    <style>
      body{font-family:Inter,system-ui,sans-serif;background:#0b1120;color:#e7ecf3;
           display:flex;min-height:100vh;align-items:center;justify-content:center;margin:0}
      .card{max-width:560px;padding:32px 36px;border:1px solid rgba(255,255,255,.08);
            border-radius:16px;background:#111a2e}
      h1{margin:0 0 4px;font-size:20px} .muted{color:#9aa7bd;font-size:14px}
      a{color:#10b981;text-decoration:none} a:hover{text-decoration:underline}
      code{background:#0b1120;padding:2px 6px;border-radius:6px;font-size:13px}
      li{margin:6px 0}
    </style></head>
    <body><div class="card">
      <h1>⚽ FIFA World Cup 2026 — API</h1>
      <p class="muted">This is the backend. The app UI runs separately at
        <a href="http://localhost:5173">http://localhost:5173</a>.</p>
      <p class="muted">Available endpoints:</p>
      <ul class="muted">
        <li><a href="/api/health">/api/health</a></li>
        <li><a href="/api/overview">/api/overview</a> — today's fixtures, live scores &amp; results</li>
        <li><code>POST /api/rag</code> — ask the rules/regulations PDFs (`{ question }`)</li>
        <li><a href="/api/countries">/api/countries</a></li>
        <li><a href="/api/players?country=Brazil">/api/players</a> <code>?search= &country= &position=</code></li>
        <li><code>PUT /api/players/:id</code> — update a player</li>
        <li><code>POST /api/chat</code> — natural-language lookup</li>
      </ul>
    </div></body></html>
    """


# Health check
@app.get("/api/health")
async def health():
    try:
        await db.fetch("SELECT 1")
        return {"ok": True}
    except Exception as e:
        return JSONResponse(status_code=500, content={"ok": False, "error": str(e)})


# List countries (for filters / edit dropdown)
@app.get("/api/countries")
async def countries():
    return await db.fetch(
        """SELECT c.id, c.name, c.code, c.flag_emoji, t.fifa_ranking
           FROM countries c
           LEFT JOIN teams t ON t.country_id = c.id
           ORDER BY c.name"""
    )


# List / search players
@app.get("/api/players")
async def players(search: str = "", country: str = "", position: str = "", limit: int = 100, offset: int = 0):
    params: list = []
    where: list[str] = []

    if search:
        params.append(f"%{search}%")
        where.append(f"(p.full_name ILIKE ${len(params)} OR p.club ILIKE ${len(params)})")
    if country:
        params.append(country)
        where.append(f"c.name = ${len(params)}")
    if position:
        params.append(position)
        where.append(f"p.position = ${len(params)}")

    where_sql = f"WHERE {' AND '.join(where)}" if where else ""
    params.append(int(limit))
    params.append(int(offset))

    rows = await db.fetch(
        f"{PLAYER_SELECT} {where_sql} "
        f"ORDER BY c.name, p.jersey_number NULLS LAST, p.full_name "
        f"LIMIT ${len(params) - 1} OFFSET ${len(params)}",
        *params,
    )

    count_params = params[: len(params) - 2]
    count_rows = await db.fetch(
        f"SELECT count(*)::int AS total FROM players p "
        f"JOIN teams t ON t.id = p.team_id "
        f"JOIN countries c ON c.id = t.country_id {where_sql}",
        *count_params,
    )

    return {"players": rows, "total": count_rows[0]["total"]}


# Update a player
@app.put("/api/players/{player_id}")
async def update_player(player_id: int, request: Request):
    body = await request.json()
    fields: list[str] = []
    params: list = []

    for key in UPDATABLE_FIELDS:
        if key in body:
            params.append(None if body[key] == "" else body[key])
            fields.append(f"{key} = ${len(params)}")

    if not fields:
        raise HTTPException(status_code=400, detail="No updatable fields supplied.")

    params.append(player_id)
    await db.execute(
        f"UPDATE players SET {', '.join(fields)} WHERE id = ${len(params)}", *params
    )

    row = await db.fetchrow(f"{PLAYER_SELECT} WHERE p.id = $1", player_id)
    if not row:
        raise HTTPException(status_code=404, detail="Player not found.")
    return row


# Chat: natural-language lookup
@app.post("/api/chat")
async def chat(request: Request):
    body = await request.json()
    return await interpret((body or {}).get("message"))


# Overview: today's fixtures, live games and recent results (real-time).
@app.get("/api/overview")
async def overview(day: str = ""):
    target = date.fromisoformat(day) if day else None
    return await get_overview(target)


# RAG: answer rules/soccer questions grounded in the docs/ PDFs.
@app.post("/api/rag")
async def rag(request: Request):
    body = await request.json()
    return await rag_answer((body or {}).get("question") or (body or {}).get("message"))


if __name__ == "__main__":
    import os

    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=int(os.getenv("PORT", "4000")), reload=True)
