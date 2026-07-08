"""Async Postgres access for the soccer2026 FastAPI backend.

Connects to the Postgres instance defined in docker-compose.yml. Override any of
these with environment variables if your setup differs. asyncpg uses native
``$1``-style placeholders, so the parameterised SQL is shared verbatim with the
query helpers in ``queries.py`` / ``chat.py``.
"""

import os

import asyncpg

_pool: asyncpg.Pool | None = None


async def get_pool() -> asyncpg.Pool:
    """Lazily create (and cache) the shared connection pool."""
    global _pool
    if _pool is None:
        _pool = await asyncpg.create_pool(
            host=os.getenv("PGHOST", "localhost"),
            port=int(os.getenv("PGPORT", "5433")),
            user=os.getenv("PGUSER", "soccer_admin"),
            password=os.getenv("PGPASSWORD", "soccer2026"),
            database=os.getenv("PGDATABASE", "soccer2026"),
        )
    return _pool


async def close_pool() -> None:
    global _pool
    if _pool is not None:
        await _pool.close()
        _pool = None


async def fetch(text: str, *params) -> list[dict]:
    """Run a query and return the rows as a list of plain dicts."""
    pool = await get_pool()
    rows = await pool.fetch(text, *params)
    return [dict(r) for r in rows]


async def fetchrow(text: str, *params) -> dict | None:
    pool = await get_pool()
    row = await pool.fetchrow(text, *params)
    return dict(row) if row else None


async def execute(text: str, *params) -> str:
    pool = await get_pool()
    return await pool.execute(text, *params)
