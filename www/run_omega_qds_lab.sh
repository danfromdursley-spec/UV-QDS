#!/data/data/com.termux/files/usr/bin/bash
# Ω-QDS Lab Suite — Shed Edition
# One script: build lab site, sync HTML toys, run local server.

set -e

SRC_DIR="/sdcard/Download"
LAB_DIR="$HOME/OMEGA_EMPIRE/UV_QDS/www"
PORT=8000

mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

echo "[Ω] Syncing packs from $SRC_DIR → $LAB_DIR …"

# List of ZIP bundles we know about (adjust names if your files differ)
ZIP_LIST=(
  "qds_universe_v9_10_neon_planet_colours.zip"
  "solar_system_v8_full.zip"
  "indus_atlas_v1_qds_language_lab.zip"
  "Stinchcombe_HER_Hub_MelBarge.zip"
  "QDSX_MARKET_EDITION_v1.zip"
)

for z in "${ZIP_LIST[@]}"; do
  if [ -f "$SRC_DIR/$z" ]; then
    echo "  - Found $z"
    cp "$SRC_DIR/$z" . 2>/dev/null || true
    unzip -o "$z" >/dev/null 2>&1 || true
  else
    echo "  - (missing) $z"
  fi
done

echo "[Ω] Writing omega_qds_lab.html …"

