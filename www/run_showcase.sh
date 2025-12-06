#!/data/data/com.termux/files/usr/bin/bash
set -e

WWW=~/OMEGA_EMPIRE/UV_QDS/www
cd "$WWW"

# Kill any old servers
pkill -f "http.server" 2>/dev/null || true

PORT=${1:-8000}

# Start clean, quiet local server
nohup python -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 &

echo "✅ Ω-QDS server running"
echo "👉 Showcase v1   : http://127.0.0.1:${PORT}/qds_showcase_index_v1.html"
echo "👉 Showcase v1.1 : http://127.0.0.1:${PORT}/qds_showcase_index_v1_1.html"
echo "👉 Shed v1       : http://127.0.0.1:${PORT}/qds_shed_index_v1.html"
