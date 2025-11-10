#!/usr/bin/env bash
set -euo pipefail

# Script simple para ejecutar en orden los scripts SQL de create_tables y etl_scripts
# Uso: copiar `.env.example` a `.env` y editar la contraseña. Luego:
# chmod +x run_etl.sh
# ./run_etl.sh

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTAINER_NAME="azuresqledge"

# cargar variables de .env si existe
if [ -f "$ROOT_DIR/.env" ]; then
  # shellcheck disable=SC1091
  set -o allexport
  # shellcheck disable=SC1090
  . "$ROOT_DIR/.env"
  set +o allexport
fi

if [ -z "${MSSQL_SA_PASSWORD-}" ]; then
  echo "ERROR: MSSQL_SA_PASSWORD no está definido. Crea .env a partir de .env.example"
  exit 1
fi

echo "Comprobando que el contenedor $CONTAINER_NAME está corriendo..."
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "El contenedor $CONTAINER_NAME no está en ejecución. Levantalo con: docker-compose up -d"
  exit 1
fi

SQLCMD="/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P \"${MSSQL_SA_PASSWORD}\" -b"

run_sql_file() {
  local f="$1"
  echo "---- Ejecutando: $f"
  # Enviamos el contenido del archivo al sqlcmd dentro del contenedor leyendo desde stdin
  docker exec -i "$CONTAINER_NAME" /bin/bash -c "${SQLCMD} -i /dev/stdin" < "$f"
}

echo "Ejecutando scripts de creación de tablas (sql/create_tables)..."
for sql in "$ROOT_DIR"/sql/create_tables/*.sql; do
  [ -e "$sql" ] || continue
  run_sql_file "$sql"
done

echo "Ejecutando scripts ETL (sql/etl_scripts)..."
for sql in "$ROOT_DIR"/sql/etl_scripts/*.sql; do
  [ -e "$sql" ] || continue
  run_sql_file "$sql"
done

echo "ETL finalizado. Recomendado: revisar logs y resultados conectando con Azure Data Studio o ejecutando consultas de verificación."
