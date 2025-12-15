#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
PORT=8011
HOST=127.0.0.1

cd "$ROOT"

echo "🧹 Clearing old server..."
pkill -f "http.server" 2>/dev/null || true

echo "🚀 Launching QDS local server on $HOST:$PORT"
nohup python -m http.server "$PORT" --bind "$HOST" \
  > .qds_server.log 2>&1 &

sleep 1

echo
echo "✅ Server up (log: $ROOT/.qds_server.log)"
echo "🎩 Recommended front door:"
ls -1 index_demo_front_*.html 2>/dev/null | tail -n 1 | while read f; do
  echo "   http://$HOST:$PORT/$f"
done

echo
echo "📌 Or use these if you prefer:"
echo "   http://$HOST:$PORT/all_pages_compact.html"
echo "   http://$HOST:$PORT/growthhub.html"
