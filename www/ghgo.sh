#!/data/data/com.termux/files/usr/bin/bash
set -e

DIR="$HOME/OMEGA_EMPIRE/UV_QDS/www"
PORT=8011
PIDFILE="$DIR/.ghserve.pid"

cd "$DIR"

stop_server() {
  if [[ -f "$PIDFILE" ]]; then
    kill "$(cat "$PIDFILE")" 2>/dev/null || true
    rm -f "$PIDFILE"
  fi
  pkill -f "http.server $PORT" 2>/dev/null || true
}

start_server() {
  stop_server
  nohup python -m http.server "$PORT" --bind 127.0.0.1 \
    > "$DIR/.ghserve.log" 2>&1 &
  echo $! > "$PIDFILE"
}

latest_linked() {
  ls -1t growthhub_linked_*.html 2>/dev/null | head -n 1 || true
}

case "${1:-go}" in
  serve)
    start_server
    echo "🎩 Server up: http://127.0.0.1:$PORT/"
    ;;
  stop)
    stop_server
    echo "🎩 Server stopped."
    ;;
  link)
    ./qds_growthhub_autolink_v1.sh
    ;;
  go)
    start_server
    ./qds_growthhub_autolink_v1.sh
    LATEST="$(latest_linked)"
    echo
    echo "Latest linked GrowthHub:"
    echo " - $LATEST"
    echo "Open:"
    echo " http://127.0.0.1:$PORT/$LATEST"
    ;;
  *)
    echo "Usage: $0 {go|serve|link|stop}"
    ;;
esac
