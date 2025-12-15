#!/data/data/com.termux/files/usr/bin/bash
# QDS Tool Atlas v1 — Forge Road Build

set -e

ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
cd "$ROOT"

cat > qds_tool_atlas_v1.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>QDS Tool Atlas v1 — Forge Road Build</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <style>
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: radial-gradient(circle at top, #07101e 0, #020712 55%, #000000 100%);
      color: #f5f9ff;
    }
    a { color: inherit; text-decoration: none; }

    .main {
      max-width: 960px;
      margin: 0 auto;
      padding: 18px 14px 80px;
    }
    .header {
      text-align: center;
      margin-bottom: 18px;
    }
    .badge-row {
      margin-top: 6px;
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 6px;
    }
    .badge {
      font-size: 11px;
      padding: 4px 9px;
      border-radius: 999px;
      background: linear-gradient(135deg, #11cdef, #17e58a);
      color: #02101f;
      font-weight: 600;
      letter-spacing: 0.03em;
    }
    h1 {
      font-size: 22px;
      margin: 4px 0 4px;
    }
    .subtitle {
      font-size: 13px;
      opacity: 0.82;
      line-height: 1.4;
    }
    .hint {
      margin-top: 6px;
      font-size: 11px;
      opacity: 0.7;
    }
    .hint code {
      font-size: 11px;
      background: rgba(10,25,45,0.9);
      padding: 2px 6px;
      border-radius: 5px;
    }

    .card {
      background: radial-gradient(circle at top left, rgba(23, 225, 145, 0.16), rgba(2, 5, 15, 0.95));
      border-radius: 18px;
      padding: 14px 14px 13px;
      margin-bottom: 12px;
      box-shadow: 0 12px 30px rgba(0,0,0,0.65);
      border: 1px solid rgba(255,255,255,0.04);
    }
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      gap: 8px;
      margin-bottom: 6px;
    }
    .card-title {
      font-size: 16px;
      font-weight: 600;
    }
    .card-pill {
      padding: 3px 8px;
      border-radius: 999px;
      font-size: 11px;
      background: rgba(17, 205, 239, 0.16);
      border: 1px solid rgba(17, 205, 239, 0.4);
      white-space: nowrap;
    }
    .card-body {
      font-size: 12px;
      opacity: 0.9;
      line-height: 1.5;
      margin-bottom: 8px;
    }
    .card-body ul {
      margin: 4px 0 4px 18px;
      padding: 0;
    }
    .card-body li {
      margin-bottom: 2px;
    }
    .btn-row {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
    }
    .btn {
      font-size: 12px;
      padding: 6px 12px;
      border-radius: 999px;
      border: 1px solid rgba(23, 229, 138, 0.85);
      background: linear-gradient(135deg, #11cdef, #17e58a);
      color: #041019;
      font-weight: 600;
      box-shadow: 0 4px 14px rgba(0,0,0,0.5);
    }
    .btn.secondary {
      background: rgba(3,13,25,0.9);
      color: #e5f6ff;
      border-color: rgba(255,255,255,0.18);
    }
    .btn.small {
      font-size: 11px;
      padding: 5px 10px;
    }

    .footer-note {
      margin-top: 18px;
      font-size: 11px;
      opacity: 0.7;
      line-height: 1.4;
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="main">
    <header class="header">
      <h1>QDS Tool Atlas v1</h1>
      <div class="subtitle">
        Forge Road build — one front door for your QDS toys:<br />
        battery lab, revenue engines, avian compass, heritage hubs and more.
      </div>
      <div class="badge-row">
        <span class="badge">Built on-phone</span>
        <span class="badge">Termux · HTML · Python</span>
        <span class="badge">QDS Forge 2025</span>
      </div>
      <div class="hint">
        Server hint: <code>cd ~/OMEGA_EMPIRE/UV_QDS/www && python -m http.server 8011 --bind 127.0.0.1</code><br />
        Then open <code>http://127.0.0.1:8011/qds_tool_atlas_v1.html</code> in Chrome.
      </div>
    </header>

    <!-- Battery Habitat / Lab -->
    <section class="card">
      <div class="card-header">
        <div class="card-title">Battery Habitat & Lab</div>
        <div class="card-pill">Pillar I · Batteries</div>
      </div>
      <div class="card-body">
        Phone-first tools for stress-testing cells, thinking about habitats and
        showing nano–to–pack QDS ideas.
        <ul>
          <li>Lab views + stress sliders.</li>
          <li>Good demo for Berkeley Green & local industry.</li>
          <li>Backs up the “Battery Habitat” Growth Hub pillar.</li>
        </ul>
      </div>
      <div class="btn-row">
        <a class="btn" href="QDS_Battery_Lab/">Open Battery Lab (folder)</a>
        <a class="btn secondary small" href="battery_skin_v2_max.html">Battery Skin v2 MAX</a>
      </div>
    </section>

    <!-- Revenue / Growth Hub -->
    <section class="card">
      <div class="card-header">
        <div class="card-title">Revenue / Growth Hub Engines</div>
        <div class="card-pill">Pillar II · Revenue Truth</div>
      </div>
      <div class="card-body">
        Honest-mode revenue models, MRR calculators and meeting scripts for Hub
        conversations.
        <ul>
          <li>Shows you can do business tooling, not just physics toys.</li>
          <li>Useful live in meetings: capacity truth + revenue floors.</li>
        </ul>
      </div>
      <div class="btn-row">
        <a class="btn" href="QDSX_MARKET_EDITION/">Open Market Edition (folder)</a>
        <a class="btn secondary small" href="growthhub_meeting_script_v1.html">Meeting Script v1</a>
      </div>
    </section>

    <!-- Avian Magnetoreception Lab -->
    <section class="card">
      <div class="card-header">
        <div class="card-title">Avian Magnetoreception Lab v4 PRO+</div>
        <div class="card-pill">Kernel · τ<sub>c</sub>, λ<sub>c</sub>, σ²</div>
      </div>
      <div class="card-body">
        Toy model of a bird’s cryptochrome compass under the QDS kernel, with
        species modes, EM noise and paper-trail snapshots.
        <ul>
          <li>Great for “QDS meets biophysics” conversations.</li>
          <li>Shows live kernel sliders → behaviour change.</li>
        </ul>
      </div>
      <div class="btn-row">
        <!-- If your file name differs, just edit this href -->
        <a class="btn" href="qds_avian_lab_v4_pro.html">Open Avian Lab v4 PRO+</a>
      </div>
    </section>

    <!-- Heritage / Mapping -->
    <section class="card">
      <div class="card-header">
        <div class="card-title">Heritage & Mapping Hubs</div>
        <div class="card-pill">Local · Stroud / Stinchcombe</div>
      </div>
      <div class="card-body">
        Local-heritage and mapping microsites tying QDS thinking to real places
        (HER, barrows, quarries, Stroud District context).
      </div>
      <div class="btn-row">
        <a class="btn" href="ddmelts_microsite_v1.html">Open Stroud Demo Microsite</a>
        <a class="btn secondary small" href="Stinchcombe_HER_Hub_MelBarge.zip">HER Hub (zip)</a>
      </div>
    </section>

    <!-- Universe / Orbit toys -->
    <section class="card">
      <div class="card-header">
        <div class="card-title">Universe & Orbit Toys</div>
        <div class="card-pill">Play · Gravity & Motion</div>
      </div>
      <div class="card-body">
        Visual toys for orbits, cannons and marble-run physics. Good for
        workshops with schools or informal demos.
      </div>
      <div class="btn-row">
        <a class="btn" href="QDS-5-WEDGE-PORTFOLIO/">Open Universe / Portfolio (folder)</a>
        <a class="btn secondary small" href="cannon_wall_breaker_v1_1.html">Cannon Wall Breaker</a>
      </div>
    </section>

    <!-- Everything index -->
    <section class="card">
      <div class="card-header">
        <div class="card-title">Everything Index</div>
        <div class="card-pill">Meta · All Pages</div>
      </div>
      <div class="card-body">
        Raw index of all HTML pages detected on the phone. Use this if you want
        to deep-dive or find something that isn’t yet on the Atlas cards.
      </div>
      <div class="btn-row">
        <a class="btn secondary" href="all_pages_index.html">Open all_pages_index.html</a>
        <a class="btn secondary small" href="all_pages_min.html">Open all_pages_min.html</a>
      </div>
    </section>

    <div class="footer-note">
      This Atlas is just a launcher — edit the links, add new cards, or fork it
      into a “QDS Portfolio” for funders and partners.<br />
      Forge Road build · 11 Dec 2025
    </div>
  </div>
</body>
</html>
EOF

echo "Created: $ROOT/qds_tool_atlas_v1.html"

