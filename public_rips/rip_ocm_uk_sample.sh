#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

: "${OCM_KEY:?Set OCM_KEY first (export OCM_KEY=...)}"

OUT="$HOME/OMEGA_EMPIRE/UV_QDS/public_rips/ocm_charge_map"
STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# UK centre-ish sample (you can change lat/lon or make it Stroud)
LAT="51.5"
LON="-0.12"
DIST_KM="25"

mkdir -p "$OUT"

URL="https://api.openchargemap.io/v3/poi/?output=json&latitude=${LAT}&longitude=${LON}&distance=${DIST_KM}&distanceunit=KM&maxresults=200&compact=true&verbose=false"

curl -LfsS -H "X-API-Key: $OCM_KEY" "$URL" -o "$OUT/uk_sample.json"

cat > "$OUT/manifest.json" <<JSON
{
  "source":"Open Charge Map (UK sample)",
  "timestamp_utc":"$STAMP",
  "query":{"lat":$LAT,"lon":$LON,"distance_km":$DIST_KM,"maxresults":200},
  "url":"$URL",
  "file":"uk_sample.json"
}
JSON

echo "[ok] OCM rip -> $OUT"
