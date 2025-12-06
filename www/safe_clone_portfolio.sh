#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="portfolio.html"
STAMP=$(date +%Y%m%d_%H%M%S)
NEW="portfolio_offer_v2_${STAMP}.html"

if [ ! -f "$BASE" ]; then
  echo "Missing $BASE in $(pwd)"
  exit 1
fi

cp -f "$BASE" "$NEW"
echo "Cloned: $BASE -> $NEW"
ls -lh "$BASE" "$NEW"
echo "Edit with: nano $NEW"
echo "Open at: 127.0.0.1:8000/$NEW"
