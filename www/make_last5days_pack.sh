#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="."
OUT_HTML="last5days_index.html"
STAMP=$(date +%Y%m%d_%H%M%S)
ZIP_NAME="last5days_html_$STAMP.zip"

# 1) Collect all .html touched in last 5 days
FILES=$(find "$ROOT" -type f -name '*.html' -mtime -5 | sort)

echo "Found the following HTML files (last 5 days):"
echo "$FILES"
echo

# 2) Build index HTML
cat > "$OUT_HTML" << 'HEAD'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>QDS / Ω – Last 5 Days</title>
  <style>
    body { background:#050510; color:#f5f5ff; font-family:system-ui, sans-serif; padding:20px; }
    h1 { color:#7cf3ff; }
    ul { list-style:none; padding-left:0; }
    li { margin:6px 0; }
    a { color:#8bff9c; text-decoration:none; }
    a:hover { text-decoration:underline; }
    .path { color:#888; font-size:0.8em; }
  </style>
</head>
<body>
  <h1>QDS / Ω – Last 5 Days HTML</h1>
  <p>Auto-generated index of pages modified in the last 5 days.</p>
  <ul>
HEAD

# 3) Add entries
while IFS= read -r f; do
  rel="${f#./}"
  echo "    <li><a href=\"$rel\" target=\"_blank\">$rel</a></li>" >> "$OUT_HTML"
done <<< "$FILES"

cat >> "$OUT_HTML" << 'TAIL'
  </ul>
</body>
</html>
TAIL

echo "Wrote index: $OUT_HTML"

# 4) Zip them all for safekeeping/showcase
echo "$FILES" | zip -@ "$ZIP_NAME" > /dev/null
echo "Created zip: $ZIP_NAME"

echo "Done. Open last5days_index.html in your browser or serve via your usual python -m http.server."
