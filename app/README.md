# World Cup 2026 — Squad Explorer

A modern React + Material UI front end for the `soccer2026` Postgres database.
Browse and search the 721 national-team players, see each player's country,
edit player details, and ask the built-in chat assistant questions that are
answered straight from the database.

```
app/
├── server/   FastAPI + asyncpg REST API (port 4000)
└── client/   React + Vite + MUI front end (port 5173)
```

## Prerequisites

The database must be running (from the repo root):

```bash
docker compose up -d
```

> Note: the container is published on host port **5433** (a native Postgres
> already occupies 5432). The API connects there by default.

## Run it

Two terminals from the `app/` folder:

```bash
# 1) API  (Python 3.11+)
cd server
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --port 4000 --reload               # http://localhost:4000

# 2) Front end
cd client && npm install && npm run dev              # http://localhost:5173
```

Open http://localhost:5173.

## Features

- **Overview tab** (landing page) — today's date, live scores, today's fixtures
  grouped by knockout stage (Round of 32, Round of 16, …) and recent results.
  Polls every 10s for a real-time feel. Served by the local database by default;
  see [Live scores](#live-scores) to switch to a real external feed.
- **Players table** — searchable/filterable by name, club, country and position.
- **Edit players** — click the pencil to update name, shirt name, position,
  jersey number, club, caps, goals and age. Changes are saved to Postgres.
- **Chat assistant** — ask natural-language questions, e.g.
  - "Players from Argentina"
  - "Goalkeepers from Mexico"
  - "How many players from France?"
  - "Top scorers"
  - "Who won Mexico vs Ecuador?" / "Round of 32 results" / "matches on 7/1/2026"
  - "Who is Messi?"
- **Rules Q&A (RAG)** — a separate tab that answers questions about the FIFA
  World Cup 2026 regulations and the Laws of the Game, grounded in the PDFs under
  [`docs/`](../docs) with source citations. See [Rules Q&A](#rules-qa-rag).

## Configuration

The API reads standard Postgres env vars (`PGHOST`, `PGPORT`, `PGUSER`,
`PGPASSWORD`, `PGDATABASE`). Defaults match `docker-compose.yml`
(`localhost:5433`, `soccer_admin` / `soccer2026` / `soccer2026`).

The chat assistant optionally uses a local LLM (Qwen via Ollama) to route
questions; configure with `OLLAMA_URL`, `OLLAMA_MODEL`, `OLLAMA_TIMEOUT_MS`. If
Ollama is unavailable it transparently falls back to the built-in rule-based
interpreter, so the chat works fully offline.

## Live scores

The Overview tab reads from `/api/overview`, which uses a **pluggable live
provider**:

- **Default — local database.** Works offline. Because the seeded knockout
  fixtures start as `TBD`, run the optional demo seed to see live cards
  immediately:
  ```bash
  docker exec -i soccer2026_db psql -U soccer_admin -d soccer2026 < app/demo_live.sql
  ```
- **Real external feed — [worldcup26.ir](https://github.com/rezarahiminia/worldcup2026).**
  Register + authenticate there to get a JWT, then start the API with it set:
  ```bash
  WC2026_API_TOKEN=your_jwt uvicorn main:app --port 4000
  ```
  The backend then proxies live scores from the API (token stays server-side);
  it falls back to the database on any error. Optional: `WC2026_API_BASE`,
  `LIVE_PROVIDER=api`.

## Rules Q&A (RAG)

The **Rules Q&A** tab answers soccer/tournament questions grounded in the PDFs in
[`docs/`](../docs), entirely locally:

- **Retrieval** — vector embeddings via Ollama (`OLLAMA_EMBED_MODEL`, default
  `nomic-embed-text`; run `ollama pull nomic-embed-text` once). Falls back to a
  self-contained TF-IDF index if the model isn't available, or set
  `OLLAMA_EMBED_MODEL=""` to force TF-IDF.
- **Generation** — the same local Ollama model (`OLLAMA_MODEL`) composes the
  answer from the retrieved passages and cites the source document + page. If
  Ollama is offline, the relevant passages are returned directly.

The index is built on first use and cached to `server/.rag_index.pkl`; it
rebuilds automatically when the PDFs change. Drop more PDFs into `docs/` to expand
the knowledge base. Config: `RAG_DOCS_DIR` (defaults to `docs/`).

## API

| Method | Path                | Purpose                                  |
| ------ | ------------------- | ---------------------------------------- |
| GET    | `/api/health`       | DB connectivity check                    |
| GET    | `/api/overview`     | Today's fixtures, live scores & recent results (`day=YYYY-MM-DD`) |
| POST   | `/api/rag`          | Ask the rules/regulations PDFs (`{ question }`) |
| GET    | `/api/countries`    | List countries (filters / dropdowns)     |
| GET    | `/api/players`      | List/search players (`search`, `country`, `position`, `limit`, `offset`) |
| PUT    | `/api/players/:id`  | Update a player                          |
| POST   | `/api/chat`         | Natural-language lookup (`{ message }`)  |
