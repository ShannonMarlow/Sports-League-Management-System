#!/bin/bash

# Exit immediately on error
set -e

echo "🔍 Checking .env file..."
if [ ! -f .env ]; then
    echo "⚠️  Creating .env from .env.example"
    cp .env.example .env
    echo "➡️  Please edit the .env file with your environment variables before continuing."
    exit 1
fi

echo "🔄 Checking if Docker is running..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Make init scripts executable if needed
echo "🔧 Ensuring init scripts are executable..."
chmod +x 1-init-admin.sh || true
chmod +x 3-restore-dump.sh || true

# Optional: Reset everything (including database volumes)
echo "🧹 Cleaning up old containers and volumes..."
docker compose down -v

# Start everything fresh
echo "🚀 Building and starting containers..."
docker compose build

docker compose up -d

echo ""
echo "✅ Setup complete. You can now access the app at: http://localhost:5000"

