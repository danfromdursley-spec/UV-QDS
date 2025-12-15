#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
PORT=8012
HOST="127.0.0.1"

cd "$ROOT"

# kill only this port's server if it's already running
pkill -f "http.server $PORT" >/dev/null 2>&1 || true

# start dev-only server
python -m http.server "$PORT" --bind "$HOST" >/dev/null 2>&1 &

sleep 0.3

# open ONLY the dev door
termux-open-url "http://$HOST:$PORT/dev_door_space.html"

echo "✅ DEV DOOR launch"
echo "📍 Root: $ROOT"
echo "🌐 Server: http://$HOST:$PORT"
echo "🚀 Opened: dev_door_space.html"
