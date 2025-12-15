#!/data/data/com.termux/files/usr/bin/bash
set -e

DIR="$HOME/OMEGA_EMPIRE/UV_QDS/www"
STAMP="$(date +"%Y%m%d_%H%M%S")"

cd "$DIR"

echo "🎩 QDS GrowthHub Auto-Linker v1"
echo "DIR: $DIR"
echo

# --------- helpers ---------
pick_newest() {
  # usage: pick_newest "regex"
  ls -1t *.html 2>/dev/null | grep -i -E "$1" | head -n 1 || true
}

find_dashboard() {
  # strongest signal first
  local f
  f="$(grep -Ril "Pilot Lite — software baseline" ./*.html 2>/dev/null | head -n 1 || true)"
  [[ -n "$f" ]] && basename "$f" && return 0

  # fallback naming heuristics
  pick_newest "operator|founder|fleet|storage|reliability"
}

# --------- auto-pick targets ---------
DASH="$(find_dashboard)"
FORE="$(pick_newest "forecast|battery.*forecast|habitat")"
COMP="$(pick_newest "compress|save|telemetry|data")"

echo "Detected:"
echo " - Dashboard : ${DASH:-NONE}"
echo " - Forecast  : ${FORE:-NONE}"
echo " - Compress  : ${COMP:-NONE}"
echo

if [[ -z "$DASH" ]]; then
  echo "❌ Could not find a dashboard page. Add 'Pilot Lite — software baseline' text or rename with operator/fleet/founder."
  exit 1
fi

if [[ -z "$FORE" || -z "$COMP" ]]; then
  echo "❌ Missing Forecast or Compression target."
  echo "   Tip filenames: include 'forecast' and 'save' or 'compress'."
  exit 1
fi

OUT="${DASH%.html}_linked_${STAMP}.html"
cp "$DASH" "$OUT"

# --------- attempt direct button swaps ---------
# This assumes buttons are simple <button ...>TEXT</button> lines.
sed -i -E \
  -e "s@<button([^>]*)>Pilot Lite — software baseline</button>@<a class=\"btn\" href=\"./$FORE\">Pilot Lite — software baseline</a>@g" \
  -e "s@<button([^>]*)>Pilot Plus — add modular stack</button>@<a class=\"btn\" href=\"./$DASH\">Pilot Plus — add modular stack</a>@g" \
  -e "s@<button([^>]*)>Fleet Data Efficiency — retention \\+ learning</button>@<a class=\"btn\" href=\"./$COMP\">Fleet Data Efficiency — retention + learning</a>@g" \
  "$OUT"

# --------- fallback injection if swaps didn't land ---------
if ! grep -q "Pilot Lite — software baseline</a>" "$OUT"; then
  TMP="${OUT}.tmp"

  awk -v FORE="$FORE" -v COMP="$COMP" '
    BEGIN {done=0}
    {
      print $0
      if (!done && $0 ~ /<body[^>]*>/) {
        print "\n<!-- QDS Auto-Links Injected -->"
        print "<section class=\"card\" style=\"margin:16px 0;\">"
        print "  <div class=\"tag\">GrowthHub • Quick Links</div>"
        print "  <h3 style=\"margin:6px 0 10px 0;\">Pilot entry points</h3>"
        print "  <div style=\"display:flex;flex-wrap:wrap;gap:10px;\">"
        print "    <a class=\"btn\" href=\"./" FORE "\">Pilot Lite — software baseline</a>"
        print "    <a class=\"btn\" href=\"#roadmap\">Pilot Plus — add modular stack</a>"
        print "    <a class=\"btn\" href=\"./" COMP "\">Fleet Data Efficiency — retention + learning</a>"
        print "  </div>"
        print "  <div class=\"muted\" style=\"margin-top:8px;\">Auto-linked for demo flow. Original file unchanged.</div>"
        print "</section>\n"
        done=1
      }
    }
  ' "$OUT" > "$TMP"

  mv "$TMP" "$OUT"
fi

# --------- report ---------
echo "✅ Created linked copy:"
echo " - $OUT"
echo
echo "Targets used:"
echo " - Forecast  -> $FORE"
echo " - Compress  -> $COMP"
echo
echo "Open:"
echo " http://127.0.0.1:8011/$OUT"
echo
echo "Done. Your original remains untouched. 🎩"
