#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT="${1:-$PWD}"
cd "$ROOT"

ts="$(date '+%Y-%m-%d %H:%M:%S')"

# Collect HTML files in this folder (no subdirs)
mapfile -t HTML_FILES < <(find . -maxdepth 1 -type f -name "*.html" \
  ! -name "index.html" \
  ! -name "all_pages_index.html" \
  ! -name "all_pages_min.html" \
  -printf "%f\n" | sort)

# Detect key pages by naming convention
GROWTH="$(printf "%s\n" "${HTML_FILES[@]}" | grep -i "growthhub" | head -n 1 || true)"
HABITAT="$(printf "%s\n" "${HTML_FILES[@]}" | grep -i "battery_habitat\|habitat" | head -n 1 || true)"
DESIGN="$(printf "%s\n" "${HTML_FILES[@]}" | grep -i "battery_design\|design" | head -n 1 || true)"

# ---------- all_pages_index.html ----------
cat > all_pages_index.html <<EOF
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
  <div class="small">Generated ${ts}</div>
  <ul>
EOF

for f in "${HTML_FILES[@]}"; do
  echo "    <li><a href=\"$f\">$f</a></li>" >> all_pages_index.html
done

cat >> all_pages_index.html <<EOF
  </ul>
</div>
</body>
</html>
EOF

# ---------- all_pages_min.html ----------
cat > all_pages_min.html <<EOF
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
  <div class="small">Generated ${ts}</div>
EOF

for f in "${HTML_FILES[@]}"; do
  echo "  <a href=\"$f\">$f</a>" >> all_pages_min.html
done

cat >> all_pages_min.html <<EOF
</div>
</body>
</html>
EOF

# ---------- index.html ----------
cat > index.html <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>QDS Hub</title>
<style>
  body{margin:0;background:#070b12;color:#e9eef7;font-family:system-ui,-apple-system,Segoe UI,Roboto;}
  .wrap{max-width:980px;margin:0 auto;padding:26px 18px 70px;}
  .badge{display:inline-block;padding:6px 10px;border-radius:999px;
    background:#0b1220;border:1px solid #223049;font-size:11px;opacity:.9;margin-right:6px;}
  h1{font-size:28px;margin:10px 0 6px;}
  .sub{opacity:.7;margin:0 0 18px;}
  .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:12px;}
  .card{padding:14px 14px 16px;border-radius:14px;background:#0b1220;border:1px solid #1d2a40;}
  .card h3{margin:0 0 8px;font-size:18px;}
  .card p{margin:0 0 12px;opacity:.75;font-size:13px;line-height:1.35;}
  a.btn{display:inline-block;padding:10px 12px;border-radius:10px;border:1px solid #223049;
    background:#0f1a2c;color:#e9eef7;text-decoration:none;font-weight:700;}
  a.btn:hover{text-decoration:underline}
  .foot{margin-top:22px;opacity:.6;font-size:12px;}
</style>
</head>
<body>
<div class="wrap">
  <span class="badge">Termux-first</span>
  <span class="badge">Proof → Pilot → Claim</span>
  <span class="badge">Local demo hub</span>

  <h1>QDS Demo Hub</h1>
  <p class="sub">Quick launch for Battery + Growth pages. Generated ${ts}.</p>

  <div class="grid">
    <div class="card">
      <h3>Growth Hub</h3>
      <p>Investor-safe operator view: proof, pilot metrics, and path to commercialization.</p>
      EOF

if [[ -n "${GROWTH}" ]]; then
  echo "      <a class=\"btn\" href=\"${GROWTH}\">Open ${GROWTH}</a>" >> index.html
else
  echo "      <span class=\"badge\">Not detected</span>" >> index.html
fi

cat >> index.html <<EOF
    </div>

    <div class="card">
      <h3>Battery Habitat</h3>
      <p>UI architecture, assumptions audit, pack concepts, and demo framing.</p>
      EOF

if [[ -n "${HABITAT}" ]]; then
  echo "      <a class=\"btn\" href=\"${HABITAT}\">Open ${HABITAT}</a>" >> index.html
else
  echo "      <span class=\"badge\">Not detected</span>" >> index.html
fi

cat >> index.html <<EOF
    </div>

    <div class="card">
      <h3>Battery Design</h3>
      <p>Design stack, materials/thermal narrative, modular roadmap and integration logic.</p>
      EOF

if [[ -n "${DESIGN}" ]]; then
  echo "      <a class=\"btn\" href=\"${DESIGN}\">Open ${DESIGN}</a>" >> index.html
else
  echo "      <span class=\"badge\">Not detected</span>" >> index.html
fi

cat >> index.html <<EOF
    </div>

    <div class="card">
      <h3>All pages</h3>
      <p>Full directory index for fast checking and screenshot runs.</p>
      <a class="btn" href="all_pages_index.html">All pages (list)</a>
      <a class="btn" href="all_pages_min.html">All pages (compact)</a>
    </div>
  </div>

  <div class="foot">
    Tip: Name files with <b>growthhub</b>, <b>battery_habitat</b>, or <b>battery_design</b> to auto-detect.
  </div>
</div>
</body>
</html>
EOF

echo "✅ Built:"
echo " - index.html"
echo " - all_pages_index.html"
echo " - all_pages_min.html"
echo
echo "Detected:"
echo " - Growth : ${GROWTH:-NONE}"
echo " - Habitat: ${HABITAT:-NONE}"
echo " - Design : ${DESIGN:-NONE}"
