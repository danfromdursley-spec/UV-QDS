#!/bin/bash
set -e

# Lazy UV-QDS index rebuilder
# Run from inside ~/OMEGA_EMPIRE/UV_QDS/www

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

STAMP="$(date +%Y%m%d_%H%M%S)"

# Backup old index if it exists
if [ -f all_pages_index.html ]; then
    cp all_pages_index.html "all_pages_index_backup_${STAMP}.html"
    echo "Backup saved: all_pages_index_backup_${STAMP}.html"
fi

TMP="all_pages_index.tmp"

# ---------- HEADER ----------
cat > "$TMP" <<'EOF'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>UV-QDS – All Pages Index</title>
<style>
:root{
  --bg:#070b12;
  --panel:#0c1220;
  --panel2:#0a0f1b;
  --text:#eef2ff;
  --muted:#a7b0c5;
  --accent:#9d7bff;
  --accent2:#4be3ff;
  --border:rgba(255,255,255,.06);
}
*{box-sizing:border-box;}
body{
  margin:0;
  font-family:system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,sans-serif;
  background:
    radial-gradient(1200px 600px at 20% -10%, rgba(157,123,255,.18), transparent),
    radial-gradient(1000px 700px at 90% 110%, rgba(75,227,255,.14), transparent),
    var(--bg);
  color:var(--text);
}
header{
  padding:28px 18px 10px;
}
main{
  max-width:980px;
  margin:0 auto;
  padding:0 18px 30px;
}
.pill{
  display:inline-block;
  font-size:12px;
  padding:6px 10px;
  border-radius:999px;
  background:linear-gradient(90deg, rgba(157,123,255,.18), rgba(75,227,255,.18));
  border:1px solid var(--border);
  color:var(--muted);
  margin-bottom:10px;
}
h1{margin:6px 0 4px; font-size:26px; letter-spacing:.02em;}
p{margin:0 0 16px; color:var(--muted); font-size:14px;}

.controls{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  background:linear-gradient(180deg, rgba(255,255,255,.04), transparent);
  border:1px solid var(--border);
  border-radius:16px;
  padding:10px 12px;
}
input, select, button{
  background:var(--panel);
  color:var(--text);
  border:1px solid var(--border);
  border-radius:10px;
  padding:8px 10px;
  font-size:14px;
  outline:none;
}
input{flex:1 1 220px; min-width:180px;}
button{cursor:pointer;}
button:hover{
  border-color:var(--accent2);
  box-shadow:0 0 0 1px rgba(75,227,255,.35);
}

.grid{
  margin-top:14px;
  display:grid;
  gap:10px;
  grid-template-columns:repeat(auto-fit, minmax(240px, 1fr));
}
.card{
  text-decoration:none;
  color:inherit;
  background:linear-gradient(180deg, rgba(255,255,255,.03), transparent);
  var(--panel2);
  border:1px solid var(--border);
  border-radius:16px;
  padding:14px 14px 12px;
  transition:transform .12s ease, border-color .12s ease, background .12s ease;
}
.card:hover{
  transform:translateY(-1px);
  border-color:rgba(157,123,255,.55);
  background:linear-gradient(180deg, rgba(157,123,255,.08), rgba(75,227,255,.04));
}
.name{
  font-weight:650;
  font-size:16px;
  margin:0 0 4px;
}
.path{
  font-size:11px;
  color:var(--muted);
  opacity:.9;
  word-break:break-all;
}
.tag{
  display:inline-block;
  margin-top:8px;
  font-size:10px;
  padding:3px 7px;
  border-radius:999px;
  border:1px solid var(--border);
  color:var(--muted);
}
footer{
  max-width:980px;
  margin:0 auto;
  padding:8px 18px 18px;
  color:var(--muted);
  font-size:11px;
}
.stats{
  font-size:11px;
  opacity:.8;
  margin-top:6px;
}
</style>
</head>
<body>
<header>
  <span class="pill">Auto-generated master map</span>
  <h1>UV-QDS – All Pages Index</h1>
  <p>A single hub linking every local HTML tool/page in this build.</p>
</header>

<main>
  <div class="controls">
    <input id="q" placeholder="Filter pages… (battery, universe, solar, growthhub, h-code, indus…)" />
    <select id="group">
      <option value="none">No grouping</option>
      <option value="category">Group by category</option>
    </select>
    <button id="reset">Reset</button>
  </div>
  <div class="stats" id="stats"></div>
  <div id="list" class="grid"></div>
