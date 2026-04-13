#!/bin/bash

# =============================================
# healthcheck.sh
# Checks if the Notes API is up and running.
# Logs the result and exits with status code
# 0 (healthy) or 1 (unhealthy).
# =============================================

# ─── Colors ──────────────────────────────────
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()     { echo -e "${GREEN}[HEALTH]${NC} $1"; }
error()   { echo -e "${RED}[HEALTH]${NC} $1"; }
warn()    { echo -e "${YELLOW}[HEALTH]${NC} $1"; }

# ─── Config ──────────────────────────────────
API_URL="http://localhost:5000/api/health"
TIMEOUT=5
RETRY_COUNT=3
RETRY_DELAY=2

# ─── Check API health with retries ───────────
log "Checking API health at $API_URL..."

for i in $(seq 1 $RETRY_COUNT); do
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "$API_URL")

  if [ "$HTTP_STATUS" -eq 200 ]; then
    log "✅ API is healthy! (HTTP $HTTP_STATUS)"

    # ─── Show container status ───────────────
    log "Container status:"
    docker compose ps 2>/dev/null || warn "Could not retrieve container status"

    # ─── Show memory usage ───────────────────
    log "Memory usage:"
    free -h

    # ─── Show disk usage ─────────────────────
    log "Disk usage:"
    df -h /

    exit 0
  else
    warn "Attempt $i/$RETRY_COUNT failed (HTTP $HTTP_STATUS). Retrying in ${RETRY_DELAY}s..."
    sleep $RETRY_DELAY
  fi
done

# ─── All retries failed ──────────────────────
error "❌ API is DOWN after $RETRY_COUNT attempts!"
error "Last HTTP status: $HTTP_STATUS"

# ─── Show container logs for debugging ───────
error "Container logs:"
docker compose logs --tail=20 2>/dev/null || warn "Could not retrieve logs"

exit 1