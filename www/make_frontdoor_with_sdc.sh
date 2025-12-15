#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "▶ Rebuilding front door…"

# Run your old frontdoor generator if it exists
if [ -x ./make_frontdoor_show_neon_v2.sh ]; then
  ./make_frontdoor_show_neon_v2.sh
elif [ -x ./make_frontdoor_v2.sh ]; then
  ./make_frontdoor_v2.sh
else
  echo "⚠ No existing frontdoor maker script found, continuing anyway."
fi

FILE="frontdoor_show.html"
BACKUP="${FILE%.html}_backup_$(date +%Y%m%d_%H%M%S).html"

if [ -f "$FILE" ]; then
  echo "Backing up $FILE -> $BACKUP"
  cp "$FILE" "$BACKUP"
fi

# Inject the Stroud District Council demo widget just above </body>
awk '
/stroud-demo-mount/ || /qds_stroud_widget_v1.js/ { next }  # drop old copies

/<\/body>/ {
  print "  <div id=\"stroud-demo-mount\"></div>"
  print "  <script src=\"qds_stroud_widget_v1.js\"></script>"
}
{ print }
' "$FILE" > "${FILE}.tmp"

mv "${FILE}.tmp" "$FILE"

echo "✅ Frontdoor rebuilt with SDC widget."
echo "🌐 Open: http://127.0.0.1:8011/frontdoor_show.html"