</main>

<footer>
  Tip: this file is auto-built. Re-run <code>make_all_pages_index_auto.sh</code> after you add new tools.
</footer>

<script>
// ---- data injected below ----
const PAGES = [
EOF

# ---------- DATA FROM FILESYSTEM ----------
first=1
for f in *.html; do
    # skip index builders & backups
    case "$f" in
        all_pages_index.html|all_pages_min.html|all_pages.html|all_pages_compact.html) continue ;;
        *backup*html) continue ;;
    esac

    title="${f%.html}"
    pretty_title="$(echo "$title" | sed 's/_/ /g')"

    if [ $first -eq 1 ]; then
        first=0
    else
        echo "," >> "$TMP"
    fi

    cat >> "$TMP" <<EOF
  { title: "$pretty_title", href: "$f" }
EOF
done

# ---------- FOOTER / JS ----------
cat >> "$TMP" <<'EOF'
];

const categorize = (name) => {
  const n = name.toLowerCase();
  if (n.includes("battery")) return "Battery";
  if (n.includes("universe")) return "Universe";
  if (n.includes("solar")) return "Solar";
  if (n.includes("growthhub") || n.includes("offer")) return "Growth / Revenue";
  if (n.includes("omega") || n.includes("os")) return "Ω / OS";
  if (n.includes("index")) return "Indexes / Hubs";
  if (n.includes("indus") || n.includes("language")) return "Language / Indus";
  if (n.includes("her") || n.includes("stinchcombe")) return "Maps / HER";
  if (n.includes("h code") || n.includes("h_code")) return "H-Code / Nervous System";
  if (n.includes("test") || n.includes("lab")) return "Tests / Labs";
  return "Misc";
};

const elList  = document.getElementById("list");
const elQ     = document.getElementById("q");
const elGroup = document.getElementById("group");
const elReset = document.getElementById("reset");
const elStats = document.getElementById("stats");

const FULL = PAGES.map(p => ({
  ...p,
  path: p.href,
  category: categorize(p.title + " " + p.href),
}));

const renderFlat = (items) => {
  elList.innerHTML = "";
  for (const p of items) {
    const a = document.createElement("a");
    a.className = "card";
    a.href = p.href;
    a.innerHTML = `
      <div class="name">${p.title}</div>
      <div class="path">${p.path}</div>
      <span class="tag">${p.category}</span>
    `;
    elList.appendChild(a);
  }
};

const renderGrouped = (items) => {
  elList.innerHTML = "";
  const groups = {};
  for (const p of items) {
    (groups[p.category] ||= []).push(p);
  }
  const cats = Object.keys(groups).sort();
  for (const c of cats) {
    const header = document.createElement("div");
    header.style.gridColumn = "1 / -1";
    header.style.padding = "8px 6px 2px";
    header.style.color = "#a7b0c5";
    header.style.fontSize = "12px";
    header.style.letterSpacing = ".06em";
    header.textContent = c;
    elList.appendChild(header);

    for (const p of groups[c]) {
      const a = document.createElement("a");
      a.className = "card";
      a.href = p.href;
      a.innerHTML = `
        <div class="name">${p.title}</div>
        <div class="path">${p.path}</div>
        <span class="tag">${p.category}</span>
      `;
      elList.appendChild(a);
    }
  }
};

const apply = () => {
  const q = (elQ.value || "").toLowerCase().trim();
  let items = FULL.filter(p =>
    !q ||
    p.title.toLowerCase().includes(q) ||
    p.path.toLowerCase().includes(q) ||
    p.category.toLowerCase().includes(q)
  );

  // update stats
  elStats.textContent = `${items.length} pages shown · ${FULL.length} total`;

  if (elGroup.value === "category") renderGrouped(items);
  else renderFlat(items);
};

elQ.addEventListener("input", apply);
elGroup.addEventListener("change", apply);
elReset.addEventListener("click", () => {
  elQ.value = "";
  elGroup.value = "none";
  apply();
});

// init
apply();
</script>
</body>
</html>
EOF

mv "$TMP" all_pages_index.html
echo "all_pages_index.html rebuilt with $(grep -c 'href' all_pages_index.html) entries."
