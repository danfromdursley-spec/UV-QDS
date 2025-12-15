#!/data/data/com.termux/files/usr/bin/bash
set -e
cd "$HOME/OMEGA_EMPIRE/UV_QDS/www"
LATEST="$(ls -1t growthhub_linked_*.html 2>/dev/null | head -n 1 || true)"
if [[ -z "$LATEST" ]]; then
  echo "No linked GrowthHub copies found yet."
  exit 0
fi
echo "Latest linked GrowthHub:"
echo " - $LATEST"
echo "Open:"
echo " http://127.0.0.1:8011/$LATEST"
