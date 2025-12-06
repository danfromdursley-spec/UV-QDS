#!/usr/bin/env bash
set -e
PORT="${1:-8011}"
ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"

cd "$ROOT"

# kill old server on same port if running
pkill -f "http.server $PORT" 2>/dev/null || true

echo
echo "=============================================="
echo "QDS 5-Wedge local preview ready 🎩"
echo "Serving: $ROOT"
echo "Open:    http://127.0.0.1:${PORT}/QDS-5-WEDGE-PORTFOLIO/index.html"
echo "=============================================="
echo

python -m http.server "$PORT" --bind 127.0.0.1
