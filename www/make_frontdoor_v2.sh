#!/data/data/com.termux/files/usr/bin/bash
set -e

DIR="$(pwd)"
ts="$(date +%Y%m%d_%H%M%S)"

out="frontdoor.html"
bak="frontdoor_backup_${ts}.html"

# ---- helpers ----
exists() { [[ -n "$1" && -f "$1" ]]; }

latest_one() {
  # returns newest file matching glob (or empty)
  local g="$1"
  local f
  f=$(ls -1t $g 2>/dev/null | head -n 1 || true)
  [[ -f "$f" ]] && echo "$f" || echo ""
}

list_all() {
  # list files matching glob, newest-first
  local g="$1"
  ls -1t $g 2>/dev/null || true
}

# ---- detect newest per pillar ----
GH_NEW="$(latest_one "growthhub*.html")"
BAT_NEW="$(latest_one "qds_battery*.html")"
COMP_NEW="$(latest_one "qds_compression*.html")"

# ---- build "Latest 5 builds" across the three families ----
# We combine lists, de-dup, then take top 5 by mtime approximated by ordering.
# (Good enough for local demo; simple + dependency-free.)
tmp=".tmp_latest_${ts}.txt"
: > "$tmp"

list_all "growthhub*.html" >> "$tmp"
list_all "qds_battery*.html" >> "$tmp"
list_all "qds_compression*.html" >> "$tmp"

# Remove duplicates while preserving order
awk '!
seen[$0]++' "$tmp" | head -n 5 > ".tmp_latest5_${ts}.txt"

# ---- optional known hubs ----
ALLP_COMPACT="$(latest_one "all_pages_compact*.html")"
ALLP_INDEX="$(latest_one "all_pages_index*.html")"
TOP5="$(latest_one "growthhub_official_top5*.html")"
MULTI="$(latest_one "growthhub_multi_area_stack*.html")"

# ---- backup old frontdoor ----
if [[ -f "$out" ]]; then
  cp -f "$out" "$bak"
fi

