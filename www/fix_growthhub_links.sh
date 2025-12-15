#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="$BASE_DIR/f/index.html"

echo "=== GrowthHub link fixer ==="
echo "Working on: $FILE"

if [ ! -f "$FILE" ]; then
  echo "ERROR: $FILE not found."
  exit 1
fi

# Backup
BACKUP="${FILE}.bak_$(date +%Y%m%d_%H%M%S)"
cp "$FILE" "$BACKUP"
echo "Backup saved as: $BACKUP"

# Fix Revenue → /c
sed -i \
  -e 's/href="c"/href="\/c"/g' \
  -e 's/href="\.\/c"/href="\/c"/g' \
  -e 's/href="c\/"/href="\/c"/g' \
  "$FILE"

# Fix Battery → /b
sed -i \
  -e 's/href="b"/href="\/b"/g' \
  -e 's/href="\.\/b"/href="\/b"/g' \
  -e 's/href="b\/"/href="\/b"/g' \
  "$FILE"

# Optional Data pillar → /d (harmless if not present)
sed -i \
  -e 's/href="d"/href="\/d"/g' \
  -e 's/href="\.\/d"/href="\/d"/g' \
  -e 's/href="d\/"/href="\/d"/g' \
  "$FILE"

# Keep everything inside the PWA window
sed -i 's/target="_blank"//g' "$FILE"

echo "Done. Links nudged to /c, /b, /d and targets cleaned."
