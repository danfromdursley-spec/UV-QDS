#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

OUT="$HOME/OMEGA_EMPIRE/UV_QDS/public_rips/dft_ev_chargers"
STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

URL_STATS="https://www.gov.uk/government/collections/electric-vehicle-charging-infrastructure-statistics"
URL_DATA="https://findtransportdata.dft.gov.uk/dataset/electric-vehicle-charging-infrastructure-statistics-17eb4e7de79"

mkdir -p "$OUT"

curl -LfsS "$URL_STATS" -o "$OUT/collection.html"
curl -LfsS "$URL_DATA"  -o "$OUT/dataset.html"

cat > "$OUT/manifest.json" <<JSON
{
  "source":"DfT EV charging infrastructure statistics",
  "timestamp_utc":"$STAMP",
  "pages":[
    {"name":"govuk_collection","url":"$URL_STATS","file":"collection.html"},
    {"name":"findtransportdata_dataset","url":"$URL_DATA","file":"dataset.html"}
  ]
}
JSON

echo "[ok] DfT rip -> $OUT"
