#!/bin/bash

# =============================================
# setup.sh
# Installs Docker & Docker Compose on a fresh
# Ubuntu server. Run this once on a new EC2.
# =============================================

set -e  # Exit immediately if any command fails

# ─── Colors for output ───────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log()    { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()   { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()  { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─── Check if running as root ────────────────
if [ "$EUID" -ne 0 ]; then
  error "Please run as root: sudo bash setup.sh"
fi

log "Starting server setup..."

# ─── Update system packages ──────────────────
log "Updating system packages..."
apt update && apt upgrade -y

# ─── Install required dependencies ──────────
log "Installing dependencies..."
apt install -y curl git wget

# ─── Install Docker ──────────────────────────
log "Installing Docker..."
if command -v docker &> /dev/null; then
  warn "Docker is already installed. Skipping..."
else
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  rm get-docker.sh
  log "Docker installed successfully!"
fi

# ─── Add ubuntu user to docker group ─────────
log "Adding ubuntu user to docker group..."
usermod -aG docker ubuntu

# ─── Install Docker Compose ──────────────────
log "Installing Docker Compose..."
apt install -y docker-compose-plugin

# ─── Enable Docker on startup ────────────────
log "Enabling Docker on system startup..."
systemctl enable docker
systemctl start docker

# ─── Verify installations ────────────────────
log "Verifying installations..."
docker --version   || error "Docker installation failed"
docker compose version || error "Docker Compose installation failed"

log "✅ Server setup complete!"
log "Please log out and back in for docker group changes to take effect."