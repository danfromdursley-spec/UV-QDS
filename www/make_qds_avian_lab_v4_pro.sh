#!/data/data/com.termux/files/usr/bin/bash
# QDS Avian Magnetoreception Lab v4 PRO+ builder

set -e

cd "$(dirname "$0")"

cat > qds_avian_lab_v4_pro.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>QDS Avian Magnetoreception Lab v4 PRO+</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<style>
  :root {
    --bg: #020712;
    --card: #060d1c;
    --accent: #00f5ff;
    --accent-soft: #00d4ff;
    --accent-alt: #28f28e;
    --danger: #ff4b6a;
    --warn: #f0b332;
    --text-main: #e4f9ff;
    --text-soft: #9ac7d9;
    --border-soft: #12324d;
  }

  * {
    box-sizing: border-box;
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "SF Pro Text",
      "Roboto", "Segoe UI", sans-serif;
  }

  body {
    margin: 0;
    padding: 0;
    background: radial-gradient(circle at top, #04152c, #020712 55%, #000 100%);
    color: var(--text-main);
  }

  .shell {
    max-width: 520px;
    margin: 0 auto;
    padding: 16px 12px 40px;
  }

  header {
    text-align: center;
    margin-bottom: 18px;
  }

  header h1 {
    font-size: 1.45rem;
    margin: 4px 0 6px;
    color: var(--accent);
    text-shadow: 0 0 18px rgba(0, 255, 255, 0.35);
  }

  header .sub {
    font-size: 0.8rem;
    color: var(--text-soft);
  }

  header .badge-row {
    margin-top: 6px;
    display: flex;
    justify-content: center;
    gap: 6px;
    flex-wrap: wrap;
    font-size: 0.7rem;
  }

  .pill {
    padding: 4px 9px;
    border-radius: 999px;
    border: 1px solid rgba(0, 245, 255, 0.4);
    background: linear-gradient(135deg, #041423, #040b15);
    color: var(--text-soft);
  }

  .card {
    background: radial-gradient(circle at top left, #071834, #050c19 52%, #02050b);
    border-radius: 22px;
    padding: 14px 14px 16px;
    margin-bottom: 14px;
    box-shadow:
      0 0 25px rgba(0, 255, 255, 0.06),
      0 16px 45px rgba(0, 0, 0, 0.9);
    border: 1px solid var(--border-soft);
  }

  .card-title {
    font-size: 0.92rem;
    margin-bottom: 8px;
    display: flex;
    align-items: center;
    gap: 6px;
    letter-spacing: 0.02em;
  }

  .card-title span.bar {
    display: inline-block;
    width: 3px;
    height: 16px;
    border-radius: 8px;
    background: linear-gradient(180deg, var(--accent), #22ff9c);
  }

  .card-title span.label {
    text-transform: none;
  }

  label {
    display: block;
    font-size: 0.78rem;
    color: var(--text-soft);
    margin-bottom: 2px;
  }

  select,
  button {
    font-size: 0.86rem;
  }

  .select-wrap {
    border-radius: 999px;
    border: 1px solid rgba(0, 245, 255, 0.55);
    background: linear-gradient(135deg, #061226, #020815);
    padding: 6px 10px;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .select-wrap select {
    flex: 1;
    border: none;
    outline: none;
    background: transparent;
    color: var(--text-main);
    appearance: none;
  }

  .select-wrap span.icon {
    margin-left: 8px;
    font-size: 1rem;
  }

  .quad-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 12px;
  }

  @media (min-width: 460px) {
    .quad-grid {
      grid-template-columns: 1.1fr 1.2fr;
      align-items: center;
    }
  }

  .slider-group {
    margin-bottom: 12px;
  }

  .slider-head {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    font-size: 0.78rem;
  }

  .slider-head span.value {
    color: var(--accent-alt);
    font-weight: 600;
  }

  input[type="range"] {
    width: 100%;
    margin-top: 2px;
    -webkit-appearance: none;
    background: linear-gradient(90deg, #0094ff, #00ffc8);
    height: 4px;
    border-radius: 999px;
  }

  input[type="range"]::-webkit-slider-thumb {
    -webkit-appearance: none;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: #ff8a3c;
    border: 2px solid #ffe6c5;
    box-shadow: 0 0 10px rgba(255, 168, 76, 0.65);
    margin-top: -7px;
  }

  input[type="range"]::-moz-range-thumb {
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: #ff8a3c;
    border: 2px solid #ffe6c5;
    box-shadow: 0 0 10px rgba(255, 168, 76, 0.65);
  }

  .compass-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
  }

  .compass {
    position: relative;
    width: 230px;
    height: 230px;
    border-radius: 50%;
    background: radial-gradient(circle at 30% 30%, #111827, #050815 60%, #010307);
    border: 3px solid rgba(0, 255, 255, 0.45);
    box-shadow:
      0 0 32px rgba(0, 255, 255, 0.4),
      inset 0 0 26px rgba(0, 0, 0, 0.9);
    overflow: hidden;
  }

  .compass::before {
    content: "N";
    position: absolute;
    top: 16px;
    left: 50%;
    transform: translateX(-50%);
    color: var(--text-main);
    font-size: 0.9rem;
    letter-spacing: 0.12em;
  }

  .compass-cross {
    position: absolute;
    top: 9px;
    left: 50%;
    transform: translateX(-50%);
    width: 18px;
    height: 18px;
    border-radius: 50%;
    border: 2px solid rgba(0, 255, 255, 0.75);
  }

  .compass-cross::before,
  .compass-cross::after {
    content: "";
    position: absolute;
    background: rgba(0, 255, 255, 0.75);
  }

  .compass-cross::before {
    width: 2px;
    height: 16px;
    left: 50%;
    top: -3px;
    transform: translateX(-50%);
  }

  .compass-cross::after {
    width: 16px;
    height: 2px;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
  }

  .needle {
    position: absolute;
    width: 6px;
    height: 90px;
    border-radius: 999px;
    background: linear-gradient(180deg, #ff7f7f, #ff2f4c);
    top: 50%;
    left: 50%;
    transform-origin: 50% 80%;
    transform: translate(-50%, -10%) rotate(-90deg);
    box-shadow:
      0 0 18px rgba(255, 72, 100, 0.9),
      0 0 10px rgba(255, 255, 255, 0.4);
  }

  .needle.tail {
    height: 65px;
    top: 50%;
    background: linear-gradient(180deg, #293bff, #18236a);
    opacity: 0.7;
    box-shadow: 0 0 10px rgba(66, 144, 255, 0.8);
  }

  .status-banner {
    margin-top: 6px;
    width: 100%;
    text-align: center;
    padding: 7px 10px;
    border-radius: 999px;
    font-size: 0.8rem;
    font-weight: 500;
    background: linear-gradient(135deg, #08301a, #02120a);
    border: 1px solid rgba(40, 242, 142, 0.7);
    color: #c6ffdf;
  }

  .status-banner.warn {
    background: linear-gradient(135deg, #3a2a02, #140b02);
    border-color: rgba(240, 179, 50, 0.9);
    color: #ffe5b0;
  }

  .status-banner.danger {
    background: linear-gradient(135deg, #3a040f, #140109);
    border-color: rgba(255, 75, 106, 0.95);
    color: #ffd3df;
  }

  .k-indicator {
    margin-top: 4px;
    font-size: 0.72rem;
    color: var(--text-soft);
    text-align: center;
  }

  .crypto-wrap {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    margin-top: 6px;
  }

  .crypto-dot {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: radial-gradient(circle at 30% 20%, #5845ff, #251272 60%, #140628);
    box-shadow:
      0 0 25px rgba(103, 80, 255, 0.8),
      0 0 50px rgba(0, 255, 209, 0.2);
    transition:
      transform 0.22s ease-out,
      box-shadow 0.22s ease-out,
      background 0.22s ease-out;
  }

  .crypto-caption {
    font-size: 0.78rem;
    text-align: center;
    color: var(--text-soft);
  }

  .env-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 9px;
  }

  .env-btn,
  .tool-btn,
  .toggle-btn {
    border-radius: 999px;
    border: 1px solid rgba(0, 245, 255, 0.65);
    background: linear-gradient(135deg, #042136, #03101f);
    padding: 8px 11px;
    color: var(--text-main);
    display: flex;
    align-items: center;
    justify-content: space-between;
    cursor: pointer;
    gap: 4px;
  }

  .env-btn span.label {
    font-size: 0.84rem;
  }

  .env-btn span.icon {
    font-size: 1rem;
  }

  .env-btn.active {
    border-color: #28f28e;
    box-shadow: 0 0 15px rgba(40, 242, 142, 0.5);
    background: linear-gradient(135deg, #073424, #051116);
  }

  .tool-row {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 6px;
  }

  .toggle-btn {
    flex: 1;
    font-size: 0.8rem;
    border-color: rgba(0, 245, 255, 0.85);
  }

  .toggle-btn.active {
    border-color: #ffdd55;
    box-shadow: 0 0 18px rgba(255, 221, 85, 0.6);
  }

  .tool-btn {
    width: 100%;
    justify-content: center;
    font-size: 0.86rem;
    margin-top: 4px;
  }

  .tool-btn span.icon {
    margin-right: 6px;
  }

  .footnote {
    font-size: 0.7rem;
    color: var(--text-soft);
    margin-top: 6px;
    line-height: 1.35;
  }

  .footnote strong {
    color: var(--accent-soft);
  }

  /* Export overlay */
  .overlay {
    position: fixed;
    inset: 0;
    background: rgba(1, 4, 10, 0.87);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 40;
  }

  .overlay-inner {
    width: 90%;
    max-width: 480px;
    background: #020611;
    border-radius: 18px;
    padding: 12px 12px 14px;
    border: 1px solid rgba(0, 245, 255, 0.7);
    box-shadow:
      0 0 25px rgba(0, 245, 255, 0.6),
      0 18px 40px rgba(0, 0, 0, 0.95);
  }

  .overlay-inner h2 {
    font-size: 0.95rem;
    margin: 2px 0 6px;
    color: var(--accent-soft);
  }

  .overlay-inner textarea {
    width: 100%;
    height: 160px;
    border-radius: 12px;
    border: 1px solid var(--border-soft);
    background: #01020b;
    color: var(--text-main);
    font-size: 0.78rem;
    padding: 8px;
    resize: none;
  }

  .overlay-actions {
    display: flex;
    justify-content: space-between;
    margin-top: 8px;
    gap: 8px;
  }

  .overlay-actions button {
    flex: 1;
    border-radius: 999px;
    padding: 7px 10px;
    border: 1px solid rgba(0, 245, 255, 0.85);
    background: linear-gradient(135deg, #03101f, #041f32);
    color: var(--text-main);
    font-size: 0.8rem;
    cursor: pointer;
  }

  .overlay-actions button.secondary {
    border-color: rgba(255, 255, 255, 0.3);
    background: #050815;
  }
</style>
</head>
<body>
<div class="shell">
  <header>
    <div style="font-size:1.6rem;">🦅</div>
    <h1>QDS Avian Magnetoreception Lab v4 PRO+</h1>
    <div class="sub">
      Toy model of a bird’s cryptochrome compass under the QDS kernel.<br />
      Now with species modes, drift physics, and paper-trail export.
    </div>
    <div class="badge-row">
      <div class="pill">Forge Road Build · v4</div>
      <div class="pill">QDS Kernel: τ<sub>c</sub>, λ<sub>c</sub>, σ²</div>
    </div>
  </header>

  <!-- Species selector -->
  <section class="card">
    <div class="card-title">
      <span class="bar"></span>
      <span class="label">Species Mode</span>
    </div>
    <label for="speciesSelect">Choose an avian model:</label>
    <div class="select-wrap">
      <select id="speciesSelect">
        <option>European Robin</option>
        <option>Racing Pigeon</option>
        <option>Wandering Albatross</option>
        <option>Blackcap Warbler</option>
        <option>Arctic Tern</option>
      </select>
      <span class="icon">▼</span>
    </div>
  </section>

  <!-- Quantum + Compass -->
  <section class="card">
    <div class="quad-grid">
      <div>
        <div class="card-title">
          <span class="bar"></span>
          <span class="label">Quantum Parameters</span>
        </div>

        <div class="slider-group">
          <div class="slider-head">
            <span>τ<sub>c</sub> — Coherence Time</span>
            <span class="value" id="tauValue">–</span>
          </div>
          <input id="tauSlider" type="range" min="0.2" max="6" step="0.1" />
          <div style="display:flex;justify-content:space-between;font-size:0.7rem;color:var(--text-soft);margin-top:2px;">
            <span>0.2 ms</span><span>6 ms</span>
          </div>
        </div>

        <div class="slider-group">
          <div class="slider-head">
            <span>λ<sub>c</sub> — Spatial Coherence</span>
            <span class="value" id="lambdaValue">–</span>
          </div>
          <input id="lambdaSlider" type="range" min="0.3" max="2.5" step="0.1" />
          <div style="display:flex;justify-content:space-between;font-size:0.7rem;color:var(--text-soft);margin-top:2px;">
            <span>0.3 nm</span><span>2.5 nm</span>
          </div>
        </div>

        <div class="slider-group">
          <div class="slider-head">
            <span>EM Noise Level</span>
            <span class="value" id="noiseValue">–</span>
          </div>
          <input id="noiseSlider" type="range" min="0" max="1" step="0.01" />
          <div style="display:flex;justify-content:space-between;font-size:0.7rem;color:var(--text-soft);margin-top:2px;">
            <span>Quiet</span><span>Severe</span>
          </div>
        </div>
      </div>

      <div class="compass-wrapper">
        <div class="card-title" style="margin-bottom:4px;">
          <span class="bar"></span>
          <span class="label">Compass v4 Hybrid</span>
        </div>
        <div class="compass">
          <div class="compass-cross"></div>
          <div class="needle tail" id="needleTail"></div>
          <div class="needle" id="needle"></div>
        </div>
        <div class="status-banner" id="statusBanner">
          Navigation Status: Initialising…
        </div>
        <div class="k-indicator" id="kIndicator">
          Kernel Stability Index K ≈ –
        </div>
      </div>
    </div>
  </section>

  <!-- Cryptochrome & environments -->
  <section class="card">
    <div class="card-title">
      <span class="bar"></span>
      <span class="label">Cryptochrome Activation</span>
    </div>
    <div class="crypto-wrap">
      <div class="crypto-dot" id="cryptoDot"></div>
      <div class="crypto-caption" id="cryptoCaption">
        Glow & pulsing scale with K. In a real bird this maps to singlet–triplet
        yield contrast in the cryptochrome pair.
      </div>
    </div>
  </section>

  <section class="card">
    <div class="card-title">
      <span class="bar"></span>
      <span class="label">Environment Presets</span>
    </div>

    <div class="env-grid">
      <button class="env-btn" data-env="Quiet Forest">
        <span class="label">🌲 Quiet Forest</span>
        <span class="icon">●</span>
      </button>
      <button class="env-btn" data-env="Urban Corridor">
        <span class="label">🏙️ Urban EM Noise</span>
        <span class="icon">≋</span>
      </button>
      <button class="env-btn" data-env="Magnetic Storm">
        <span class="label">⛈️ Magnetic Storm</span>
        <span class="icon">⚡</span>
      </button>
      <button class="env-btn" data-env="Solar Flare">
        <span class="label">☀️ Solar Flare</span>
        <span class="icon">✴</span>
      </button>
      <button class="env-btn" data-env="Quantum Lab">
        <span class="label">🧪 Perfect Quantum Lab</span>
        <span class="icon">✨</span>
      </button>
    </div>

    <div class="tool-row">
      <button class="toggle-btn" id="fivegToggle">
        📡 5G Tower: OFF
      </button>
      <button class="toggle-btn" id="dayNightToggle">
        🌞 Day Mode
      </button>
    </div>
  </section>

  <!-- Export tools -->
  <section class="card">
    <div class="card-title">
      <span class="bar"></span>
      <span class="label">Export Tools</span>
    </div>
    <button class="tool-btn" id="exportBtn">
      <span class="icon">📸</span> Export Lab Snapshot
    </button>
    <div class="footnote">
      This is an educational toy, not a full biophysics simulator —
      but the regimes roughly track the <strong>QDS avian kernel notes</strong>:
      τ<sub>c</sub>, λ<sub>c</sub>, and EM noise steering a fragile quantum compass.
    </div>
  </section>
</div>

<!-- Export overlay -->
<div class="overlay" id="exportOverlay">
  <div class="overlay-inner">
    <h2>Lab Snapshot</h2>
    <p style="font-size:0.75rem;color:var(--text-soft);margin-bottom:4px;">
      Long-press to copy, or screenshot this log for your paper trail.
    </p>
    <textarea id="exportText"></textarea>
    <div class="overlay-actions">
      <button id="copyBtn">Copy to clipboard</button>
      <button class="secondary" id="closeOverlayBtn">Close</button>
    </div>
  </div>
</div>

<script>
(function () {
  const speciesPresets = {
    "European Robin":   { tau: 1.4, lambda: 1.2, noise: 0.12 },
    "Racing Pigeon":    { tau: 2.0, lambda: 1.6, noise: 0.10 },
    "Wandering Albatross": { tau: 3.0, lambda: 2.0, noise: 0.06 },
    "Blackcap Warbler": { tau: 1.1, lambda: 1.0, noise: 0.15 },
    "Arctic Tern":      { tau: 2.4, lambda: 1.8, noise: 0.10 }
  };

  const envAdjust = {
    "Quiet Forest":   { tauFactor: 1.00, lambdaFactor: 1.00, noiseOffset: -0.05 },
    "Urban Corridor": { tauFactor: 0.85, lambdaFactor: 0.95, noiseOffset: 0.22 },
    "Magnetic Storm": { tauFactor: 0.70, lambdaFactor: 0.85, noiseOffset: 0.55 },
    "Solar Flare":    { tauFactor: 0.95, lambdaFactor: 1.05, noiseOffset: 0.30 },
    "Quantum Lab":    { tauFactor: 1.10, lambdaFactor: 1.10, noiseOffset: -0.10 }
  };

  const state = {
    species: "European Robin",
    env: "Quiet Forest",
    tau: 1.4,
    lambda: 1.2,
    noise: 0.12,
    K: 0,
    fiveG: false,
    night: false
  };

  const speciesSelect = document.getElementById("speciesSelect");
  const tauSlider = document.getElementById("tauSlider");
  const lambdaSlider = document.getElementById("lambdaSlider");
  const noiseSlider = document.getElementById("noiseSlider");
  const tauValue = document.getElementById("tauValue");
  const lambdaValue = document.getElementById("lambdaValue");
  const noiseValue = document.getElementById("noiseValue");
  const needle = document.getElementById("needle");
  const needleTail = document.getElementById("needleTail");
  const statusBanner = document.getElementById("statusBanner");
  const kIndicator = document.getElementById("kIndicator");
  const cryptoDot = document.getElementById("cryptoDot");
  const cryptoCaption = document.getElementById("cryptoCaption");
  const envButtons = Array.from(document.querySelectorAll(".env-btn"));
  const fivegToggle = document.getElementById("fivegToggle");
  const dayNightToggle = document.getElementById("dayNightToggle");
  const exportBtn = document.getElementById("exportBtn");
  const overlay = document.getElementById("exportOverlay");
  const exportText = document.getElementById("exportText");
  const copyBtn = document.getElementById("copyBtn");
  const closeOverlayBtn = document.getElementById("closeOverlayBtn");

  let compassMode = "stable";
  let lastAngle = -90; // degrees

  function clamp(v, min, max) {
    return Math.min(max, Math.max(min, v));
  }

  function getPresetParams() {
    const base = speciesPresets[state.species] || speciesPresets["European Robin"];
    const adj = envAdjust[state.env] || envAdjust["Quiet Forest"];

    let tau = base.tau * adj.tauFactor;
    let lambda = base.lambda * adj.lambdaFactor;
    let noise = clamp(base.noise + adj.noiseOffset, 0, 1);

    if (state.night) {
      tau *= 1.18;
      noise = clamp(noise - 0.06, 0, 1);
    }

    if (state.fiveG) {
      noise = clamp(noise + 0.25, 0, 1);
    }

    return {
      tau: clamp(tau, 0.2, 6),
      lambda: clamp(lambda, 0.3, 2.5),
      noise
    };
  }

  function syncSlidersToState() {
    tauSlider.value = state.tau;
    lambdaSlider.value = state.lambda;
    noiseSlider.value = state.noise;
    tauValue.textContent = state.tau.toFixed(2) + " ms";
    lambdaValue.textContent = state.lambda.toFixed(2) + " nm";
    noiseValue.textContent = state.noise.toFixed(2);
  }

  function computeK() {
    const tauNorm = state.tau / 3.0;      // ~1 around mid-range
    const lambdaNorm = state.lambda / 1.5;
    const noiseTerm = 1 - state.noise;    // 1 = quiet, 0 = chaos

    let Kraw = tauNorm * lambdaNorm * noiseTerm * 2.6;
    state.K = clamp(Kraw, 0, 2.6);
    kIndicator.textContent =
      "Kernel Stability Index K ≈ " + state.K.toFixed(3);
  }

  function updateStatusAndMode() {
    if (state.K >= 1.6) {
      compassMode = "stable";
      statusBanner.classList.remove("warn", "danger");
      statusBanner.textContent =
        "Stable Navigation — Ideal migratory corridor locked.";
    } else if (state.K >= 0.7) {
      compassMode = "mild";
      statusBanner.classList.remove("danger");
      statusBanner.classList.add("warn");
      statusBanner.textContent =
        "Functional Navigation — Mild noise, drift possible near cities.";
    } else {
      compassMode = "collapse";
      statusBanner.classList.remove("warn");
      statusBanner.classList.add("danger");
      statusBanner.textContent =
        "Compass Collapse — Disorientation; substrate coherence broken.";
    }
  }

  function setNeedleAngle(deg) {
    lastAngle = deg;
    needle.style.transform = "translate(-50%, -10%) rotate(" + deg + "deg)";
    needleTail.style.transform =
      "translate(-50%, -10%) rotate(" + deg + "deg)";
  }

  function animateCompass() {
    let base = -90; // due north
    let jitter = 0;

    if (compassMode === "stable") {
      jitter = (Math.random() - 0.5) * 2.0; // ±1°
    } else if (compassMode === "mild") {
      jitter = (Math.random() - 0.5) * 12; // ±6°
    } else {
      jitter = (Math.random() - 0.5) * 220; // ±110°
    }

    const newAngle = base + jitter;
    setNeedleAngle(newAngle);
  }

  function updateCryptochrome() {
    const K = state.K;
    const intensity = clamp(K / 1.6, 0, 1);
    const scale = 1 + 0.35 * intensity;

    let colorGrad, glowCol;

    if (K >= 1.6) {
      colorGrad =
        "radial-gradient(circle at 30% 20%, #7fffd4, #00c896 55%, #00463d)";
      glowCol = "rgba(0, 248, 180, 0.88)";
      cryptoCaption.textContent =
        "High K: cryptochrome pair strongly biased — compass lines up cleanly with the geomagnetic field.";
    } else if (K >= 0.7) {
      colorGrad =
        "radial-gradient(circle at 30% 20%, #6a63ff, #3423a3 55%, #1b083f)";
      glowCol = "rgba(138, 127, 255, 0.88)";
      cryptoCaption.textContent =
        "Intermediate K: activation is noisy — the bird can still orient but is prone to drift.";
    } else {
      colorGrad =
        "radial-gradient(circle at 30% 20%, #ff5b7c, #6b0320 55%, #250010)";
      glowCol = "rgba(255, 91, 124, 0.95)";
      cryptoCaption.textContent =
        "Low K: cryptochrome signal collapses into noise — headings become effectively random.";
    }

    cryptoDot.style.transform = "scale(" + scale.toFixed(3) + ")";
    cryptoDot.style.background = colorGrad;
    cryptoDot.style.boxShadow =
      "0 0 " +
      (20 + 30 * intensity).toFixed(1) +
      "px " +
      glowCol +
      ", 0 0 50px rgba(0, 255, 209, 0.25)";
  }

  function fullUpdateFromState() {
    syncSlidersToState();
    computeK();
    updateStatusAndMode();
    updateCryptochrome();
  }

  function applyPresetsAndUpdate() {
    const p = getPresetParams();
    state.tau = p.tau;
    state.lambda = p.lambda;
    state.noise = p.noise;
    fullUpdateFromState();
  }

  // Event wiring
  speciesSelect.addEventListener("change", function () {
    state.species = this.value;
    applyPresetsAndUpdate();
  });

  tauSlider.addEventListener("input", function () {
    state.tau = parseFloat(this.value);
    fullUpdateFromState();
  });

  lambdaSlider.addEventListener("input", function () {
    state.lambda = parseFloat(this.value);
    fullUpdateFromState();
  });

  noiseSlider.addEventListener("input", function () {
    state.noise = parseFloat(this.value);
    fullUpdateFromState();
  });

  envButtons.forEach(function (btn) {
    btn.addEventListener("click", function () {
      const env = this.getAttribute("data-env");
      state.env = env;
      envButtons.forEach(function (b) {
        b.classList.toggle("active", b === btn);
      });
      applyPresetsAndUpdate();
    });
  });

  fivegToggle.addEventListener("click", function () {
    state.fiveG = !state.fiveG;
    this.classList.toggle("active", state.fiveG);
    this.textContent = state.fiveG ? "📡 5G Tower: ON" : "📡 5G Tower: OFF";
    applyPresetsAndUpdate();
  });

  dayNightToggle.addEventListener("click", function () {
    state.night = !state.night;
    this.classList.toggle("active", state.night);
    this.textContent = state.night ? "🌙 Night Mode" : "🌞 Day Mode";
    applyPresetsAndUpdate();
  });

  // Export snapshot
  function buildSnapshot() {
    const lines = [];
    lines.push("QDS Avian Magnetoreception Lab v4 PRO+");
    lines.push("Forge Road Build — paper trail snapshot");
    lines.push("--------------------------------------");
    lines.push("Species: " + state.species);
    lines.push("Environment: " + state.env);
    lines.push("Night mode: " + (state.night ? "Night" : "Day"));
    lines.push("5G Tower: " + (state.fiveG ? "ON" : "OFF"));
    lines.push("");
    lines.push("τ_c (ms): " + state.tau.toFixed(3));
    lines.push("λ_c (nm): " + state.lambda.toFixed(3));
    lines.push("EM Noise: " + state.noise.toFixed(3));
    lines.push("Kernel Stability K: " + state.K.toFixed(4));
    lines.push("");
    lines.push("Navigation status: " + statusBanner.textContent);
    lines.push("");
    lines.push(
      "Notes: Parameters are consistent with QDS avian kernel regimes — " +
      "use this snapshot as a high-level log, not a strict biophysical fit."
    );
    lines.push("");
    lines.push(
      "Timestamp (browser): " +
      new Date().toLocaleString()
    );
    return lines.join("\n");
  }

  exportBtn.addEventListener("click", function () {
    exportText.value = buildSnapshot();
    overlay.style.display = "flex";
  });

  closeOverlayBtn.addEventListener("click", function () {
    overlay.style.display = "none";
  });

  copyBtn.addEventListener("click", function () {
    exportText.select();
    try {
      const ok = document.execCommand("copy");
      if (ok) {
        alert("Snapshot copied. Paste into notes or a paper draft.");
      } else {
        alert("Could not auto-copy — long-press and copy manually.");
      }
    } catch (e) {
      alert("Could not auto-copy — long-press and copy manually.");
    }
  });

  overlay.addEventListener("click", function (e) {
    if (e.target === overlay) {
      overlay.style.display = "none";
    }
  });

  // Compass animation loop
  setInterval(animateCompass, 420);

  // Initial state
  envButtons.forEach(function (b) {
    if (b.getAttribute("data-env") === state.env) {
      b.classList.add("active");
    }
  });

  applyPresetsAndUpdate();
})();
</script>
</body>
</html>
EOF

echo "=== Building QDS Avian Magnetoreception Lab v4 PRO+ ==="
echo "[✔] v4 PRO+ HTML generated."

# Start local server on 8011 if not already running
if ! pgrep -f "http.server 8011" >/dev/null 2>&1; then
  echo "[…] Starting local http.server on 8011"
  python -m http.server 8011 --bind 127.0.0.1 >/dev/null 2>&1 &
  sleep 1
fi

# Launch in browser (Termux)
if command -v termux-open-url >/dev/null 2>&1; then
  termux-open-url 'http://127.0.0.1:8011/qds_avian_lab_v4_pro.html'
fi

echo "[🚀] QDS Avian Lab v4 PRO+ launched on http://127.0.0.1:8011/qds_avian_lab_v4_pro.html"
