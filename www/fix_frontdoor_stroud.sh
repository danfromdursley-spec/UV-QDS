#!/usr/bin/env bash
set -euo pipefail

# Work in this folder
cd "$(dirname "$0")"

FILE="frontdoor_show.html"
BACKUP="${FILE%.html}_backup_$(date +%Y%m%d_%H%M%S).html"

echo "Backing up $FILE -> $BACKUP"
cp "$FILE" "$BACKUP"

# 1) remove any existing stray Stroud widget lines
# 2) inject the widget block just BEFORE </body>
awk '
/stroud-demo-mount/ || /qds_stroud_widget_v1.js/ { next }  # drop old copies

/<\/body>/ {
  print "  <div id=\"stroud-demo-mount\"></div>"
  print "  <script src=\"qds_stroud_widget_v1.js\"></script>"
}
{ print }   # print every (remaining) line
' "$FILE" > "${FILE}.tmp"

mv "${FILE}.tmp" "$FILE"
echo "Done. Stroud widget is now mounted just above </body> in $FILE"
