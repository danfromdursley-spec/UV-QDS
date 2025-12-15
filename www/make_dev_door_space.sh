#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
OUT="$ROOT/dev_door_space.html"

cd "$ROOT"

# Collect html files (exclude backups unless you want them)
# You can adjust this filter anytime.
mapfile -t FILES < <(
  find . -type f -name "*.html" \
    ! -name "*backup*" \
    ! -path "./f_backup/*" \
    | sed 's|^\./||' \
    | sort
)

# Build JSON array for JS
JSON_ITEMS=""
for f in "${FILES[@]}"; do
  # basic category tags by filename
  cat="Other"
  lf="$(echo "$f" | tr '[:upper:]' '[:lower:]')"

  if [[ "$lf" == *"frontdoor"* ]]; then cat="Front Doors"
  elif [[ "$lf" == *"dev_hub"* || "$lf" == *"dev_door"* ]]; then cat="Dev/Index"
  elif [[ "$lf" == *"growthhub"* ]]; then cat="GrowthHub"
  elif [[ "$lf" == *"battery"* ]]; then cat="Battery"
  elif [[ "$lf" == *"revenue"* || "$lf" == *"business"* || "$lf" == *"offer"* || "$lf" == *"portfolio"* ]]; then cat="Business/Offers"
  elif [[ "$lf" == *"compression"* || "$lf" == *"save"* ]]; then cat="Compression"
  elif [[ "$lf" == *"universe"* || "$lf" == *"solar"* || "$lf" == *"planet"* ]]; then cat="Universe/Demos"
  elif [[ "$lf" == *"indus"* || "$lf" == *"atlas"* ]]; then cat="Language/Heritage"
  elif [[ "$lf" == *"cannon"* || "$lf" == *"catapult"* || "$lf" == *"pinball"* ]]; then cat="Games/Toys"
  elif [[ "$lf" == *"map"* || "$lf" == *"stinchcombe"* ]]; then cat="Maps/Local"
  fi

  # title cleanup
  title="$(basename "$f")"
  title="${title%.html}"
  title="$(echo "$title" | sed 's/_/ /g')"

  JSON_ITEMS+="{\"file\":\"$f\",\"title\":\"$title\",\"cat\":\"$cat\"},"
done

# Remove trailing comma safely
JSON_ITEMS="${JSON_ITEMS%,}"

