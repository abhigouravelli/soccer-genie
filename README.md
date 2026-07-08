# ⚽ FIFA World Cup 2026 — Squad Explorer & Live Companion

A full-stack web app for exploring the FIFA World Cup 2026: browse every national
team's squad, follow live scores and results, ask questions in plain English, and
query the official tournament regulations — all backed by a local Postgres
database and **local AI** (via [Ollama](https://ollama.com)), with no cloud API
keys required to get started.

![Stack](https://img.shields.io/badge/React_18-MUI_5-61dafb) ![Backend](https://img.shields.io/badge/FastAPI-asyncpg-009688) ![DB](https://img.shields.io/badge/Postgres_17-Docker-336791) ![AI](https://img.shields.io/badge/Ollama-local-black)

---

## Table of contents

- [Features](#features)
- [Tech stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Quick start](#quick-start)
- [Run everything in Docker](#run-everything-in-docker)
- [Configuration](#configuration)
- [API reference](#api-reference)
- [Troubleshooting](#troubleshooting)

---

## Features

The app is organized into three tabs.

### 1. Overview — live scores, fixtures & results
- Today's fixtures, in-progress games, and recent results at a glance.
- **Real-time scores** from [footballdata.io](https://footballdata.io) when an API
  key is configured — otherwise served from the local database, so it works fully
  offline.
- Date navigation to view any match day of the tournament.
- Because the free live feed has no in-play flag, "Live now" is inferred from a
  configurable time window around kickoff.

### 2. Squad Explorer — browse & search every squad
- All 48 qualified nations across 12 groups, with their player rosters.
- Filter by **country** and **position** (GK / DF / MF / FW), or free-text
  **search** by player name or club.
- Rich player table: flag, jersey number, age, caps, goals, and club.
- **Edit players inline** — updates are persisted to the database (`PUT /api/players/:id`).
- **Natural-language chat panel** — ask things like:
  - "Show players from Argentina"
  - "How many midfielders does France have?"
  - "Top scorers for Brazil"
  - "Who won Mexico vs Ecuador?"
  - "Which teams are in Group A?"

  A local LLM (Qwen via Ollama) routes each question to one of several safe,
  parameterised database queries — it **never writes raw SQL**. If Ollama is
  offline, a deterministic rule-based interpreter takes over, so chat keeps working.

### 3. Rules Q&A — ask the official regulations
- A local **RAG** (retrieval-augmented generation) assistant answers questions
  grounded in the *FIFA World Cup 26 Regulations* PDF in `docs/`.
- Ask e.g. "What is the offside rule?", "How does the knockout stage work?",
  "How many substitutions are allowed?"
- Retrieval uses local vector embeddings (`nomic-embed-text` via Ollama), with an
  automatic fall back to a self-contained TF-IDF index when the embedding model
  isn't available. The index is built on first use and cached to disk, rebuilding
  automatically when the PDFs change.
- Answers are generated locally and cite only the source documents — drop any PDF
  into `docs/` and it becomes searchable.

### Everything runs locally
No cloud AI keys are needed. Chat and Rules Q&A use Ollama on your machine; the
optional footballdata.io key only enables live scores and gracefully degrades to
the local DB without it.

---

## Tech stack

| Layer | Technologies |
|-------|--------------|
| **Frontend** | [React](https://react.dev) 18 · [Material UI](https://mui.com) 5 · [Vite](https://vitejs.dev) 5 |
| **Backend** | [Python](https://www.python.org) 3.11+ · [FastAPI](https://fastapi.tiangolo.com) · [Uvicorn](https://www.uvicorn.org) · [asyncpg](https://magicstack.github.io/asyncpg/) · [httpx](https://www.python-httpx.org) · [pypdf](https://pypdf.readthedocs.io) |
| **Database** | [PostgreSQL](https://www.postgresql.org) 17 · [Docker Compose](https://docs.docker.com/compose/) |
| **AI** | [Ollama](https://ollama.com) (`qwen2.5-coder:7b`, `nomic-embed-text`) · RAG |
| **Live data** | [footballdata.io](https://footballdata.io) API *(optional)* |

---

## Prerequisites

| Tool | Version | Required for |
|------|---------|--------------|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | latest | Postgres database |
| [Python](https://www.python.org/downloads/) | 3.11+ | Backend API |
| [Node.js](https://nodejs.org/) | 18+ | Frontend |
| [Ollama](https://ollama.com/download) | latest | Chat & Rules Q&A *(optional but recommended)* |

> Without Ollama the app still runs: chat falls back to the rule-based
> interpreter and Rules Q&A falls back to TF-IDF retrieval.

---

## Quick start

Clone the repo, then run the four pieces below. On the first run, do them in order
(database → backend → optional Ollama → frontend).

### 1. Start the database

From the project root:

```bash
docker compose up -d
```

This starts Postgres on **host port 5433** (the container's 5432 is remapped to
avoid clashing with any native Postgres on 5432) and pgAdmin on
[http://localhost:5050](http://localhost:5050). The `init/*.sql` scripts create
the schema and seed all countries, stadiums, teams, players, and matches on first
launch.

### 2. Start the backend

```bash
cd app/server

# Create and activate a virtual environment
python -m venv .venv
# Windows (PowerShell):
.venv\Scripts\Activate.ps1
# macOS / Linux:
source .venv/bin/activate

pip install -r requirements.txt

# Optional: configure live scores / model overrides
cp .env.example .env          # then edit .env if desired

python main.py
```

The API is now at [http://localhost:4000](http://localhost:4000) (visit it for a
live endpoint list). Verify with [http://localhost:4000/api/health](http://localhost:4000/api/health).

### 3. Set up Ollama (optional, for AI features)

```bash
# Install Ollama from https://ollama.com/download, then pull the models:
ollama pull qwen2.5-coder:7b     # chat + rules answers
ollama pull nomic-embed-text     # rules retrieval embeddings
```

Ollama serves automatically on `http://localhost:11434`. The backend detects it
with no extra configuration.

### 4. Start the frontend

```bash
cd app/client
npm install
npm run dev
```

Open **[http://localhost:5173](http://localhost:5173)** — you're up and running. 🎉

---

## Run everything in Docker

Prefer not to install Python and Node locally? This alternative builds and runs
the **database, backend, and frontend** together with a single command. The only
host requirement is **Docker Desktop**.

From the project root:

```bash
docker compose -f docker-compose.full.yml up --build
```

Then open **[http://localhost:5173](http://localhost:5173)**.

This builds an image for the FastAPI backend and a production build of the React
client (served by nginx, which proxies `/api` to the backend), alongside the
seeded Postgres database — all wired together on one Docker network.

**Optional extras**

- **Live scores** — pass your footballdata.io key when starting:
  ```bash
  # macOS / Linux
  FOOTBALLDATA_API_KEY=your_key docker compose -f docker-compose.full.yml up --build
  ```
  ```powershell
  # Windows PowerShell
  $env:FOOTBALLDATA_API_KEY="your_key"; docker compose -f docker-compose.full.yml up --build
  ```
  (or put `FOOTBALLDATA_API_KEY=your_key` in a `.env` file at the project root).
- **AI chat & Rules Q&A** — run [Ollama](https://ollama.com) on the host and pull
  the models (see [step 3 above](#3-set-up-ollama-optional-for-ai-features)). The
  backend container reaches it automatically at `host.docker.internal`. Without
  Ollama, the app still runs on its built-in fallbacks.

**Stop / clean up**

```bash
docker compose -f docker-compose.full.yml down      # stop the stack
docker compose -f docker-compose.full.yml down -v   # also delete the database volume
```

> The default `docker-compose.yml` used in the [Quick start](#quick-start) brings
> up only the database (plus pgAdmin) for the local-dev workflow. Use
> `docker-compose.full.yml` when you want the whole app containerized.

---

## Configuration

All backend settings are environment variables read from `app/server/.env`
(copy `app/server/.env.example` to start). Every value has a default, so an empty
`.env` works.

| Variable | Default | Purpose |
|----------|---------|---------|
| `PGHOST` / `PGPORT` | `localhost` / `5433` | Postgres host & port |
| `PGUSER` / `PGPASSWORD` / `PGDATABASE` | `soccer_admin` / `soccer2026` / `soccer2026` | Postgres credentials |
| `PORT` | `4000` | Backend listen port |
| `OLLAMA_URL` | `http://localhost:11434` | Ollama server URL |
| `OLLAMA_MODEL` | `qwen2.5-coder:7b` | Chat & generation model |
| `OLLAMA_EMBED_MODEL` | `nomic-embed-text:latest` | Embedding model for Rules Q&A |
| `OLLAMA_TIMEOUT_MS` | `30000` | Ollama request timeout |
| `FOOTBALLDATA_API_KEY` | *(unset)* | Enables real-time live scores. Get a free key at [footballdata.io](https://footballdata.io) |
| `FOOTBALLDATA_LEAGUE_ID` / `FOOTBALLDATA_SEASON_ID` | `50` / `618` | WC2026 league & season ids |
| `FOOTBALLDATA_TTL` | `120` | Seconds to cache the live feed |
| `FOOTBALLDATA_LIVE_WINDOW_MIN` | `180` | Minutes after kickoff a game is treated as "live" |

> **Security note:** never commit `app/server/.env` — it holds your API key and is
> already covered by `.gitignore`. Share only `.env.example`.

---

## API reference

Base URL: `http://localhost:4000`

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET`  | `/api/health` | Database connectivity check |
| `GET`  | `/api/overview?day=YYYY-MM-DD` | Fixtures, live games & recent results |
| `GET`  | `/api/countries` | All countries (for filters / dropdowns) |
| `GET`  | `/api/players?search=&country=&position=&limit=&offset=` | List / search players |
| `PUT`  | `/api/players/{id}` | Update a player |
| `POST` | `/api/chat` | Natural-language squad lookup (`{ "message": "..." }`) |
| `POST` | `/api/rag` | Ask the regulations PDFs (`{ "question": "..." }`) |

---

## Troubleshooting

**`/api/health` returns an error / players don't load**
The database isn't reachable. Confirm the container is up (`docker compose ps`)
and that Postgres is on host port **5433**. If you have a native Postgres on 5432,
this app deliberately uses 5433 — check `PGPORT` matches.

**Chat replies feel basic / "via: rules"**
Ollama isn't running or the model isn't pulled. Start Ollama and run
`ollama pull qwen2.5-coder:7b`. The app still answers via the rule-based fallback.

**Rules Q&A says the model is unavailable**
Pull the models (`qwen2.5-coder:7b` and `nomic-embed-text`) and ensure Ollama is
listening on `OLLAMA_URL`. Retrieval alone still works via TF-IDF.

**Overview shows database results instead of live scores**
That's the offline fallback. Set `FOOTBALLDATA_API_KEY` in `app/server/.env` and
restart the backend to enable the live feed.

**Port already in use (5173 / 4000 / 5433 / 5050)**
Stop the conflicting process or change the port (Vite: `vite.config.js`; backend:
`PORT`; Postgres: `docker-compose.yml`).

---

## License

Provided as-is for educational and personal use. Tournament data and the
regulations PDF belong to their respective owners.
