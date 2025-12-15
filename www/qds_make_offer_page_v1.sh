#!/data/data/com.termux/files/usr/bin/bash
set -e

# ---------------------------------------------
# 🎩 QDS Offer Page Builder v1
# Creates a single posh Offer page that bundles:
# 1) Demo Suite
# 2) Pilot Ladder
# 3) Pricing bands
# 4) "Not messing about" metrics
#
# Auto-detects latest matching pages in /www.
# Leaves originals untouched.
# ---------------------------------------------

DIR="$HOME/OMEGA_EMPIRE/UV_QDS/www"
cd "$DIR"

STAMP="$(date +"%Y%m%d_%H%M%S")"
OUT="qds_offer_bundle_v1_${STAMP}.html"

pick_latest () {
  # Usage: pick_latest "pattern"
  ls -1t *"$1"* 2>/dev/null | head -n 1 || true
}

# --- Auto-detect your main pillars + business pages
GROWTH_LINKED="$(ls -1t growthhub_linked_*.html 2>/dev/null | head -n 1 || true)"
GROWTH_BASE="$(pick_latest "growthhub")"
GROWTH="${GROWTH_LINKED:-$GROWTH_BASE}"

FORECAST="$(pick_latest "battery_habitat")"
DESIGN="$(pick_latest "battery_design")"
BAT_LAB="$(pick_latest "battery_lab")"
COMPRESS="$(pick_latest "compression")"

PROJECTION="$(pick_latest "business_projection_posh")"
REV_PRED="$(pick_latest "revenue_predictor")"
REV_FLOOR="$(pick_latest "revenue_floor")"
REV_ONEPAGER="$(pick_latest "revenue_onepager")"

SHOWCASE="$(pick_latest "showcase_index")"
PILLARS="$(pick_latest "5_pillars")"
ALLPAGES="$(pick_latest "all_pages_index")"
INDEX="$(pick_latest "index.html")"

# --- Fallbacks if patterns fail
[[ -z "$FORECAST"  && -f "qds_battery_habitat_v1_2_build002.html" ]] && FORECAST="qds_battery_habitat_v1_2_build002.html"
[[ -z "$COMPRESS"  && -f "qds_compression_lab_v1.html" ]] && COMPRESS="qds_compression_lab_v1.html"
[[ -z "$GROWTH"    && -f "growthhub.html" ]] && GROWTH="growthhub.html"

# --- Helper for buttons
btn () {
  local label="$1"
  local file="$2"
  if [[ -n "$file" && -f "$file" ]]; then
    echo "<a class='btn' href='./$file'>$label</a><div class='tiny'>$file</div>"
  else
    echo "<span class='muted'>Missing: $label</span>"
  fi
}

