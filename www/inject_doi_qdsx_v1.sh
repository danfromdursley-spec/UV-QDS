#!/data/data/com.termux/files/usr/bin/bash
set -e

TARGET="portfolio_market_allinone_v1.html"

if [ ! -f "$TARGET" ]; then
  echo "❌ Missing: $TARGET"
  exit 1
fi

cp "$TARGET" "$TARGET.bak_$(date +%Y%m%d_%H%M%S)"

# If placeholder exists, replace it
sed -i 's/DOI_UVQDS_PENDING/10.5281\/zenodo.17771649/g' "$TARGET" || true

echo "✅ DOI patch applied to: $TARGET"
echo "Backup created."
