#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
PORT=8012
HOST="127.0.0.1"
PAGE="dev_door_space.html"

cd "$ROOT"

pkill -f "http.server $PORT" >/dev/null 2>&1 || true

python -m http.server "$PORT" --bind "$HOST" >/dev/null 2>&1 &

sleep 0.2

termux-open-url "http://$HOST:$PORT/$PAGE"

echo "✅ DEV UNIVERSE ONLINE"
echo "🌐 http://$HOST:$PORT/$PAGE"