# ---- write HTML ----
cat > "$out" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>QDS Demo Front Door</title>
<style>
:root{
  --bg:#060b1a; --panel:#0b132b; --panel2:#0a1022;
  --text:#eef2ff; --muted:#aab3c7;
  --accent:#5aa7ff; --accent2:#7ad3ff;
  --stroke:rgba(255,255,255,0.08);
  --radius:18px;
}
*{box-sizing:border-box}
body{
  margin:0; padding:22px 16px 40px;
  background: radial-gradient(1200px 800px at 15% 10%, #0d1b3e 0%, transparent 45%),
              radial-gradient(900px 700px at 85% 20%, #0b2a3b 0%, transparent 50%),
              var(--bg);
  color:var(--text);
  font-family: system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, sans-serif;
}
.wrap{max-width:900px; margin:0 auto;}
.badges{display:flex; gap:8px; flex-wrap:wrap; margin-bottom:14px;}
.badge{
  padding:6px 10px; border:1px solid var(--stroke);
  background: rgba(255,255,255,0.03);
  border-radius:999px; font-size:12px; color:var(--muted);
}
h1{font-size:36px; line-height:1.1; margin:8px 0 6px;}
.subtitle{color:var(--muted); margin:0 0 18px;}
.section{
  background: linear-gradient(180deg, rgba(255,255,255,0.03), rgba(255,255,255,0.01));
  border:1px solid var(--stroke);
  border-radius: var(--radius);
  padding:18px 16px;
  margin:14px 0;
}
.section h2{
  margin:0 0 10px;
  font-size:18px; letter-spacing:0.2px;
}
.grid{
  display:grid;
  grid-template-columns: 1fr;
  gap:10px;
}
@media(min-width:680px){
  .grid{grid-template-columns: 1fr 1fr;}
}
.btn{
  display:block;
  text-decoration:none;
  color:var(--text);
  padding:14px 14px;
  border-radius:14px;
  border:1px solid var(--stroke);
  background:
    linear-gradient(90deg, rgba(90,167,255,0.08), rgba(122,211,255,0.04)),
    rgba(255,255,255,0.02);
  font-weight:600;
}
.btn small{display:block; font-weight:500; color:var(--muted); margin-top:4px;}
.btn:hover{border-color: rgba(90,167,255,0.35);}
.latest{
  display:flex; flex-direction:column; gap:8px;
}
.latest a{
  text-decoration:none; color:var(--text);
  padding:10px 12px; border-radius:12px;
  border:1px solid var(--stroke);
  background: rgba(255,255,255,0.02);
  font-size:14px;
}
.hr{height:1px; background: var(--stroke); margin:16px 0 8px;}
.footer-note{color:var(--muted); font-size:12px; margin-top:8px;}
</style>
</head>
<body>
<div class="wrap">
  <div class="badges">
    <span class="badge">Termux-first</span>
    <span class="badge">Links-only</span>
    <span class="badge">Proof → Pilot → Claim</span>
    <span class="badge">Auto-detect v2</span>
  </div>

  <h1>QDS Demo Front Door</h1>
  <p class="subtitle">Clean launchpad for Growth + Battery + Compression. No script output — just safe links.</p>

  <div class="section">
    <h2>Latest 5 builds</h2>
    <div class="latest">
HTML

# insert latest 5 links
while IFS= read -r f; do
  [[ -n "$f" && -f "$f" ]] && echo "      <a href=\"$f\">$f</a>" >> "$out"
done < ".tmp_latest5_${ts}.txt"

cat >> "$out" <<HTML
    </div>
    <div class="footer-note">Auto-collected from growthhub*, qds_battery*, qds_compression*.</div>
  </div>

  <div class="section">
    <h2>Growth / Revenue</h2>
    <div class="grid">
HTML

if exists "$GH_NEW"; then
  cat >> "$out" <<HTML
      <a class="btn" href="$GH_NEW">GrowthHub (latest)
        <small>$GH_NEW</small>
      </a>
HTML
else
  cat >> "$out" <<HTML
      <span class="btn">GrowthHub (latest)
        <small>Not detected</small>
      </span>
HTML
fi

if exists "$TOP5"; then
  cat >> "$out" <<HTML
      <a class="btn" href="$TOP5">GrowthHub Top 5
        <small>$TOP5</small>
      </a>
HTML
fi

if exists "$MULTI"; then
  cat >> "$out" <<HTML
      <a class="btn" href="$MULTI">Multi-Area Stack
        <small>$MULTI</small>
      </a>
HTML
fi

cat >> "$out" <<HTML
    </div>
  </div>

  <div class="section">
    <h2>Batteries</h2>
    <div class="grid">
HTML

if exists "$BAT_NEW"; then
  cat >> "$out" <<HTML
      <a class="btn" href="$BAT_NEW">Battery (latest)
        <small>$BAT_NEW</small>
      </a>
HTML
else
  cat >> "$out" <<HTML
      <span class="btn">Battery (latest)
        <small>Not detected</small>
      </span>
HTML
fi

# Convenience links if your known names exist
for f in \
  "qds_battery_habitat_v1_2_build002.html" \
  "qds_battery_habitat_demo.html" \
  "qds_battery_design_v1.html"
do
  if [[ -f "$f" ]]; then
    cat >> "$out" <<HTML
      <a class="btn" href="$f">$f</a>
HTML
  fi
done

cat >> "$out" <<HTML
    </div>
  </div>

  <div class="section">
    <h2>Compression / Signals</h2>
    <div class="grid">
HTML

if exists "$COMP_NEW"; then
  cat >> "$out" <<HTML
      <a class="btn" href="$COMP_NEW">Compression (latest)
        <small>$COMP_NEW</small>
      </a>
HTML
else
  cat >> "$out" <<HTML
      <span class="btn">Compression (latest)
        <small>Not detected</small>
      </span>
HTML
fi

# your common lab name
if [[ -f "qds_compression_lab_v1.html" ]]; then
  cat >> "$out" <<HTML
      <a class="btn" href="qds_compression_lab_v1.html">Compression Lab
        <small>qds_compression_lab_v1.html</small>
      </a>
HTML
fi

cat >> "$out" <<HTML
    </div>
  </div>

  <div class="section">
    <h2>All pages</h2>
    <div class="grid">
HTML

if exists "$ALLP_INDEX"; then
  cat >> "$out" <<HTML
      <a class="btn" href="$ALLP_INDEX">All pages (list)
        <small>$ALLP_INDEX</small>
      </a>
HTML
fi

if exists "$ALLP_COMPACT"; then
  cat >> "$out" <<HTML
      <a class="btn" href="$ALLP_COMPACT">All pages (compact)
        <small>$ALLP_COMPACT</small>
      </a>
HTML
fi

cat >> "$out" <<HTML
    </div>
    <div class="footer-note">This page only links — it never injects bash text.</div>
  </div>

  <div class="hr"></div>
  <div class="footer-note">Generated ${ts} in ${DIR}. Backup: ${bak}</div>
</div>
</body>
</html>
HTML

rm -f "$tmp" ".tmp_latest5_${ts}.txt"

echo "✅ Built: $DIR/$out"
[[ -f "$bak" ]] && echo "🧰 Backup: $DIR/$bak"
echo "🌐 Open: http://127.0.0.1:8011/$out"
