#!/data/data/com.termux/files/usr/bin/bash
cd ~/OMEGA_EMPIRE/UV_QDS || exit 1

OUT="QDS_INVENTORY_SNAPSHOT.md"
ROOTS=("www" ".")

echo "# QDS Inventory Snapshot" > "$OUT"
echo "Generated: $(date)" >> "$OUT"
echo "" >> "$OUT"

echo "## Key locations" >> "$OUT"
echo "- UV_QDS root: ~/OMEGA_EMPIRE/UV_QDS" >> "$OUT"
echo "- Web root  : ~/OMEGA_EMPIRE/UV_QDS/www" >> "$OUT"
echo "" >> "$OUT"

echo "## HTML (www)" >> "$OUT"
ls -1 www/*.html 2>/dev/null | sed 's|^www/|- |' >> "$OUT"
echo "" >> "$OUT"

echo "## Recent files (last 7 days)" >> "$OUT"
find . -type f -mtime -7 2>/dev/null | sed 's|^\./|- |' >> "$OUT"
echo "" >> "$OUT"

echo "## Top-level docs" >> "$OUT"
ls -1 *.md *.txt *.pdf *.docx 2>/dev/null | sed 's|^|- |' >> "$OUT"
echo "" >> "$OUT"

echo "## Counts" >> "$OUT"
echo "- Total files: $(find . -type f 2>/dev/null | wc -l)" >> "$OUT"
echo "- HTML files : $(find www -name '*.html' 2>/dev/null | wc -l)" >> "$OUT"

echo "✅ Wrote $OUT"
