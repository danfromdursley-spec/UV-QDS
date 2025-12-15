#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT="$(pwd)"

# ---- helper: pick newest matching html by name fragment ----
pick_latest() {
  local pattern="$1"
  local found
  found="$(ls -1t ./*"${pattern}"*.html 2>/dev/null | head -n 1 || true)"
  if [[ -n "$found" ]]; then
    echo "${found#./}"
  else
    echo ""
  fi
}

# ---- detect key pages (newest wins) ----
GROWTH="$(pick_latest "growthhub")"
HABITAT="$(pick_latest "battery_habitat")"
DESIGN="$(pick_latest "battery_design")"

# Friendly fallbacks if your naming drifts
[[ -z "$GROWTH"  ]] && [[ -f "growthhub.html" ]] && GROWTH="growthhub.html"
[[ -z "$HABITAT" ]] && [[ -f "qds_battery_habitat_demo.html" ]] && HABITAT="qds_battery_habitat_demo.html"
[[ -z "$DESIGN"  ]] && [[ -f "qds_battery_design_v1.html" ]] && DESIGN="qds_battery_design_v1.html"

TS="$(date '+%Y-%m-%d %H:%M:%S')"

# ---- collect all html files for indexes ----
mapfile -t HTML_FILES < <(ls -1 *.html 2>/dev/null | sort)

# Exclude generated outputs from listing loops
is_generated() {
  local f="$1"
  [[ "$f" == "index.html" || "$f" == "all_pages_index.html" || "$f" == "all_pages_min.html" ]]
}

