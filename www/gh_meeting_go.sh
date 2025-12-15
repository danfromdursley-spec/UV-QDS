#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
PORT="${1:-8011}"
HOST="127.0.0.1"

cd "$ROOT"

# Kill any existing python http.server (clean slate)
pkill -f "http.server" 2>/dev/null || true

# Start server in background
python -m http.server "$PORT" --bind "$HOST" >/dev/null 2>&1 &

BASE="http://$HOST:$PORT"

echo "✅ GrowthHub meeting launch"
echo "📍 Root: $ROOT"
echo "🌐 Server: $BASE"
echo

# Core GrowthHub demo stack (board-safe flow)
termux-open-url "$BASE/frontdoor_show.html"
termux-open-url "$BASE/growthhub_allinone_v1_1.html"
termux-open-url "$BASE/growthhub_meeting_script_v1.html"

# Pillar deep links (optional but handy)
termux-open-url "$BASE/qds_revenue_floor_v2.html"
termux-open-url "$BASE/qds_battery_hub_v9_6_science_neon.html"
termux-open-url "$BASE/qds_compression_lab_v1.html"

# Stroud impact demo (if you're showing the council angle)
termux-open-url "$BASE/growthhub_stroud_demo.html"

echo "✅ Opened:"
echo " - frontdoor_show.html"
echo " - growthhub_allinone_v1_1.html"
echo " - growthhub_meeting_script_v1.html"
echo " - qds_revenue_floor_v2.html"
echo " - qds_battery_hub_v9_6_science_neon.html"
echo " - qds_compression_lab_v1.html"
echo " - growthhub_stroud_demo.html"
echo

# Optional: show newest 15 HTML builds for confidence
echo "🧾 Newest 15 HTML builds:"
find . -type f -name "*.html" -printf "%TY-%Tm-%Td %TH:%TM  %p\n" 2>/dev/null | sort -r | head -15