cat > "$LAB_DIR/omega_qds_lab.html" << 'EOF_HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Ω-QDS Lab Suite · Shed Edition</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root {
      --bg: #050712;
      --bg-card: #0e1324;
      --bg-pill: #182034;
      --accent: #22c4ff;
      --accent-soft: rgba(34,196,255,0.14);
      --accent-warm: #ffb347;
      --text: #f5f7ff;
      --text-soft: #c2c7de;
      --border-soft: rgba(255,255,255,0.06);
      --radius-pill: 999px;
      --radius-card: 24px;
      --shadow-soft: 0 18px 35px rgba(0,0,0,0.55);
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "SF Pro Text",
                   "Roboto", "Segoe UI", sans-serif;
      background: radial-gradient(circle at top left,#16203c 0,#050712 55%,#03040a 100%);
      color: var(--text);
      line-height: 1.6;
      padding: 16px;
    }
    .shell {
      max-width: 980px;
      margin: 0 auto 80px;
    }
    header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      margin-bottom: 18px;
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .brand-icon {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: conic-gradient(from 210deg, #ff4b9a, #ffb347, #22c4ff, #ff4b9a);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 0 0 2px rgba(255,255,255,0.15);
    }
    .brand-icon span { font-size: 22px; }
    .brand-text {
      display: flex;
      flex-direction: column;
      gap: 1px;
    }
    .brand-text small { font-size: 12px; color: var(--text-soft); }
    .brand-text strong { font-size: 16px; letter-spacing: 0.02em; }

    nav {
      display: flex;
      flex-wrap: wrap;
      justify-content: flex-end;
      gap: 6px;
    }
    .nav-pill {
      padding: 6px 14px;
      border-radius: var(--radius-pill);
      background: rgba(12,17,32,0.8);
      border: 1px solid rgba(255,255,255,0.06);
      font-size: 12px;
      color: var(--text-soft);
      text-decoration: none;
      backdrop-filter: blur(16px);
    }
    .nav-pill:hover { border-color: var(--accent); color: var(--accent); }

    .hero {
      background: linear-gradient(135deg, rgba(34,196,255,0.12), rgba(255,108,188,0.03));
      border-radius: 32px;
      padding: 20px 18px 18px;
      border: 1px solid rgba(255,255,255,0.08);
      box-shadow: var(--shadow-soft);
      margin-bottom: 22px;
    }
    .hero-title {
      font-size: 22px;
      font-weight: 650;
      margin-bottom: 4px;
    }
    .hero-sub {
      font-size: 13px;
      color: var(--text-soft);
      margin-bottom: 14px;
    }
    .hero-stats {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      font-size: 11px;
    }
    .hero-stat {
      padding: 6px 10px;
      border-radius: 14px;
      background: rgba(5,7,18,0.8);
      border: 1px solid rgba(255,255,255,0.06);
      display: flex;
      flex-direction: column;
      min-width: 120px;
    }
    .hero-stat span { color: var(--text-soft); }
    .hero-stat strong { font-size: 13px; }

    section {
      margin-top: 26px;
    }
    section h2 {
      font-size: 16px;
      margin-bottom: 4px;
    }
    section .tagline {
      font-size: 12px;
      color: var(--text-soft);
      margin-bottom: 12px;
    }

    .grid {
      display: grid;
      grid-template-columns: minmax(0,1fr);
      gap: 12px;
    }
    @media (min-width: 720px) {
      .grid {
        grid-template-columns: minmax(0,1fr);
      }
    }

    .card {
      background: linear-gradient(145deg, rgba(10,14,30,0.96), rgba(8,10,22,0.98));
      border-radius: var(--radius-card);
      padding: 14px 14px 12px;
      border: 1px solid var(--border-soft);
      box-shadow: var(--shadow-soft);
      position: relative;
      overflow: hidden;
    }
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      gap: 8px;
      margin-bottom: 6px;
    }
    .card-title {
      font-size: 14px;
      font-weight: 600;
    }
    .card-badge {
      font-size: 11px;
      padding: 3px 10px;
      border-radius: var(--radius-pill);
      background: rgba(111,255,188,0.12);
      border: 1px solid rgba(111,255,188,0.45);
      color: #a2ffd5;
      white-space: nowrap;
    }
    .card-badge.experimental {
      background: rgba(255,136,255,0.06);
      border-color: rgba(255,136,255,0.6);
      color: #ffcfff;
    }
    .card-badge.toy {
      background: rgba(255,179,71,0.06);
      border-color: rgba(255,179,71,0.6);
      color: #ffd79a;
    }
    .card-body {
      font-size: 12px;
      color: var(--text-soft);
      margin-bottom: 10px;
    }
    .chip-row {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-bottom: 10px;
    }
    .chip {
      font-size: 11px;
      padding: 4px 10px;
      border-radius: var(--radius-pill);
      background: rgba(13,20,41,0.9);
      border: 1px solid rgba(255,255,255,0.06);
    }
    .chip.soft { background: rgba(6,10,24,0.9); }

    .actions {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      font-size: 11px;
      padding: 6px 12px;
      border-radius: var(--radius-pill);
      border: 1px solid transparent;
      background: var(--accent-soft);
      color: var(--accent);
      text-decoration: none;
    }
    .btn.outline {
      background: transparent;
      border-color: rgba(255,255,255,0.18);
      color: var(--text-soft);
    }
    .btn span {
      font-size: 13px;
    }
    code {
      font-family: "JetBrains Mono","SF Mono","Menlo",monospace;
      font-size: 11px;
      background: rgba(8,10,22,0.9);
      padding: 2px 6px;
      border-radius: 6px;
      border: 1px solid rgba(255,255,255,0.06);
    }
    footer {
      margin-top: 28px;
      font-size: 11px;
      color: var(--text-soft);
      text-align: center;
      opacity: 0.78;
    }
  </style>
