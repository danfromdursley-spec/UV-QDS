#!/data/data/com.termux/files/usr/bin/bash
set -e

DIR="$HOME/OMEGA_EMPIRE/UV_QDS/www"
cd "$DIR"

echo "🎩 QDS Activate-All (micro)"
echo "DIR: $DIR"
echo

run_if() {
  local f="$1"
  if [[ -x "$f" ]]; then
    echo "▶ Running: $f"
    ./"$f"
    echo
  elif [[ -f "$f" ]]; then
    echo "▶ Making executable + running: $f"
    chmod +x "$f"
    ./"$f"
    echo
  else
    echo "… Skipping (not found): $f"
  fi
}

# 1) Offer builder (if you named it something like this)
run_if "qds_offer_page_builder_v1.sh"
run_if "qds_offer_bundle_v1.sh"
run_if "make_offer_page_v1.sh"

# 2) Inject Offer page into GrowthHub/Top5/Index
run_if "qds_inject_offer_links_v1.sh"

# 3) Rebuild hub/index helpers (if you want)
run_if "make_qds_hub_pro.sh"
run_if "make_qds_index_v2.sh"
run_if "make_qds_index.sh"

# 4) Link GrowthHub -> Forecast + Compression
run_if "qds_growthhub_autolink_v1.sh"

# 5) Quick “latest” outputs
latest() { ls -1t "$1" 2>/dev/null | head -n 1 || true; }

GH_LINKED="$(latest "growthhub_linked_*.html")"
GH_OFFER="$(latest "*growthhub*with*offer*.html")"
IDX_OFFER="$(latest "*index*with*offer*.html")"

echo "✅ Latest outputs detected:"
[[ -n "$GH_LINKED" ]] && echo " - Linked GrowthHub : $GH_LINKED"
[[ -n "$GH_OFFER"  ]] && echo " - GrowthHub+Offer  : $GH_OFFER"
[[ -n "$IDX_OFFER" ]] && echo " - Index+Offer      : $IDX_OFFER"
echo

echo "🌐 Open (if server is running on 8011):"
[[ -n "$GH_LINKED" ]] && echo " http://127.0.0.1:8011/$GH_LINKED"
[[ -n "$GH_OFFER"  ]] && echo " http://127.0.0.1:8011/$GH_OFFER"
[[ -n "$IDX_OFFER" ]] && echo " http://127.0.0.1:8011/$IDX_OFFER"
echo

echo "Done. Originals remain untouched. 🎩"
