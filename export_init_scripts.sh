#!/usr/bin/env bash
#
# Export the running soccer2026 Postgres database to per-table init scripts.
#
# Produces an init-script/ folder containing:
#   00_types.sql        – enum types (every table depends on these, so first)
#   NN_<table>.sql      – one file per table: DDL + data (INSERTs) + constraints
#   99_views.sql        – helper views (depend on the tables, so last)
#
# Files are numbered in foreign-key dependency order, so mounting the folder as
# /docker-entrypoint-initdb.d in another docker compose recreates the database
# exactly (schema + current data).
#
# Usage:   ./export_init_scripts.sh
# Runs in Git Bash / WSL / macOS / Linux (needs docker + a running DB container).
# Override defaults with env vars: PG_CONTAINER, PGDATABASE, PGUSER
set -euo pipefail

CONTAINER="${PG_CONTAINER:-soccer2026_db}"
DB="${PGDATABASE:-soccer2026}"
DBUSER="${PGUSER:-soccer_admin}"
DBPASSWORD="${PGPASSWORD:-soccer2026}"

# Run psql/pg_dump inside the container with the password available.
pg() { docker exec -i -e PGPASSWORD="$DBPASSWORD" "$CONTAINER" "$@"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$SCRIPT_DIR/init-script"

# Tables in FK dependency order (parents before children).
TABLES=(countries stadiums groups teams players matches match_events group_standings)
# Views, created after every table they read from exists.
VIEWS=(v_group_standings v_match_schedule)

mkdir -p "$OUT_DIR"
rm -f "$OUT_DIR"/*.sql

echo "Exporting from container '$CONTAINER', database '$DB'…"

# 0) Enum types — rebuilt from the catalog (pg_dump -t cannot isolate a type).
pg psql -U "$DBUSER" -d "$DB" -tAqc "
  SELECT format('CREATE TYPE %I AS ENUM (%s);', t.typname,
                string_agg(quote_literal(e.enumlabel), ', ' ORDER BY e.enumsortorder))
  FROM pg_type t
  JOIN pg_enum e      ON e.enumtypid = t.oid
  JOIN pg_namespace n ON n.oid = t.typnamespace
  WHERE n.nspname = 'public'
  GROUP BY t.typname
  ORDER BY t.typname;
" > "$OUT_DIR/00_types.sql"
echo "  00_types.sql"

# 1..N) One self-contained file per table: CREATE TABLE + indexes + INSERTs + FKs.
i=1
for t in "${TABLES[@]}"; do
  f="$(printf '%02d_%s.sql' "$i" "$t")"
  pg pg_dump -U "$DBUSER" -d "$DB" \
      --no-owner --no-privileges --inserts --table="public.$t" > "$OUT_DIR/$f"
  echo "  $f"
  i=$((i + 1))
done

# 99) Views last (definition only — they hold no data of their own).
: > "$OUT_DIR/99_views.sql"
for v in "${VIEWS[@]}"; do
  pg pg_dump -U "$DBUSER" -d "$DB" \
      --no-owner --no-privileges --schema-only --table="public.$v" >> "$OUT_DIR/99_views.sql"
done
echo "  99_views.sql"

echo "Done → $OUT_DIR"
