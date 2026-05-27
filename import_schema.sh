#!/usr/bin/env bash
set -euo pipefail
# Loads .env.render if present, then imports the schema into the external Render Postgres host
if [ -f .env.render ]; then
  # export variables defined as KEY=VALUE (ignores comments)
  export $(grep -v '^#' .env.render | xargs)
fi

if [ -z "${DB_HOST_EXTERNAL:-}" ]; then
  echo "DB_HOST_EXTERNAL is not set. Edit .env.render to add the external host."
  exit 1
fi

echo "Importing schema into ${DB_HOST_EXTERNAL}:${DB_PORT}/${DB_NAME} as ${DB_USER}"
PGPASSWORD="$DB_PASS" psql -h "$DB_HOST_EXTERNAL" -U "$DB_USER" -d "$DB_NAME" -f db/mcc_discipline_system.sql

echo "Import complete." 