</head>
<body>
  <div class="shell">
    <header>
      <div class="brand">
        <div class="brand-icon"><span>🎩</span></div>
        <div class="brand-text">
          <small>Ω-QDS Lab Suite</small>
          <strong>Shed Edition · Local Lab</strong>
        </div>
      </div>
      <nav>
        <a class="nav-pill" href="#core-os">Core OS</a>
        <a class="nav-pill" href="#physics">Physics labs</a>
        <a class="nav-pill" href="#compression">Compression</a>
        <a class="nav-pill" href="#language">Language</a>
        <a class="nav-pill" href="#field">Field &amp; maps</a>
        <a class="nav-pill" href="#shed">Shed / Experimental</a>
      </nav>
    </header>

    <main>
      <section class="hero">
        <div class="hero-title">One phone. One shed. 1,700+ engines.</div>
        <div class="hero-sub">
          This page is your local map over the Ω-Empire: physics toys, compression
          engines, language labs and field dashboards, all running offline on
          Termux + Python.
        </div>
        <div class="hero-stats">
          <div class="hero-stat">
            <span>ENGINES</span>
            <strong>≈ 1,750</strong>
          </div>
          <div class="hero-stat">
            <span>CORE DOMAINS</span>
            <strong>Physics · Compression · Language · Field · OS</strong>
          </div>
          <div class="hero-stat">
            <span>MODE</span>
            <strong>Shed Edition · Playable now</strong>
          </div>
        </div>
      </section>

      <!-- Core OS -->
      <section id="core-os">
        <h2>Core OS &amp; launchers</h2>
        <p class="tagline">Boot into Ω-OS, route into APEX / REALM, and keep the Shed tidy.</p>
        <div class="grid">
          <article class="card">
            <div class="card-header">
              <div class="card-title">OMEGA_OS_V5 · Bootloader</div>
              <div class="card-badge">stable · daily driver</div>
            </div>
            <p class="card-body">
              Text-mode launcher that scans all engines, groups them, and presents
              favourites (Apex, Realm, Indus, Doctor, Lazy Hub). Your main entry-point.
            </p>
            <div class="chip-row">
              <div class="chip">Python CLI</div>
              <div class="chip soft">Engine grouping</div>
              <div class="chip soft">Favourites hot-keys</div>
            </div>
            <div class="actions">
              <span><code>python OMEGA_OS_V5.py</code></span>
            </div>
          </article>

          <article class="card">
            <div class="card-header">
              <div class="card-title">OMEGA_APEX_ALL_IN_ONE_v3</div>
              <div class="card-badge">stable · work hub</div>
            </div>
            <p class="card-body">
              High-level control engine: pulls in the big families (V60 / V120 /
              V5000 / V50000 / V100000) so you can run complex chains and automation
              from one console.
            </p>
            <div class="chip-row">
              <div class="chip">Chained workflows</div>
              <div class="chip soft">QDS / Indus / Field</div>
            </div>
            <div class="actions">
              <span><code>python OMEGA_APEX_ALL_IN_ONE_v3.py</code></span>
            </div>
          </article>

          <article class="card">
            <div class="card-header">
              <div class="card-title">OMEGA_REALM_V3 · Reality analytics hub</div>
              <div class="card-badge">stable · analysis</div>
            </div>
            <p class="card-body">
              Reads the shared inbox/logs, scores engines, and helps you see which
              tools are actually pulling their weight.
            </p>
            <div class="chip-row">
              <div class="chip">Scoring &amp; metrics</div>
              <div class="chip soft">QDS-aware</div>
            </div>
            <div class="actions">
              <span><code>python OMEGA_REALM_V3.py</code></span>
            </div>
          </article>

          <article class="card">
            <div class="card-header">
              <div class="card-title">OMEGA_DOCTOR_V1 · Housekeeping</div>
              <div class="card-badge">stable · support</div>
            </div>
            <p class="card-body">
              Health-check &amp; cleanup helper. Scans for junk, duplicates,
              odd filenames and keeps the Shed from turning into a black hole.
            </p>
            <div class="chip-row">
              <div class="chip">Maintenance</div>
              <div class="chip soft">Safe to run</div>
            </div>
            <div class="actions">
              <span><code>python OMEGA_DOCTOR_V1.py</code></span>
            </div>
          </article>
        </div>
      </section>

      <!-- Physics labs -->
      <section id="physics">
        <h2>Physics &amp; universe labs</h2>
        <p class="tagline">Neon warp-grids, planet toys, and kernel-intuition playgrounds.</p>
        <div class="grid">
          <article class="card">
            <div class="card-header">
              <div class="card-title">QDS Universe V9.10 · Neon planet colours</div>
              <div class="card-badge toy">toy · ride-along</div>
            </div>
            <p class="card-body">
              Warp-grid with bright planets, smooth ride-along camera and tuned
              colours for “feel” demos of the kernel.
            </p>
            <div class="chip-row">
              <div class="chip">HTML</div>
              <div class="chip soft">Neon grid</div>
              <div class="chip soft">HUD controls</div>
            </div>
            <div class="actions">
              <a class="btn" href="qds_universe_v9_10_neon_planet_colours.html" target="_blank">
                <span>▶</span> Launch V9.10
              </a>
            </div>
          </article>

          <article class="card">
            <div class="card-header">
              <div class="card-title">Solar System V8 · Offline</div>
              <div class="card-badge toy">toy · visual</div>
            </div>
            <p class="card-body">
              Lightweight solar system demo: planets, orbits and camera controls,
              running entirely offline in your browser.
            </p>
            <div class="chip-row">
              <div class="chip">HTML</div>
              <div class="chip soft">Orbit toy</div>
            </div>
            <div class="actions">
              <a class="btn" href="solar_system_v8_offline.html" target="_blank">
                <span>🪐</span> Open Solar toy
              </a>
            </div>
          </article>
        </div>
      </section>

      <!-- Compression -->
      <section id="compression">
        <h2>Compression &amp; noise tools</h2>
        <p class="tagline">Turn messy logs into compact bundles and check how random they really are.</p>
        <div class="grid">
          <article class="card">
            <div class="card-header">
              <div class="card-title">QDSX Market Edition · CLI</div>
              <div class="card-badge">stable · published</div>
            </div>
            <p class="card-body">
              Single-file, Android-safe compression engine. Tries multiple codecs
              (zlib / bz2 / lzma etc.), logs ratios, and writes <code>.qdsx</code>
              bundles with hashes.
            </p>
            <div class="chip-row">
              <div class="chip">Python</div>
              <div class="chip soft">Multi-codec</div>
              <div class="chip soft">Market release</div>
            </div>
            <div class="actions">
              <span><code>cd QDSX_MARKET_EDITION_v1 &amp;&amp; python qdsx_engine.py</code></span>
            </div>
          </article>

          <article class="card">
            <div class="card-header">
              <div class="card-title">QDSZ HTML compressor</div>
              <div class="card-badge experimental">experimental · fun</div>
            </div>
            <p class="card-body">
              “Script inside the script” demo: LZW-style dictionary compressor
              embedded in a smart HTML interface. Paste code, compress, export
              Base64 bundles, decompress on demand.
            </p>
            <div class="chip-row">
              <div class="chip">HTML / JS</div>
              <div class="chip soft">Base64 output</div>
              <div class="chip soft">Browser-only</div>
            </div>
            <div class="actions">
              <a class="btn" href="qdsz_html_lab.html" target="_blank">
                <span>🧪</span> Open QDSZ lab
              </a>
            </div>
          </article>
        </div>
      </section>

      <!-- Language -->
      <section id="language">
        <h2>Language &amp; Indus lab</h2>
        <p class="tagline">Glyph tiles, roles, frequencies and kernel status for the Indus script.</p>
        <div class="grid">
          <article class="card">
            <div class="card-header">
              <div class="card-title">INDUS ATLAS · QDS Language Lab V1.0</div>
              <div class="card-badge">stable · offline</div>
            </div>
            <p class="card-body">
              Browser-safe Indus HUD: glyph tiles, roles (marker / number / vessel /
              route / deity), frequency maps, and kernel status bar for the language
              phase.
            </p>
            <div class="chip-row">
              <div class="chip">HTML / JS</div>
              <div class="chip soft">Glyph explorer</div>
              <div class="chip soft">Filters &amp; search</div>
            </div>
            <div class="actions">
              <a class="btn" href="indus_atlas_v1_qds_language_lab.html" target="_blank">
                <span>📜</span> Open Indus Atlas
              </a>
            </div>
          </article>
        </div>
      </section>

      <!-- Field & maps -->
      <section id="field">
        <h2>Field &amp; map dashboards</h2>
        <p class="tagline">Local dashboards for Stinchcombe, Taits Hill and friends.</p>
        <div class="grid">
          <article class="card">
            <div class="card-header">
              <div class="card-title">Ω-DASHBOARD · Stinchcombe field hub</div>
              <div class="card-badge">stable · local</div>
            </div>
            <p class="card-body">
              Flask / HTML dashboard for hillfort bubbles, layers by period and
              quick links out to the interactive OSM / Leaflet map and compression lab.
            </p>
            <div class="chip-row">
              <div class="chip">Flask</div>
              <div class="chip soft">HER summary</div>
              <div class="chip soft">Map overlays</div>
            </div>
            <div class="actions">
              <span><code>python field_hub.py</code></span>
            </div>
          </article>

          <article class="card">
            <div class="card-header">
              <div class="card-title">HER map · Stinchcombe &amp; Taits Hill</div>
              <div class="card-badge">stable</div>
            </div>
            <p class="card-body">
              Leaflet map overlay with hillfort bubble centres, radius rings, HER
              record counts by period, and quick links to TAG inspector.
            </p>
            <div class="chip-row">
              <div class="chip">Leaflet / OSM</div>
              <div class="chip soft">Radius bubbles</div>
            </div>
            <div class="actions">
              <a class="btn" href="stinchcombe_her_map.html" target="_blank">
                <span>🗺️</span> Open map view
              </a>
            </div>
          </article>
        </div>
      </section>

      <!-- Shed / Experimental -->
      <section id="shed">
        <h2>Shed engines &amp; experimental toys</h2>
        <p class="tagline">High-number OMEGA engines, singularity toys, and other questionable experiments.</p>
        <div class="grid">
          <article class="card">
            <div class="card-header">
              <div class="card-title">V30000 / V50000 / V100000 engines</div>
              <div class="card-badge experimental">experimental stack</div>
            </div>
            <p class="card-body">
              Heavyweight experiment families:
              <code>V30000_OMEGA_SINGULARITY</code>,
              <code>V50000_OMEGA_PRIME</code>,
              <code>V100000_OMEGA_APEX_CORE</code> and friends. Used for
              stress-tests, automation chains and “what if?” nights.
            </p>
            <div class="chip-row">
              <div class="chip">Do not ship to normals</div>
              <div class="chip soft">Launched via Ω-OS</div>
            </div>
            <div class="actions">
              <span><code>Launch from OMEGA_OS_V5 favourites</code></span>
            </div>
          </article>

          <article class="card">
            <div class="card-header">
              <div class="card-title">OMEGA_SHEDBOT &amp; CLEANER</div>
              <div class="card-badge">support</div>
            </div>
            <p class="card-body">
              Helper engines for the Shed: scan, rename, archive and clean out
              tangled branches so the core lab stays fast.
            </p>
            <div class="chip-row">
              <div class="chip">Maintenance</div>
              <div class="chip soft">Use with backups</div>
            </div>
            <div class="actions">
              <span><code>Launch via Ω-OS when needed</code></span>
            </div>
          </article>
        </div>
      </section>

      <footer>
        Built in the Shed · QDS kernel under the hood · LifeFirst on top.
        Tweak, fork and scribble over this page as your lab grows. 🎩
      </footer>
    </main>
  </div>
</body>
</html>
EOF_HTML

echo "[Ω] Starting local web server on http://127.0.0.1:$PORT …"
echo "[Ω] (Ctrl+C in Termux to stop it.)"

# Start simple HTTP server
python -m http.server "$PORT" >/dev/null 2>&1 &
SERVER_PID=$!

# Give it a moment, then open in browser
sleep 1
termux-open-url "http://127.0.0.1:${PORT}/omega_qds_lab.html" 2>/dev/null || true

wait "$SERVER_PID"
