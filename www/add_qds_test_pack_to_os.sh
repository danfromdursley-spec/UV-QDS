#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
cd "$ROOT" || { echo "Missing folder: $ROOT"; exit 1; }

# --- target file detection ---
HOMEFILE=""
if [ -f "omega_qds_lab.html" ]; then
  HOMEFILE="omega_qds_lab.html"
elif [ -f "index.html" ]; then
  HOMEFILE="index.html"
else
  echo "No OS home page found (omega_qds_lab.html or index.html)."
  echo "Files here:"
  ls -1
  exit 1
fi

PACK="qds_test_task_pack_v1_1_pro.html"

if [ ! -f "$PACK" ]; then
  echo "WARNING: $PACK not found yet."
  echo "I can still add the tile, but the link will 404 until you drop the file."
fi

TITLE="QDS Test Task Pack v1.1 PRO"
MARK="QDS_OS_TILE_TESTPACK_V1_1_PRO"

# --- no duplicate injection ---
if grep -q "$MARK" "$HOMEFILE" || grep -q "$TITLE" "$HOMEFILE"; then
  echo "Tile already present in $HOMEFILE ✅"
  exit 0
fi

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP="${HOMEFILE}.bak_${STAMP}"
cp "$HOMEFILE" "$BACKUP"

# --- snippet to inject ---
read -r -d '' SNIP <<'HTML'
<!-- QDS_OS_TILE_TESTPACK_V1_1_PRO -->
<style id="qds-os-tile-style">
  .qds-os-section{margin:14px 0 6px 0}
  .qds-os-h{font-size:1.05rem;font-weight:700;opacity:.9;margin:8px 0 10px 0}
  .tile{display:block;padding:14px 16px;margin:10px 0;border-radius:16px;
        background:rgba(255,255,255,0.04);
        border:1px solid rgba(120,160,255,0.18);
        text-decoration:none;color:inherit}
  .tile-title{font-size:1.05rem;font-weight:700;margin-bottom:4px}
  .tile-sub{opacity:.75;font-size:.92rem}
  .tile-badge{display:inline-block;padding:3px 8px;border-radius:999px;
              font-size:.75rem;opacity:.85;margin-bottom:8px;
              background:rgba(120,160,255,0.12);
              border:1px solid rgba(120,160,255,0.18)}
</style>

<section class="qds-os-section">
  <div class="qds-os-h">QDS Field Tools</div>
  <a class="tile" href="./qds_test_task_pack_v1_1_pro.html">
    <div class="tile-badge">Offline-first • Phone-safe • No libs</div>
    <div class="tile-title">QDS Test Task Pack v1.1 PRO</div>
    <div class="tile-sub">Checklist + H₀ micro-fit + Galaxy RMS + JSON logs</div>
  </a>
</section>
HTML

# --- remove CSS block if already exists (super safe) ---
# If your OS already has tile styling, this won't conflict much.
# The style tag has a unique id.

TMP="${HOMEFILE}.tmp_${STAMP}"

# Insert SNIP before </body> if present; else append to end.
if grep -qi "</body>" "$HOMEFILE"; then
  awk -v snip="$SNIP" '
    BEGIN{IGNORECASE=1}
    {
      if ($0 ~ /<\/body>/ && !done) {
        print snip
        done=1
      }
      print
    }
  ' "$HOMEFILE" > "$TMP"
else
  cat "$HOMEFILE" > "$TMP"
  echo "" >> "$TMP"
  echo "$SNIP" >> "$TMP"
fi

mv "$TMP" "$HOMEFILE"

echo "✅ Added tile to: $HOMEFILE"
echo "🧯 Backup saved: $BACKUP"
echo "🔗 Link points to: ./$PACK"
