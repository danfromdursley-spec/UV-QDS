#!/data/data/com.termux/files/usr/bin/bash
set -e

# ---------------------------------------------
# 🎩 QDS Offer Link Injector v1 (SAFE MODE)
# - Finds latest qds_offer_bundle_v1_*.html
# - Injects a tidy "Offer" card into:
#     growthhub.html
#     growthhub_official_top5.html
#     index.html
# - DOES NOT overwrite originals.
# - Writes timestamped copies instead.
# ---------------------------------------------

DIR="$HOME/OMEGA_EMPIRE/UV_QDS/www"
cd "$DIR"

STAMP="$(date +"%Y%m%d_%H%M%S")"

OFFER="$(ls -1t qds_offer_bundle_v1_*.html 2>/dev/null | head -n 1 || true)"
if [[ -z "$OFFER" ]]; then
  echo "No Offer bundle found."
  echo "Run: ./qds_make_offer_page_v1.sh first."
  exit 0
fi

# Targets in your requested order
TARGETS=("growthhub.html" "growthhub_official_top5.html" "index.html")

# Build an injection block that won’t look cursed even if CSS differs
BLOCK_FILE="$(mktemp)"
cat > "$BLOCK_FILE" <<EOF
<!-- QDS_OFFER_BUNDLE_BLOCK_START -->
<section style="
  margin: 18px 0;
  padding: 16px 14px;
  border-radius: 12px;
  border: 1px solid rgba(255,255,255,0.08);
  background: rgba(255,255,255,0.03);
">
  <div style="font-size:11px; letter-spacing:.08em; text-transform:uppercase; opacity:.75;">
    GrowthHub • Offer
  </div>
  <h2 style="margin:6px 0 8px; font-size:20px;">
    QDS Offer Bundle (Demo • Pilot • Pricing • Metrics)
  </h2>
  <div style="opacity:.8; font-size:13px; line-height:1.4;">
    The boardroom-safe single page that unites the three commercial pillars
    with a proof-first ladder and measurable KPIs.
  </div>
  <div style="margin-top:10px; display:flex; gap:8px; flex-wrap:wrap;">
    <a href="./$OFFER" style="
      display:inline-block; text-decoration:none;
      padding:10px 12px; border-radius:10px;
      border:1px solid rgba(255,255,255,0.12);
      background: rgba(255,255,255,0.06);
      color: inherit;
    ">Open Offer Bundle</a>
    <span style="font-size:11px; opacity:.7; align-self:center;">
      Auto-linked: $OFFER
    </span>
  </div>
</section>
<!-- QDS_OFFER_BUNDLE_BLOCK_END -->
EOF

inject_into_copy () {
  local IN="$1"
  local OUT="$2"

  # If the block already exists, just copy unchanged
  if grep -q "QDS_OFFER_BUNDLE_BLOCK_START" "$IN" 2>/dev/null; then
    cp "$IN" "$OUT"
    return 0
  fi

  # Insert right before </body> if present; else append at end
  if grep -qi "</body>" "$IN"; then
    awk -v blockfile="$BLOCK_FILE" '
      BEGIN{
        inserted=0
        while ((getline line < blockfile) > 0) {
          block = block line "\n"
        }
        close(blockfile)
      }
      {
        if (!inserted && tolower($0) ~ /<\/body>/) {
          printf "%s", block
          inserted=1
        }
        print
      }
      END{
        if (!inserted) {
          printf "%s", block
        }
      }
    ' "$IN" > "$OUT"
  else
    cat "$IN" "$BLOCK_FILE" > "$OUT"
  fi
}

echo "🎩 QDS Offer Link Injector v1"
echo "DIR: $DIR"
echo "Offer detected:"
echo " - $OFFER"
echo

CREATED=()

for T in "${TARGETS[@]}"; do
  if [[ ! -f "$T" ]]; then
    echo "⚠️ Missing target: $T"
    continue
  fi

  BASE="${T%.html}"
  OUT="${BASE}_with_offer_${STAMP}.html"

  inject_into_copy "$T" "$OUT"
  CREATED+=("$OUT")

  echo "✅ Created: $OUT"
done

rm -f "$BLOCK_FILE"

echo
echo "Open locally:"
for f in "${CREATED[@]}"; do
  echo " - http://127.0.0.1:8011/$f"
done

echo
echo "Done. Originals untouched. 🎩"
