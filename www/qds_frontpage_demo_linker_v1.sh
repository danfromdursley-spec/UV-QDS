#!/data/data/com.termux/files/usr/bin/bash
set -e

DIR="$HOME/OMEGA_EMPIRE/UV_QDS/www"
cd "$DIR"

stamp="$(date +%Y%m%d_%H%M%S)"

pick_first() {
  for f in "$@"; do
    [[ -f "$f" ]] && { echo "$f"; return 0; }
  done
  echo ""
}

# --- pick best demo targets (change order anytime) ---
DEMO_BAT="$(pick_first \
  qds_battery_habitat_v1_2_build002.html \
  qds_battery_habitat_v1_1_build_001.html \
  qds_battery_habitat_demo.html \
  qds_battery_suite_v8_nextlevel.html \
  qds_battery_suite_v6_realworld.html \
)"

DEMO_COMP="$(pick_first \
  qds_compression_lab_v1.html \
  qds_compression_lab_v1_1.html \
)"

ALLP="$(pick_first \
  all_pages_compact.html \
  all_pages.html \
  all_pages_min.html \
)"

# fallback if all-pages not present
[[ -z "$ALLP" ]] && ALLP="index.html"

build_front_block() {
cat <<HTML
<!-- QDS_AUTO_DEMO_BLOCK_START -->
<section style="margin:18px 0 10px 0;">
  <div class="card" style="padding:16px;">
    <div style="font-size:1.05rem; opacity:0.85; margin-bottom:10px;">
      Demo Highlights (auto-linked)
    </div>
    <div style="display:flex; flex-wrap:wrap; gap:10px;">
      ${DEMO_BAT:+<a class="btn" href="$DEMO_BAT">Battery Habitat (demo)</a>}
      ${DEMO_COMP:+<a class="btn" href="$DEMO_COMP">Compression / Signals</a>}
      <a class="btn" href="$ALLP">All Pages Library</a>
    </div>
    <div style="margin-top:8px; font-size:0.85rem; opacity:0.6;">
      Curated front-page demos. Full catalog one tap away.
    </div>
  </div>
</section>
<!-- QDS_AUTO_DEMO_BLOCK_END -->
HTML
}

inject_block() {
  local in="$1"
  local out="${in%.html}_demo_front_${stamp}.html"

  [[ ! -f "$in" ]] && { echo "… Missing: $in"; return 0; }

  # remove old block if exists
  sed '/QDS_AUTO_DEMO_BLOCK_START/,/QDS_AUTO_DEMO_BLOCK_END/d' "$in" > ".tmp_$stamp"

  # inject after <body ...> if possible, else prepend
  if grep -qi "<body" ".tmp_$stamp"; then
    awk -v block="$(build_front_block | sed 's/"/\\"/g')" '
      BEGIN{IGNORECASE=1}
      /<body[^>]*>/ && !done {
        print $0
        print block
        done=1
        next
      }
      {print}
    ' ".tmp_$stamp" > "$out"
  else
    { build_front_block; cat ".tmp_$stamp"; } > "$out"
  fi

  rm -f ".tmp_$stamp"
  echo "✅ Built: $out"
}

echo "🎩 Demo-front linker"
echo "Battery demo : ${DEMO_BAT:-NONE}"
echo "Compression  : ${DEMO_COMP:-NONE}"
echo "All pages    : $ALLP"
echo

# front pages you mentioned
inject_block "growthhub.html"
inject_block "growthhub_official_top5.html"
inject_block "index.html"

echo
echo "🌐 Open examples (8011):"
for f in *"_demo_front_${stamp}.html"; do
  echo " http://127.0.0.1:8011/$f"
done
