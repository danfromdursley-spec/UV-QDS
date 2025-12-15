#!/data/data/com.termux/files/usr/bin/bash
set -e

WWW="$HOME/OMEGA_EMPIRE/UV_QDS/www"
PORT="8011"
HOST="127.0.0.1"

cd "$WWW"

# 1) kill any running python http servers (quietly)
pkill -f "http.server" 2>/dev/null || true

# 2) start server
python -m http.server "$PORT" --bind "$HOST" >/dev/null 2>&1 &

# 3) base URL
BASE="http://$HOST:$PORT"

# 4) open the core meeting set
termux-open-url "$BASE/growthhub_allinone_v1_1.html"
termux-open-url "$BASE/growthhub_meeting_script_v1.html"

# Optional: if you use a front-door/show page
if [ -f "frontdoor_show.html" ]; then
  termux-open-url "$BASE/frontdoor_show.html"
fi

# Optional: open pillar hubs directly (comment out if not needed)
if [ -f "qds_battery_hub_v9_6_science_neon_ui.html" ]; then
  termux-open-url "$BASE/qds_battery_hub_v9_6_science_neon_ui.html"
fi

if [ -f "compression_signals_demo_v1.html" ]; then
  termux-open-url "$BASE/compression_signals_demo_v1.html"
fi

# Optional: Stroud council demo page if you have a named file
# Replace filename below with your exact Stroud demo HTML if different
if ls *stroud*demo*.html >/dev/null 2>&1; then
  STRoudFile="$(ls *stroud*demo*.html | head -n 1)"
  termux-open-url "$BASE/$STRoudFile"
fi

echo "✅ GrowthHub meet mode live on $BASE"
echo "   Opened: All-in-One + Meeting Script (+ optional extras)"
