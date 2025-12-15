#!/data/data/com.termux/files/usr/bin/bash
# QDS GrowthHub wiring script – adds pillar anchors + fixes front buttons

set -e

echo "[QDS] Wiring GrowthHub pillars…"

# Work from the script directory
cd "$(dirname "$0")"

stamp=$(date +%Y%m%d_%H%M%S)

########################################
# 1. Pick the /c file (content page)
########################################
C_FILE="c"
if [ ! -f "$C_FILE" ]; then
  if [ -f "growthhub.html" ]; then
    C_FILE="growthhub.html"
  else
    echo "[QDS] ERROR: can't find 'c' or 'growthhub.html'."
    echo "       Run this from your UV_QDS/www folder."
    exit 1
  fi
fi

echo "[QDS] Using content file: $C_FILE"

########################################
# 2. Backups
########################################
cp "$C_FILE" "${C_FILE}_backup_${stamp}.html"

if [ -f "f/index.html" ]; then
  mkdir -p f_backup
  cp f/index.html "f_backup/index_backup_${stamp}.html"
  echo "[QDS] Backed up f/index.html → f_backup/index_backup_${stamp}.html"
fi

echo "[QDS] Backed up $C_FILE → ${C_FILE}_backup_${stamp}.html"

########################################
# 3. Add IDs to the three pillar headings on /c
########################################
# We only touch the start of the <h1> so whatever closing </h1> is there stays.

# Revenue pillar
sed -i 's|<h1>Revenue Floor + Capacity Truth (v2)|<h1 id="pillar-revenue">Revenue Floor + Capacity Truth (v2)|' "$C_FILE"

# Battery pillar (match just the start so it’s tolerant)
sed -i 's|<h1>QDS Hybrid Battery Life Uplift|<h1 id="pillar-battery">QDS Hybrid Battery Life Uplift|' "$C_FILE"

# Signals pillar
sed -i 's|<h1>Compression / Signals|<h1 id="pillar-signals">Compression / Signals|' "$C_FILE"

echo "[QDS] Added pillar IDs on /c page (revenue, battery, signals)."

########################################
# 4. Update front /f buttons to point at anchors
########################################
if [ -f "f/index.html" ]; then
  # First href="/c" → revenue
  sed -i '0,/href="\/c"/s//href="\/c#pillar-revenue"/' f/index.html
  # Second → battery
  sed -i '0,/href="\/c"/s//href="\/c#pillar-battery"/' f/index.html
  # Third → signals
  sed -i '0,/href="\/c"/s//href="\/c#pillar-signals"/' f/index.html

  echo "[QDS] Rewired /f buttons → /c#pillar-* anchors."
else
  echo "[QDS] NOTE: f/index.html not found, skipped frontdoor rewiring."
fi

########################################
# 5. Done
########################################
echo "[QDS] All done."
echo "[QDS] Try these URLs in your browser:"
echo "       Revenue → http://127.0.0.1:8011/c#pillar-revenue"
echo "       Battery → http://127.0.0.1:8011/c#pillar-battery"
echo "       Signals → http://127.0.0.1:8011/c#pillar-signals"
echo "[QDS] Then add each as a Home-screen icon if you like. 🎯"
