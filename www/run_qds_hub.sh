#!/data/data/com.termux/files/usr/bin/bash
set -e

WWW="$HOME/OMEGA_EMPIRE/UV_QDS/www"
PORT=8011
HOST=127.0.0.1

cd "$WWW"

# Kill any previous simple servers (safe + lazy)
pkill -f "http.server" 2>/dev/null || true

echo "== QDS WWW ==" 
pwd
echo

# Find likely pages (adjust patterns if your names differ)
BATTERY_HABITAT=$(ls -1 *battery*habitat*.html 2>/dev/null | tail -n 1 || true)
BATTERY_DESIGN=$(ls -1 *battery*design*.html 2>/dev/null | tail -n 1 || true)
GROWTH_HUB=$(ls -1 *growthhub*.html 2>/dev/null | tail -n 1 || true)

echo "Detected pages:"
[ -n "$BATTERY_HABITAT" ] && echo " - Habitat: $BATTERY_HABITAT"
[ -n "$BATTERY_DESIGN" ] && echo " - Design : $BATTERY_DESIGN"
[ -n "$GROWTH_HUB" ]     && echo " - Growth : $GROWTH_HUB"
echo

echo "Starting server on http://$HOST:$PORT/"
python -m http.server "$PORT" --bind "$HOST" >/dev/null 2>&1 &
sleep 0.4

echo "Open these:"
[ -n "$GROWTH_HUB" ]     && echo " - http://$HOST:$PORT/$GROWTH_HUB"
[ -n "$BATTERY_HABITAT" ]&& echo " - http://$HOST:$PORT/$BATTERY_HABITAT"
[ -n "$BATTERY_DESIGN" ] && echo " - http://$HOST:$PORT/$BATTERY_DESIGN"
echo
echo "If a page isn't listed, rename it to include:"
echo "  'battery_habitat', 'battery_design', or 'growthhub'"