cat > "$OUT" <<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>DEV DOOR — Space Index</title>
  <meta name="theme-color" content="#05070b" />
  <style>
    :root{
      --bg:#05070b;
      --bg2:#0b0f16;
      --panel:#0c111a;
      --text:#e8f1ff;
      --muted:#9aa8bf;
      --accent1:#00e5ff;
      --accent2:#00ff88;
      --warn:#ffd36a;
      --shadow: 0 10px 30px rgba(0,0,0,.45);
      --r: 18px;
    }
    *{box-sizing:border-box}
    body{
      margin:0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
      color:var(--text);
      background:
        radial-gradient(1200px 700px at 10% -10%, rgba(0,229,255,.12), transparent 50%),
        radial-gradient(1200px 700px at 90% 10%, rgba(0,255,136,.12), transparent 50%),
        linear-gradient(180deg, var(--bg), var(--bg2));
    }
    header{
      position: sticky; top:0; z-index:50;
      backdrop-filter: blur(10px);
      background: rgba(5,7,11,.75);
      border-bottom: 1px solid rgba(255,255,255,.06);
    }
    .wrap{max-width: 1050px; margin:0 auto; padding: 18px 16px 40px}
    .row{display:flex; gap:10px; flex-wrap:wrap; align-items:center; justify-content:space-between}
    .brand{display:flex; gap:12px; align-items:center}
    .logo{
      width:38px; height:38px; border-radius:12px;
      background: linear-gradient(135deg, rgba(0,229,255,.22), rgba(0,255,136,.22));
      border: 1px solid rgba(255,255,255,.08);
      display:grid; place-items:center;
      box-shadow: inset 0 0 0 1px rgba(255,255,255,.03);
    }
    .logo-dot{
      width:18px; height:18px; border-radius:6px;
      background: linear-gradient(135deg, var(--accent1), var(--accent2));
      filter: drop-shadow(0 0 10px rgba(0,229,255,.35));
    }
    h1{font-size: 1.2rem; margin:0}
    .sub{font-size:.85rem; color:var(--muted)}
    .pill{
      display:inline-flex; align-items:center; gap:8px;
      padding: 6px 10px; border-radius: 999px;
      background: rgba(255,255,255,.05);
      border: 1px solid rgba(255,255,255,.06);
      font-size:.78rem; color:var(--muted)
    }
    .card{
      background: linear-gradient(180deg, rgba(255,255,255,.02), rgba(255,255,255,.01));
      border: 1px solid rgba(255,255,255,.06);
      border-radius: var(--r);
      padding: 16px 16px 14px;
      box-shadow: var(--shadow);
    }
    .grid{display:grid; gap:12px; grid-template-columns: 1fr;}
    @media (min-width: 900px){
      .grid-2{grid-template-columns: 1fr 1fr}
    }
    .controls{
      display:flex; gap:8px; flex-wrap:wrap;
    }
    input, select{
      background: rgba(255,255,255,.04);
      border: 1px solid rgba(255,255,255,.08);
      color: var(--text);
      padding: 10px 10px;
      border-radius: 12px;
      outline: none;
      min-width: 160px;
    }
    input::placeholder{color: rgba(200,210,230,.55)}
    .btn{
      appearance:none; border:0; cursor:pointer;
      padding: 9px 12px; border-radius: 12px;
      font-weight: 650; letter-spacing:.2px;
      background: linear-gradient(135deg, rgba(0,229,255,.18), rgba(0,255,136,.18));
      color: var(--text);
      border: 1px solid rgba(255,255,255,.08);
      box-shadow: var(--shadow);
      text-decoration:none;
      display:inline-flex; align-items:center; gap:8px;
    }
    .btn-quiet{
      background: rgba(255,255,255,.04);
      font-weight: 550;
    }
    .tag{
      display:inline-block; padding: 3px 8px; border-radius: 999px;
      font-size:.7rem; margin-right:6px;
      background: rgba(0,229,255,.08);
      border: 1px solid rgba(0,229,255,.18);
      color: #cfefff;
    }
    .tag.warn{
      background: rgba(255,211,106,.08);
      border-color: rgba(255,211,106,.2);
      color: #fff0c9;
    }
    .section-title{
      display:flex; align-items:center; justify-content:space-between;
      gap: 10px;
    }
    h2{font-size: 1.0rem; margin:0 0 8px 0}
    .muted{color: var(--muted)}
    .list{
      display:grid; gap:8px;
      grid-template-columns: 1fr;
    }
    @media (min-width: 900px){
      .list{grid-template-columns: 1fr 1fr;}
    }
    .item{
      border: 1px solid rgba(255,255,255,.06);
      background: rgba(255,255,255,.02);
      border-radius: 14px;
      padding: 12px 12px 10px;
      display:flex; gap:10px; align-items:center; justify-content:space-between;
    }
    .item-title{
      font-size:.92rem; font-weight: 650;
    }
    .item-path{
      font-size:.72rem; color: var(--muted);
      opacity:.9;
    }
    .left{
      min-width: 0;
    }
    .right{
      display:flex; gap:6px; flex-wrap:wrap;
    }
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;}
    .divider{
      height:1px; background: rgba(255,255,255,.06); margin: 12px 0;
    }
    .tiny{font-size:.75rem}
  </style>
</head>
<body>

<header>
  <div class="wrap">
    <div class="row">
      <div class="brand">
        <div class="logo"><div class="logo-dot"></div></div>
        <div>
          <h1>DEV DOOR — Space Index</h1>
          <div class="sub">Standalone lab gateway • Clean list • Working buttons</div>
        </div>
      </div>
      <div class="row">
        <span class="pill">Internal Use • Not a pitch page</span>
        <a class="btn btn-quiet" href="frontdoor_show.html">Back to Front Door</a>
      </div>
    </div>

    <div class="card" style="margin-top:10px;">
      <div class="controls">
        <input id="q" placeholder="Search titles or filenames…" />
        <select id="cat">
          <option value="ALL">All categories</option>
        </select>
        <button class="btn btn-quiet" id="latestBtn">Show latest 20</button>
        <button class="btn btn-quiet" id="allBtn">Show all</button>
      </div>
      <div class="tiny muted" style="margin-top:8px;">
        This page is auto-generated from your local <span class="mono">www</span> directory.
      </div>
    </div>
  </div>
</header>

