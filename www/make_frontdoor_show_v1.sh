#!/data/data/com.termux/files/usr/bin/bash
set -e

ts="$(date +%Y%m%d_%H%M%S)"
out="frontdoor_show.html"
bak="frontdoor_show_backup_${ts}.html"

latest_one() {
  local g="$1"
  local f
  f=$(ls -1t $g 2>/dev/null | head -n 1 || true)
  [[ -f "$f" ]] && echo "$f" || echo ""
}

# --- targets (best-effort auto-detect) ---
REV="$(latest_one "growthhub_multi_area_stack*.html")"
[[ -z "$REV" ]] && REV="$(latest_one "growthhub*.html")"

BAT="$(latest_one "qds_battery_habitat*build*.html")"
[[ -z "$BAT" ]] && BAT="$(latest_one "qds_battery_habitat*.html")"
[[ -z "$BAT" ]] && BAT="$(latest_one "qds_battery*.html")"

COMP="$(latest_one "qds_compression_lab*.html")"
[[ -z "$COMP" ]] && COMP="$(latest_one "qds_compression*.html")"

# backup
[[ -f "$out" ]] && cp -f "$out" "$bak"

# --- HTML ---
cat > "$out" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>GrowthHub — Three Pillars</title>
<style>
:root{
  --bg:#060b1a; --text:#eef2ff; --muted:#aab3c7;
  --stroke:rgba(255,255,255,0.08); --radius:18px;
}
*{box-sizing:border-box}
body{
  margin:0; padding:22px 16px 40px;
  background:
    radial-gradient(1200px 800px at 15% 10%, #0d1b3e 0%, transparent 45%),
    radial-gradient(900px 700px at 85% 20%, #0b2a3b 0%, transparent 50%),
    var(--bg);
  color:var(--text);
  font-family: system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, sans-serif;
}
.wrap{max-width:920px; margin:0 auto;}
.badges{display:flex; gap:8px; flex-wrap:wrap; margin-bottom:14px;}
.badge{
  padding:6px 10px; border:1px solid var(--stroke);
  background: rgba(255,255,255,0.03);
  border-radius:999px; font-size:12px; color:var(--muted);
}
h1{font-size:34px; line-height:1.15; margin:8px 0 6px;}
.subtitle{color:var(--muted); margin:0 0 18px;}
.section{
  background: linear-gradient(180deg, rgba(255,255,255,0.03), rgba(255,255,255,0.01));
  border:1px solid var(--stroke);
  border-radius: var(--radius);
  padding:18px 16px;
  margin:14px 0;
}
.grid{
  display:grid; grid-template-columns:1fr; gap:12px;
}
@media(min-width:720px){ .grid{grid-template-columns:1fr 1fr 1fr;} }
.card{
  border:1px solid var(--stroke);
  border-radius:14px;
  padding:16px 14px 14px;
  background: rgba(255,255,255,0.02);
}
.card h2{margin:0 0 8px; font-size:18px;}
.card p{margin:0 0 12px; color:var(--muted); font-size:13.5px; line-height:1.35;}
.btn{
  display:block; text-decoration:none; color:var(--text);
  padding:12px 12px; border-radius:12px;
  border:1px solid var(--stroke);
  background: rgba(255,255,255,0.03);
  font-weight:600; font-size:14px;
}
.btn small{display:block; font-weight:500; color:var(--muted); margin-top:4px;}
.btn:hover{border-color: rgba(90,167,255,0.35);}
.footer{
  margin-top:14px; color:var(--muted); font-size:12px;
}
.hr{height:1px; background: var(--stroke); margin:18px 0 10px;}
.links-row{display:flex; gap:10px; flex-wrap:wrap;}
.link-btn{
  text-decoration:none; color:var(--text);
  padding:10px 12px; border-radius:10px;
  border:1px solid var(--stroke);
  background: rgba(255,255,255,0.02);
  font-size:12.5px; font-weight:600;
}
</style>
</head>
<body>
<div class="wrap">
  <div class="badges">
    <span class="badge">Show version</span>
    <span class="badge">Three-pillar stack</span>
    <span class="badge">Proof → Pilot → Claim</span>
    <span class="badge">Investor-safe</span>
  </div>

  <h1>GrowthHub — Three Practical Pillars</h1>
  <p class="subtitle">
    Truth-first tools for SMEs and fleets. Built for pilots and measurable outcomes — no fluff.
  </p>

  <div class="section">
    <div class="grid">

      <div class="card">
        <h2>Pillar A — Revenue Truth</h2>
        <p>
          Honest-mode forecasting + capacity reality.
          Prevents over-hiring, under-delivery, and fantasy planning.
        </p>
HTML

if [[ -n "$REV" ]]; then
cat >> "$out" <<HTML
        <a class="btn" href="$REV">Open Revenue Truth
          <small>$REV</small>
        </a>
HTML
else
cat >> "$out" <<HTML
        <span class="btn">Open Revenue Truth
          <small>Not detected yet</small>
        </span>
HTML
fi

cat >> "$out" <<HTML
      </div>

      <div class="card">
        <h2>Pillar B — Battery Habitat</h2>
        <p>
          Life-extension and reliability upgrades with no cell chemistry changes.
          Reduce hotspots, vibration fatigue, and stress events.
        </p>
HTML

if [[ -n "$BAT" ]]; then
cat >> "$out" <<HTML
        <a class="btn" href="$BAT">Open Battery Habitat
          <small>$BAT</small>
        </a>
HTML
else
cat >> "$out" <<HTML
        <span class="btn">Open Battery Habitat
          <small>Not detected yet</small>
        </span>
HTML
fi

cat >> "$out" <<HTML
      </div>

      <div class="card">
        <h2>Pillar C — QDS-SAVE Compression</h2>
        <p>
          Structure-preserving compression for archives and time-series.
          Lower storage/transfer cost while protecting signal meaning.
        </p>
HTML

if [[ -n "$COMP" ]]; then
cat >> "$out" <<HTML
        <a class="btn" href="$COMP">Open Compression
          <small>$COMP</small>
        </a>
HTML
else
cat >> "$out" <<HTML
        <span class="btn">Open Compression
          <small>Not detected yet</small>
        </span>
HTML
fi

cat >> "$out" <<HTML
      </div>

    </div>

    <div class="hr"></div>

    <div class="links-row">
      <a class="link-btn" href="growthhub_official_top5.html">Top 5 (optional)</a>
      <a class="link-btn" href="all_pages_compact.html">All pages (dev)</a>
      <a class="link-btn" href="frontdoor.html">Dev Front Door</a>
    </div>

    <div class="footer">
      Built ${ts}. This page is intentionally minimal for meetings.
    </div>
  </div>
</div>
</body>
</html>
HTML

echo "✅ Built: $out"
[[ -f "$bak" ]] && echo "🧰 Backup: $bak"
echo "🌐 Open: http://127.0.0.1:8011/$out"