cat > "$OUT" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>QDS Offer Bundle v1 — Demo • Pilot • Pricing • Metrics</title>
<style>
:root{
  --bg:#06080c; --panel:#0d1220; --panel2:#0b0f1a;
  --ink:#eef2ff; --muted:#a7b0c7;
  --accent:#8dd3ff; --accent2:#b9ffdd; --warn:#ffd28d;
  --line:rgba(255,255,255,0.08);
  --glow:0 0 18px rgba(141,211,255,0.15);
  --r:14px;
}
*{box-sizing:border-box}
body{
  margin:0; padding:24px;
  font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
  color:var(--ink);
  background:
    radial-gradient(1200px 500px at 10% -10%, rgba(141,211,255,0.08), transparent),
    radial-gradient(1200px 500px at 90% -10%, rgba(185,255,221,0.06), transparent),
    linear-gradient(180deg, var(--bg), #05060a 60%, #05060a);
}
.wrap{max-width:1050px; margin:0 auto}
.hero{
  background:linear-gradient(135deg, rgba(141,211,255,0.08), rgba(185,255,221,0.06));
  border:1px solid var(--line); border-radius:var(--r);
  padding:22px 22px 18px; box-shadow:var(--glow);
}
.badges{display:flex; gap:8px; flex-wrap:wrap; margin-bottom:10px}
.badge{
  font-size:11px; letter-spacing:.06em; text-transform:uppercase;
  padding:4px 8px; border-radius:999px;
  background:rgba(141,211,255,0.12); border:1px solid var(--line);
}
h1{margin:6px 0 6px; font-size:26px}
.sub{color:var(--muted); font-size:14px}
.grid{
  display:grid; gap:14px; margin-top:14px;
  grid-template-columns: repeat(12, 1fr);
}
.card{
  grid-column: span 12;
  background:linear-gradient(180deg, var(--panel), var(--panel2));
  border:1px solid var(--line); border-radius:var(--r);
  padding:18px;
}
@media(min-width:820px){
  .col6{grid-column: span 6}
  .col4{grid-column: span 4}
  .col8{grid-column: span 8}
}
h2{font-size:18px; margin:0 0 10px}
h3{font-size:15px; margin:14px 0 8px}
hr.sep{border:0; height:1px; background:var(--line); margin:14px 0}
.btnrow{display:grid; gap:8px; grid-template-columns: 1fr 1fr}
@media(min-width:620px){ .btnrow{grid-template-columns: repeat(3, 1fr)} }
.btn{
  display:inline-flex; align-items:center; justify-content:center;
  text-decoration:none; color:var(--ink);
  padding:11px 12px; border-radius:10px;
  border:1px solid var(--line);
  background:rgba(255,255,255,0.04);
  transition: transform .06s ease, border-color .2s ease, background .2s ease;
}
.btn:hover{transform: translateY(-1px); border-color:rgba(141,211,255,0.45); background:rgba(141,211,255,0.08)}
.tiny{font-size:10px; color:var(--muted); margin-top:2px}
.muted{color:var(--muted)}
.pill{
  display:inline-block; padding:4px 8px; border-radius:999px;
  font-size:11px; margin:2px 4px 0 0;
  background:rgba(255,255,255,0.06); border:1px solid var(--line);
}
table{
  width:100%; border-collapse: collapse; font-size:13px;
}
th,td{
  padding:10px 8px; border-bottom:1px solid var(--line);
  vertical-align: top;
}
th{color:var(--muted); font-weight:600; text-align:left}
.note{
  font-size:12px; color:var(--muted);
  background:rgba(255,255,255,0.04);
  border:1px solid var(--line); border-radius:10px; padding:10px 12px;
}
.kicker{
  font-size:11px; letter-spacing:.08em; text-transform:uppercase; color:var(--warn);
}
.metric{
  padding:10px 12px; border-radius:10px; border:1px solid var(--line);
  background:rgba(255,255,255,0.04); margin-bottom:8px;
}
</style>
</head>
<body>
<div class="wrap">

  <section class="hero">
    <div class="badges">
      <span class="badge">QDS • Offer Bundle</span>
      <span class="badge">Battery • Forecast</span>
      <span class="badge">Data • Compression</span>
      <span class="badge">Service-first</span>
      <span class="badge">No hype</span>
    </div>
    <h1>QDS Offer Bundle v1</h1>
    <div class="sub">
      A single boardroom-safe page that unites your demo suite, pilot ladder, pricing bands,
      and measurable metrics into one clean GrowthHub-ready narrative.
    </div>
  </section>

  <section class="grid">
    <!-- 1) DEMO SUITE -->
    <div class="card col8">
      <div class="kicker">1) Demo Suite</div>
      <h2>Three pillars + supporting business proof</h2>
      <div class="btnrow">
        <div>
          ${btn "GrowthHub Dashboard (latest)" "$GROWTH"}
        </div>
        <div>
          ${btn "Battery Forecast (Habitat)" "$FORECAST"}
        </div>
        <div>
          ${btn "Compression Lab" "$COMPRESS"}
        </div>
      </div>

      <hr class="sep" />

      <div class="btnrow">
        <div>${btn "Battery Design" "$DESIGN"}</div>
        <div>${btn "Battery Lab" "$BAT_LAB"}</div>
        <div>${btn "Business Projection (posh)" "$PROJECTION"}</div>
      </div>

      <hr class="sep" />

      <div class="btnrow">
        <div>${btn "Revenue Predictor" "$REV_PRED"}</div>
        <div>${btn "Revenue Floor" "$REV_FLOOR"}</div>
        <div>${btn "Revenue One-Pager" "$REV_ONEPAGER"}</div>
      </div>

      <hr class="sep" />

      <div class="btnrow">
        <div>${btn "Five Pillars Hub" "$PILLARS"}</div>
        <div>${btn "Showcase Index" "$SHOWCASE"}</div>
        <div>${btn "All Pages Index" "$ALLPAGES"}</div>
      </div>

      <div class="note" style="margin-top:12px">
        <b>Positioning line:</b> "We lead with the measurable three:
        batteries, forecasting, compression. Everything else stays in the archive until proven."
      </div>
    </div>

    <!-- 2) PILOT LADDER -->
    <div class="card col4">
      <div class="kicker">2) Pilot Ladder</div>
      <h2>Proof-first, scale second</h2>

      <div class="metric">
        <b>Pilot 0 — Baseline Audit (2–3 weeks)</b><br/>
        <span class="muted">Data-only. Establish truth, map failure modes, define scoring.</span><br/>
        <span class="pill">low risk</span><span class="pill">fast win</span>
      </div>

      <div class="metric">
        <b>Pilot 1 — Forecast + Compression (4–6 weeks)</b><br/>
        <span class="muted">Deploy toolkit on real datasets. Reduce noise, quantify stress events.</span><br/>
        <span class="pill">software first</span><span class="pill">measurable ROI</span>
      </div>

      <div class="metric">
        <b>Pilot 2 — Pack Optimisation Loop (6–12 weeks)</b><br/>
        <span class="muted">Targeted design & thermal strategies informed by Pilot 1 outputs.</span><br/>
        <span class="pill">modular</span><span class="pill">fleet-ready</span>
      </div>

      <div class="note">
        <b>Investor-safe wording:</b><br/>
        "We do not sell headlines. We sell measured deltas and a repeatable method."
      </div>
    </div>

    <!-- 3) PRICING BANDS -->
    <div class="card col6">
      <div class="kicker">3) Pricing Bands</div>
      <h2>Service pricing that matches real delivery</h2>

      <table>
        <thead>
          <tr>
            <th>Tier</th>
            <th>What’s included</th>
            <th>Indicative band (UK)</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><b>Pilot 0</b></td>
            <td>
              Baseline audit, dataset hygiene, stress map, KPI template,
              ROI framing for next stage.
            </td>
            <td><b>£3k–£8k</b></td>
          </tr>
          <tr>
            <td><b>Pilot 1</b></td>
            <td>
              Forecast engine + compression pipeline + report.
              Includes "what improves next" action shortlist.
            </td>
            <td><b>£8k–£20k</b></td>
          </tr>
          <tr>
            <td><b>Pilot 2</b></td>
            <td>
              Design feedback loop, thermal/stress tuning,
              validation against real duty profiles.
            </td>
            <td><b>£20k–£60k</b></td>
          </tr>
          <tr>
            <td><b>Retainer</b></td>
            <td>
              Ongoing model updates, new pack/duty profile onboarding,
              quarterly performance reports.
            </td>
            <td><b>£1.5k–£6k/month</b></td>
          </tr>
        </tbody>
      </table>

      <div class="note" style="margin-top:10px">
        These are conservative service bands designed for credibility and fast adoption.
        You can tighten/raise them later once your first 2–3 external pilots publish results.
      </div>
    </div>

    <!-- 4) NOT MESSING ABOUT METRICS -->
    <div class="card col6">
      <div class="kicker">4) "Not Messing About" Metrics</div>
      <h2>KPIs that make the value undeniable</h2>

      <div class="metric"><b>Battery health & stress</b><br/>
        • Stress events / 100 cycles<br/>
        • Degradation slope vs baseline<br/>
        • Thermal spread reduction (ΔT pack-level)
      </div>

      <div class="metric"><b>Forecast performance</b><br/>
        • MAE / RMSE improvement over AR(1) or current baseline<br/>
        • Early-warning lead time gained<br/>
        • False-positive rate containment
      </div>

      <div class="metric"><b>Compression / telemetry</b><br/>
        • Storage cost per vehicle/month<br/>
        • Retention window gained at same budget<br/>
        • Signal fidelity for ML/diagnostics
      </div>

      <div class="note">
        <b>The line that wins rooms:</b><br/>
        "If the baseline does not move, we do not scale the contract."
      </div>
    </div>

    <!-- STRATEGIC SUMMARY -->
    <div class="card">
      <div class="kicker">Boardroom Summary</div>
      <h2>Why the three-pillar route is the right opening move</h2>
      <div class="sub">
        Batteries, forecasting, and compression form a clean commercial triangle:
        each can be sold as a service today, each feeds the next with measurable data,
        and each keeps risk low while building the evidence base for the wider QDS ecosystem.
      </div>
      <hr class="sep" />
      <div class="note">
        <b>Suggested closing:</b><br/>
        "We’re not asking you to fund science fiction.
        We’re asking you to fund a disciplined measurement path that turns
        small, real improvements into compounding value."
      </div>
    </div>

  </section>

  <div class="note">
    Generated from: <b>$DIR</b><br/>
    This page was auto-linked to your latest detected files where available.
  </div>

</div>
</body>
</html>
HTML

echo "✅ Wrote: $OUT"
echo "Detected:"
echo " - GrowthHub : ${GROWTH:-none}"
echo " - Forecast  : ${FORECAST:-none}"
echo " - Compress  : ${COMPRESS:-none}"
echo " - Projection: ${PROJECTION:-none}"
echo "Open:"
echo " http://127.0.0.1:8011/$OUT"
