#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
cd "$ROOT"

# Detect likely pages (safe defaults)
GH="growthhub.html"
GHT="growthhub_official_top5.html"
MA="qds_revenue_floor_v2.html"

BAT_DEMO="qds_battery_habitat_demo.html"
BAT_H12="qds_battery_habitat_v1_2_build002.html"
BAT_DES="qds_battery_design_v1.html"
COMP="qds_compression_lab_v1.html"

ALLC="all_pages_compact.html"
ALLL="all_pages.html"
INDEX="index.html"
FRONT="frontdoor.html"

pick () { [[ -f "$1" ]] && echo "$1" || echo ""; }

GH=$(pick "$GH")
GHT=$(pick "$GHT")
MA=$(pick "$MA")
BAT_DEMO=$(pick "$BAT_DEMO")
BAT_H12=$(pick "$BAT_H12")
BAT_DES=$(pick "$BAT_DES")
COMP=$(pick "$COMP")
ALLC=$(pick "$ALLC")
ALLL=$(pick "$ALLL")

build_page () {
  local OUT="$1"
  cat > "$OUT" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>QDS Front Door</title>
<style>
:root{color-scheme:dark;}
body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;
background:#070b14;color:#e9f1ff}
.wrap{max-width:820px;margin:0 auto;padding:22px}
.badge{display:inline-block;padding:6px 10px;border:1px solid #22324c;
border-radius:999px;font-size:12px;opacity:.85;margin:0 6px 6px 0}
.h1{font-size:34px;line-height:1.1;margin:10px 0 6px}
.sub{opacity:.75;margin:0 0 18px}
.card{background:linear-gradient(180deg,#0d1424,#090f1c);
border:1px solid #1c2b44;border-radius:18px;padding:18px;margin:14px 0}
.btn{display:inline-block;margin:8px 8px 0 0;padding:12px 14px;
border-radius:12px;border:1px solid #2a3e5f;text-decoration:none;color:#e9f1ff;
background:#0d1a33}
.btn:hover{filter:brightness(1.08)}
.small{font-size:12px;opacity:.7}
hr{border:0;border-top:1px solid #1a2740;margin:18px 0}
</style>
</head>
<body>
<div class="wrap">
  <span class="badge">Termux-first</span>
  <span class="badge">Proof → Pilot → Claim</span>
  <span class="badge">Local demo hub</span>

  <div class="h1">QDS Demo Front Door</div>
  <div class="sub">Clean index rebuild. Links only — no script output.</div>

  <div class="card">
    <b>Growth / Revenue</b><br/>
HTML

  [[ -n "$GH"  ]] && echo "    <a class=\"btn\" href=\"$GH\">GrowthHub</a>" >> "$OUT"
  [[ -n "$GHT" ]] && echo "    <a class=\"btn\" href=\"$GHT\">GrowthHub Top 5</a>" >> "$OUT"
  [[ -n "$MA"  ]] && echo "    <a class=\"btn\" href=\"$MA\">Multi-Area Stack</a>" >> "$OUT"

  cat >> "$OUT" <<HTML
  </div>

  <div class="card">
    <b>Batteries</b><br/>
HTML

  [[ -n "$BAT_DEMO" ]] && echo "    <a class=\"btn\" href=\"$BAT_DEMO\">Battery Habitat (Demo)</a>" >> "$OUT"
  [[ -n "$BAT_H12"  ]] && echo "    <a class=\"btn\" href=\"$BAT_H12\">Battery Habitat v1.2</a>" >> "$OUT"
  [[ -n "$BAT_DES"  ]] && echo "    <a class=\"btn\" href=\"$BAT_DES\">Battery Design</a>" >> "$OUT"

  cat >> "$OUT" <<HTML
  </div>

  <div class="card">
    <b>Compression / Signals</b><br/>
HTML
  [[ -n "$COMP" ]] && echo "    <a class=\"btn\" href=\"$COMP\">Compression Lab</a>" >> "$OUT"

  cat >> "$OUT" <<HTML
  </div>

  <hr/>

  <div class="card">
    <b>All pages</b><br/>
HTML
  [[ -n "$ALLL" ]] && echo "    <a class=\"btn\" href=\"$ALLL\">All pages (list)</a>" >> "$OUT"
  [[ -n "$ALLC" ]] && echo "    <a class=\"btn\" href=\"$ALLC\">All pages (compact)</a>" >> "$OUT"

  cat >> "$OUT" <<HTML
    <div class="small">Tip: This page only links — it never injects bash text.</div>
  </div>

</div>
</body>
</html>
HTML
}

build_page "$INDEX"
build_page "$FRONT"

echo "✅ Rebuilt: $ROOT/$INDEX"
echo "✅ Rebuilt: $ROOT/$FRONT"
echo "🌐 Open:"
echo "   http://127.0.0.1:8011/index.html"
echo "   http://127.0.0.1:8011/frontdoor.html"
