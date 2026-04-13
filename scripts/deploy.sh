#!/bin/bash

# =============================================
# deploy.sh
# Pulls the latest code from GitHub and
# rebuilds + restarts the Docker containers.
# =============================================

set -e

# ─── Colors ──────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()   { echo -e "${GREEN}[DEPLOY]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─── Config ──────────────────────────────────
APP_DIR="/home/ubuntu/notes-api"
REPO_URL="https://github.com/your-username/notes-api.git"
BRANCH="main"

# ─── Check app directory exists ──────────────
if [ ! -d "$APP_DIR" ]; then
  log "App directory not found. Cloning repo..."
  git clone -b "$BRANCH" "$REPO_URL" "$APP_DIR"
else
  log "Pulling latest code from $BRANCH..."
  cd "$APP_DIR"
  git pull origin "$BRANCH"
fi

# ─── Navigate to app ─────────────────────────
cd "$APP_DIR"

# ─── Check .env file exists ──────────────────
if [ ! -f ".env" ]; then
  error ".env file not found in $APP_DIR. Create it before deploying."
fi

# ─── Stop existing containers ────────────────
log "Stopping existing containers..."
docker compose down || warn "No containers were running"

# ─── Build and start containers ──────────────
log "Building and starting containers..."
docker compose up --build -d

# ─── Remove unused images ────────────────────
log "Cleaning up unused Docker images..."
docker image prune -f

# ─── Show running containers ─────────────────
log "Currently running containers:"
docker compose ps

log "✅ Deployment complete!"