<main class="wrap">
  <section class="grid grid-2">
    <div class="card">
      <div class="section-title">
        <h2>Quick Gates</h2>
        <span class="tag warn">Fast Jump</span>
      </div>
      <div class="right">
        <a class="btn" href="all_pages_index.html">All Pages Index</a>
        <a class="btn" href="all_pages_min.html">All Pages Min</a>
        <a class="btn" href="dev_hub.html">Legacy Dev Hub</a>
        <a class="btn" href="qds_showcase_index_v1_1.html">Showcase Index</a>
      </div>
      <div class="divider"></div>
      <div class="muted tiny">
        These are fixed “known good” anchors in case you want a stable breadcrumb trail.
      </div>
    </div>

    <div class="card">
      <div class="section-title">
        <h2>Status</h2>
      </div>
      <div class="muted tiny">
        Total detected HTML files (filtered): <span id="count">0</span>
      </div>
      <div class="divider"></div>
      <div class="muted tiny">
        Generator: <span class="mono">make_dev_door_space.sh</span><br>
        Output: <span class="mono">dev_door_space.html</span>
      </div>
    </div>
  </section>

  <section class="card" style="margin-top:12px;">
    <div class="section-title">
      <h2 id="listTitle">Files</h2>
      <span class="muted tiny">Tap open = loads locally via your server</span>
    </div>
    <div class="list" id="list"></div>
  </section>

  <footer class="muted tiny" style="margin-top:20px;">
    DEV DOOR — Space Index • standalone utility page • safe to keep separate from GrowthHub.
  </footer>
</main>

<script>
  const ITEMS = [
    ${JSON_ITEMS}
  ];

  // Tiny helper to sort newest-ish by filename fallback
  // (We avoid fs calls since this is a static page).
  function scoreName(s){
    // prefer timestamp-like chunks
    const m = s.match(/(20\\d{6})_(\\d{6})|(20\\d{2})(\\d{2})(\\d{2})/);
    if (!m) return 0;
    return 1;
  }

  const q = document.getElementById("q");
  const cat = document.getElementById("cat");
  const list = document.getElementById("list");
  const count = document.getElementById("count");
  const latestBtn = document.getElementById("latestBtn");
  const allBtn = document.getElementById("allBtn");
  const listTitle = document.getElementById("listTitle");

  // Populate categories
  const cats = Array.from(new Set(ITEMS.map(i => i.cat))).sort();
  for (const c of cats){
    const opt = document.createElement("option");
    opt.value = c;
    opt.textContent = c;
    cat.appendChild(opt);
  }

  let mode = "ALL";

  function render(){
    const term = (q.value || "").toLowerCase().trim();
    const csel = cat.value;

    let data = ITEMS.slice();

    if (csel !== "ALL"){
      data = data.filter(i => i.cat === csel);
    }

    if (term){
      data = data.filter(i =>
        i.title.toLowerCase().includes(term) ||
        i.file.toLowerCase().includes(term)
      );
    }

    if (mode === "LATEST"){
      // crude "latest-ish": prioritize names with timestamps and longer versions
      data = data
        .sort((a,b) => (scoreName(b.file) - scoreName(a.file)) || (b.file.localeCompare(a.file)))
        .slice(0,20);
      listTitle.textContent = "Latest 20 (name-ranked)";
    } else {
      listTitle.textContent = "Files";
    }

    list.innerHTML = "";
    count.textContent = ITEMS.length;

    for (const i of data){
      const row = document.createElement("div");
      row.className = "item";

      const left = document.createElement("div");
      left.className = "left";

      const t = document.createElement("div");
      t.className = "item-title";
      t.textContent = i.title;

      const p = document.createElement("div");
      p.className = "item-path mono";
      p.textContent = i.file;

      const tag = document.createElement("span");
      tag.className = "tag";
      tag.textContent = i.cat;

      left.appendChild(tag);
      left.appendChild(t);
      left.appendChild(p);

      const right = document.createElement("div");
      right.className = "right";

      const open = document.createElement("a");
      open.className = "btn";
      open.href = i.file;
      open.textContent = "Open";

      const copy = document.createElement("button");
      copy.className = "btn btn-quiet";
      copy.textContent = "Copy path";
      copy.addEventListener("click", async () => {
        try{
          await navigator.clipboard.writeText(i.file);
          copy.textContent = "Copied";
          setTimeout(()=>copy.textContent="Copy path", 800);
        }catch(e){
          copy.textContent = "No clipboard";
          setTimeout(()=>copy.textContent="Copy path", 900);
        }
      });

      right.appendChild(open);
      right.appendChild(copy);

      row.appendChild(left);
      row.appendChild(right);
      list.appendChild(row);
    }

    if (!data.length){
      const empty = document.createElement("div");
      empty.className = "muted tiny";
      empty.textContent = "No matches. Try clearing filters.";
      list.appendChild(empty);
    }
  }

  q.addEventListener("input", render);
  cat.addEventListener("change", render);

  latestBtn.addEventListener("click", () => { mode="LATEST"; render(); });
  allBtn.addEventListener("click", () => { mode="ALL"; render(); });

  render();
</script>
</body>
</html>
HTML

echo "✅ Built: $OUT"
echo "Open with:"
echo "  python -m http.server 8011 --bind 127.0.0.1 &"
echo "  termux-open-url 'http://127.0.0.1:8011/dev_door_space.html'"