# ---- build index.html (PRO hub) ----
cat > index.html <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>QDS Demo Hub</title>
<style>
:root{
  --bg:#070b12; --panel:#0b1220; --panel2:#0d1628;
  --text:#e9eef7; --muted:#a7b4c7; --accent:#7aa2ff; --good:#7dffb3;
  --stroke:#1d2a40; --soft:rgba(255,255,255,0.04);
  --radius:16px;
}
*{box-sizing:border-box}
body{
  margin:0; background:
    radial-gradient(1200px 600px at 10% 10%, #0f1a2e 0%, transparent 55%),
    radial-gradient(1200px 600px at 90% 20%, #0c1f2c 0%, transparent 60%),
    var(--bg);
  color:var(--text); font-family:system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,Cantarell,"Noto Sans",sans-serif;
}
.wrap{max-width:980px; margin:0 auto; padding:28px 18px 60px;}
.topbar{display:flex; gap:10px; flex-wrap:wrap; align-items:center; margin-bottom:18px;}
.chip{
  padding:8px 12px; border-radius:999px; border:1px solid var(--stroke);
  background:linear-gradient(180deg,var(--soft),transparent);
  font-size:12px; color:var(--muted); letter-spacing:.2px;
}
.hero{
  background:linear-gradient(135deg,var(--panel),var(--panel2));
  border:1px solid var(--stroke); border-radius:var(--radius);
  padding:28px 22px; box-shadow:0 10px 40px rgba(0,0,0,.35);
}
.hero h1{margin:0 0 6px; font-size:34px; letter-spacing:.3px;}
.hero p{margin:6px 0 0; color:var(--muted); line-height:1.45;}
.grid{display:grid; gap:14px; margin-top:18px;}
@media(min-width:760px){ .grid{grid-template-columns:1fr 1fr 1fr;} }

.card{
  background:linear-gradient(180deg,var(--panel),#0a1426);
  border:1px solid var(--stroke); border-radius:var(--radius);
  padding:18px 16px 16px;
}
.card h3{margin:0 0 6px; font-size:20px;}
.card p{margin:0 0 14px; color:var(--muted); font-size:13.5px; line-height:1.4;}

.btn{
  display:inline-flex; align-items:center; justify-content:center;
  width:100%; padding:12px 12px;
  border-radius:12px; border:1px solid var(--stroke);
  background:linear-gradient(135deg,#101e35,#0b1a33);
  color:var(--text); text-decoration:none; font-weight:600; font-size:14px;
}
.btn:hover{filter:brightness(1.08)}
.btn.good{
  border-color:rgba(125,255,179,.35);
  background:linear-gradient(135deg,#0e2a22,#0b1c24);
}
.small{font-size:11.5px; color:var(--muted); opacity:.8}

.section{
  margin-top:22px;
  background:linear-gradient(180deg,#0a1222,#080f1d);
  border:1px solid var(--stroke); border-radius:var(--radius);
  padding:16px;
}
.row{display:flex; gap:10px; flex-wrap:wrap;}
.row a{min-width:180px; flex:1}

.footer{
  margin-top:24px; color:var(--muted); font-size:11.5px;
  opacity:.75;
}
</style>
</head>
<body>
<div class="wrap">
  <div class="topbar">
    <span class="chip">Termux-first</span>
    <span class="chip">Demo → Pilot → Claim</span>
    <span class="chip">Operator build</span>
    <span class="chip">Auto-detect newest pages</span>
  </div>

  <div class="hero">
    <h1>QDS Demo Hub</h1>
    <p>Fast-launch for your live Battery + Growth assets.
    Designed for clean screenshots, calm credibility, and pilot-ready navigation.</p>
    <div class="small">Generated ${TS}</div>
  </div>

  <div class="grid">
    <div class="card">
      <h3>Growth Hub</h3>
      <p>Founder/operator narrative, pilot ladder, and commercialisation framing.
      Built to be investor-safe without losing engineering grit.</p>
EOF

if [[ -n "$GROWTH" ]]; then
cat >> index.html <<EOF
      <a class="btn good" href="${GROWTH}">Open ${GROWTH}</a>
      <div class="small">Auto-picked newest growthhub match.</div>
EOF
else
cat >> index.html <<EOF
      <span class="small">Not detected. Name a file with <b>growthhub</b>.</span>
EOF
fi

cat >> index.html <<EOF
    </div>

    <div class="card">
      <h3>Battery Habitat</h3>
      <p>Architecture toggles, assumption audit, pack concept UI,
      and the credibility-capped uplift estimator.</p>
EOF

if [[ -n "$HABITAT" ]]; then
cat >> index.html <<EOF
      <a class="btn" href="${HABITAT}">Open ${HABITAT}</a>
      <div class="small">Auto-picked newest battery_habitat match.</div>
EOF
else
cat >> index.html <<EOF
      <span class="small">Not detected. Name a file with <b>battery_habitat</b>.</span>
EOF
fi

cat >> index.html <<EOF
    </div>

    <div class="card">
      <h3>Battery Design</h3>
      <p>Design stack narrative, materials/thermal story,
      modular roadmap, and integration logic for pilots.</p>
EOF

if [[ -n "$DESIGN" ]]; then
cat >> index.html <<EOF
      <a class="btn" href="${DESIGN}">Open ${DESIGN}</a>
      <div class="small">Auto-picked newest battery_design match.</div>
EOF
else
cat >> index.html <<EOF
      <span class="small">Not detected. Name a file with <b>battery_design</b>.</span>
EOF
fi

cat >> index.html <<EOF
    </div>
  </div>

  <div class="section">
    <h3 style="margin:0 0 10px;">All pages</h3>
    <div class="row">
      <a class="btn" href="all_pages_index.html">All pages (list)</a>
      <a class="btn" href="all_pages_min.html">All pages (compact)</a>
    </div>
    <div class="small" style="margin-top:8px;">
      Tip: keep using <b>growthhub</b> / <b>battery_habitat</b> / <b>battery_design</b> in filenames.
    </div>
  </div>

  <div class="footer">
    This hub is a launch surface, not a claim engine.
    Use it to frame the pilot story and keep numbers within credibility bands.
  </div>
</div>
</body>
</html>
EOF

# ---- build all_pages_index.html (list) ----
cat > all_pages_index.html <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>All Pages · QDS</title>
<style>
body{margin:0;background:#070b12;color:#e9eef7;font-family:system-ui}
.wrap{max-width:900px;margin:0 auto;padding:24px 16px 60px}
h1{margin:0 0 6px;font-size:26px}
.small{opacity:.65;font-size:12px}
ul{list-style:none;padding:0;margin:14px 0 0}
li{margin:8px 0;padding:10px 12px;border:1px solid #1d2a40;border-radius:12px;background:#0b1220}
a{color:#9ec0ff;text-decoration:none;font-weight:600}
a:hover{text-decoration:underline}
</style>
</head>
<body>
<div class="wrap">
  <h1>All HTML pages</h1>
  <div class="small">Generated ${TS}</div>
  <ul>
EOF

for f in "${HTML_FILES[@]}"; do
  is_generated "$f" && continue
  echo "    <li><a href=\"$f\">$f</a></li>" >> all_pages_index.html
done

cat >> all_pages_index.html <<EOF
  </ul>
</div>
</body>
</html>
EOF

# ---- build all_pages_min.html (compact) ----
cat > all_pages_min.html <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>All Pages (Min) · QDS</title>
<style>
body{margin:0;background:#070b12;color:#e9eef7;font-family:system-ui}
.wrap{max-width:900px;margin:0 auto;padding:22px 16px 60px}
h1{margin:0 0 6px;font-size:22px}
.small{opacity:.6;font-size:11px;margin-bottom:10px}
a{display:inline-block;margin:6px 8px 0 0;padding:8px 10px;border-radius:10px;
  border:1px solid #1d2a40;background:#0b1220;color:#9ec0ff;text-decoration:none;font-weight:600;font-size:12px}
a:hover{filter:brightness(1.08)}
</style>
</head>
<body>
<div class="wrap">
  <h1>All pages (compact)</h1>
  <div class="small">Generated ${TS}</div>
EOF

for f in "${HTML_FILES[@]}"; do
  is_generated "$f" && continue
  echo "  <a href=\"$f\">$f</a>" >> all_pages_min.html
done

cat >> all_pages_min.html <<EOF
</div>
</body>
</html>
EOF

echo "✅ Built: index.html / all_pages_index.html / all_pages_min.html"
echo "Detected:"
echo " - Growth : ${GROWTH:-NONE}"
echo " - Habitat: ${HABITAT:-NONE}"
echo " - Design : ${DESIGN:-NONE}"
