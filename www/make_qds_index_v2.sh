#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

cd "${1:-$PWD}"

ts="$(date '+%Y-%m-%d %H:%M:%S')"

# All html in this folder (exclude generated)
mapfile -t HTML_FILES < <(find . -maxdepth 1 -type f -name "*.html" \
  ! -name "index.html" \
  ! -name "all_pages_index.html" \
  ! -name "all_pages_min.html" \
  -printf "%f\n" | sort)

# Helper: pick newest file matching pattern(s)
pick_newest () {
  local pattern="$1"
  ls -1t ./*.html 2>/dev/null | sed 's|^\./||' | grep -iE "$pattern" | head -n 1 || true
}

GROWTH="$(pick_newest 'growthhub')"
HABITAT="$(pick_newest 'battery_habitat|habitat')"
DESIGN="$(pick_newest 'battery_design|battery.*design|qds_battery_design')"

growth_btn='<span class="badge">Not detected</span>'
habitat_btn='<span class="badge">Not detected</span>'
design_btn='<span class="badge">Not detected</span>'

[[ -n "$GROWTH" ]]  && growth_btn="<a class=\"btn\" href=\"$GROWTH\">Open $GROWTH</a>"
[[ -n "$HABITAT" ]] && habitat_btn="<a class=\"btn\" href=\"$HABITAT\">Open $HABITAT</a>"
[[ -n "$DESIGN" ]]  && design_btn="<a class=\"btn\" href=\"$DESIGN\">Open $DESIGN</a>"

# -------- all_pages_index.html --------
{
cat <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>All Pages · QDS</title>
<style>
  body{margin:0;background:#070b12;color:#e9eef7;font-family:system-ui,-apple-system,Segoe UI,Roboto;}
  .wrap{max-width:920px;margin:0 auto;padding:22px 18px 60px;}
  h1{font-size:22px;margin:0 0 8px;}
  .small{font-size:12px;opacity:.65;margin-bottom:14px;}
  ul{list-style:none;padding:0;margin:14px 0 0;}
  li{margin:10px 0;}
  a{display:block;padding:10px 12px;border:1px solid #1d2a40;border-radius:12px;
    background:#0b1220;color:#e9eef7;text-decoration:none;font-weight:600;}
  a:hover{text-decoration:underline}
</style>
</head>
<body>
<div class="wrap">
  <h1>All HTML pages</h1>
  <div class="small">Generated $ts</div>
  <ul>
EOF

for f in "${HTML_FILES[@]}"; do
  echo "    <li><a href=\"$f\">$f</a></li>"
done

cat <<EOF
  </ul>
</div>
</body>
</html>
EOF
} > all_pages_index.html

# -------- all_pages_min.html --------
{
cat <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>All Pages (Min) · QDS</title>
<style>
  body{margin:0;background:#070b12;color:#e9eef7;font-family:system-ui;}
  .wrap{max-width:920px;margin:0 auto;padding:22px 18px 60px;}
  h1{font-size:20px;margin:0 0 8px;}
  .small{font-size:12px;opacity:.65;margin-bottom:14px;}
  a{display:inline-block;margin:6px 8px 0 0;padding:6px 8px;border-radius:8px;
    border:1px solid #223049;background:#0b1220;color:#e9eef7;text-decoration:none;}
</style>
</head>
<body>
<div class="wrap">
  <h1>All pages (compact)</h1>
  <div class="small">Generated $ts</div>
EOF

for f in "${HTML_FILES[@]}"; do
  echo "  <a href=\"$f\">$f</a>"
done

cat <<EOF
</div>
</body>
</html>
EOF
} > all_pages_min.html

# -------- index.html (clean + punchier) --------
cat > index.html <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>QDS Demo Hub</title>
<style>
  body{margin:0;background:radial-gradient(1200px 600px at 10% -10%, #13233d33, transparent), #070b12;
    color:#e9eef7;font-family:system-ui,-apple-system,Segoe UI,Roboto;}
  .wrap{max-width:980px;margin:0 auto;padding:26px 18px 70px;}
  .badge{display:inline-block;padding:6px 10px;border-radius:999px;
    background:#0b1220;border:1px solid #223049;font-size:11px;opacity:.9;margin:0 6px 8px 0;}
  h1{font-size:30px;margin:12px 0 6px;letter-spacing:.2px;}
  .sub{opacity:.72;margin:0 0 18px;}
  .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:12px;}
  .card{padding:16px;border-radius:14px;background:linear-gradient(180deg,#0b1220,#0a0f1a);
    border:1px solid #1d2a40;box-shadow:0 8px 24px #00000030;}
  .card h3{margin:0 0 8px;font-size:18px;}
  .card p{margin:0 0 12px;opacity:.78;font-size:13px;line-height:1.35;}
  a.btn{display:inline-block;padding:10px 12px;border-radius:10px;border:1px solid #223049;
    background:#0f1a2c;color:#e9eef7;text-decoration:none;font-weight:700;margin-right:8px;}
  a.btn:hover{text-decoration:underline}
  .foot{margin-top:22px;opacity:.6;font-size:12px;}
</style>
</head>
<body>
<div class="wrap">
  <span class="badge">Termux-first</span>
  <span class="badge">Proof → Pilot → Claim</span>
  <span class="badge">Operator build</span>

  <h1>QDS Demo Hub</h1>
  <p class="sub">Fast launch for your live pages. Generated $ts.</p>

  <div class="grid">
    <div class="card">
      <h3>Growth Hub</h3>
      <p>Investor-safe operator view: proof, pilot metrics, and commercialization path.</p>
      $growth_btn
    </div>

    <div class="card">
      <h3>Battery Habitat</h3>
      <p>UI architecture, assumptions audit, pack concepts, and demo framing.</p>
      $habitat_btn
    </div>

    <div class="card">
      <h3>Battery Design</h3>
      <p>Design stack, materials/thermal narrative, modular roadmap and integration logic.</p>
      $design_btn
    </div>

    <div class="card">
      <h3>All pages</h3>
      <p>Directory index for quick checking and screenshot runs.</p>
      <a class="btn" href="all_pages_index.html">All pages (list)</a>
      <a class="btn" href="all_pages_min.html">All pages (compact)</a>
    </div>
  </div>

  <div class="foot">
    Auto-picks the newest file matching: growthhub / habitat / design.
  </div>
</div>
</body>
</html>
EOF

echo "✅ Built: index.html / all_pages_index.html / all_pages_min.html"
echo "Detected:"
echo " - Growth : ${GROWTH:-NONE}"
echo " - Habitat: ${HABITAT:-NONE}"
echo " - Design : ${DESIGN:-NONE}"
