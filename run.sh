#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-8765}"
NAME="grimoire"

docker rm -f "$NAME" 2>/dev/null && echo "Stopped existing container." || true

docker run -d \
  --name "$NAME" \
  -p "${PORT}:80" \
  -v "$(cd "$(dirname "$0")" && pwd):/usr/share/nginx/html:ro" \
  --restart unless-stopped \
  nginx:alpine

echo ""
echo "grimoire running → http://localhost:${PORT}"
