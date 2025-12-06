#!/data/data/com.termux/files/usr/bin/bash
set -e

cd "$(dirname "$0")"

OUT="recent_releases.json"
MAX=12

# Only html in this folder, newest first
FILES=$(ls -1t *.html 2>/dev/null | head -n "$MAX" || true)

echo "[" > "$OUT"
i=0
for f in $FILES; do
  i=$((i+1))
  # crude "title" from filename
  title="${f%.html}"
  title="${title//_/ }"
  title="${title//-/ }"

  comma=","
  [ "$i" -eq "$(echo "$FILES" | wc -l)" ] && comma=""

  printf '  {"file":"%s","title":"%s"}%s\n' "$f" "$title" "$comma" >> "$OUT"
done
echo "]" >> "$OUT"

echo "✅ Wrote $OUT with up to $MAX entries."
