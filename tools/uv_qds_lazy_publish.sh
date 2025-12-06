#!/usr/bin/env bash
set -euo pipefail

# =========================
# UV-QDS Lazy Publish v1
# =========================
# What it does:
# 1) Find repo root
# 2) Build all_pages_index.html (via tools_make_all_pages_index if available)
# 3) Optionally (flag) refresh minimal front-door index.html
# 4) Stage key pages
# 5) Commit + push
#
# Usage:
#   bash tools/uv_qds_lazy_publish.sh
#
# Optional env flags:
#   REFRESH_FRONT_DOOR=1   -> rewrite www/index.html to minimal 4-link front door
#   MSG="your message"     -> custom commit message
#

log() { printf "\n\033[1;36m%s\033[0m\n" "$*"; }
warn() { printf "\n\033[1;33m%s\033[0m\n" "$*"; }

# Find repo root
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${ROOT}" ]]; then
  warn "Not inside a git repo. Aborting."
  exit 1
fi
cd "$ROOT"

WWW_DIR="$ROOT/www"
TOOLS_DIR="$ROOT/tools"

if [[ ! -d "$WWW_DIR" ]]; then
  warn "Expected www/ folder not found at: $WWW_DIR"
  exit 1
fi

log "Repo root: $ROOT"

# 1) Build All Pages Index
GEN="$TOOLS_DIR/tools_make_all_pages_index.sh"
if [[ -x "$GEN" ]]; then
  log "Running generator: $GEN"
  bash "$GEN"
else
  warn "Generator not found/executable. Falling back to simple builder."

  (
    echo "<!doctype html>"
    echo "<html><head>"
    echo "<meta name='viewport' content='width=device-width,initial-scale=1'>"
    echo "<meta charset='utf-8'>"
    echo "<title>All Pages Index</title>"
    echo "<style>"
    echo "body{font-family:system-ui;background:#0b0d14;color:#eaeefc;margin:0;padding:22px}"
    echo "a{color:#b9a7ff;text-decoration:none}"
    echo "li{margin:6px 0}"
    echo "</style>"
    echo "</head><body>"
    echo "<h1>All Pages Index</h1>"
    echo "<ul>"

    cd "$WWW_DIR"
    find . -maxdepth 3 -name "*.html" | sort | sed 's|^\./||' \
      | awk '{print "<li><a href=\"" $0 "\">" $0 "</a></li>"}'

    echo "</ul>"
    echo "<p><small>Auto-generated fallback index.</small></p>"
    echo "</body></html>"
  ) > "$WWW_DIR/all_pages_index.html"

  log "Built fallback: $WWW_DIR/all_pages_index.html"
fi

# 2) Optional: refresh minimal front door
if [[ "${REFRESH_FRONT_DOOR:-0}" == "1" ]]; then
  log "Refreshing minimal front door index.html (REFRESH_FRONT_DOOR=1)"

  cat > "$WWW_DIR/index.html" <<'HTML'
<!doctype html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta charset="utf-8">
  <title>Ω/QDS Home</title>
  <style>
    body{font-family:system-ui;background:#0b0d14;color:#eaeefc;margin:0;padding:24px}
    a{display:block;padding:14px 16px;margin:10px 0;background:#151a2b;border-radius:14px;
      color:#eaeefc;text-decoration:none}
    small{opacity:.7}
  </style>
</head>
<body>
  <h1>Ω / QDS Home</h1>
  <small>Minimal front door (no manual upkeep).</small>

  <a href="portfolio_ultimate_allinone_v1.html">Portfolio — Build Highlights</a>
  <a href="start_here_90s_v1.html">Start Here — 90s Fast Demo Path</a>
  <a href="legacy_hub_v1.html">Legacy Hub v1 — Early Experiments Arcade</a>
  <a href="all_pages_index.html">All Pages Index (auto-generated)</a>
</body>
</html>
HTML
fi

# 3) Stage files we care about
log "Staging key pages"
git add "$WWW_DIR/all_pages_index.html" || true

# Only add these if they exist
[[ -f "$WWW_DIR/index.html" ]] && git add "$WWW_DIR/index.html" || true
[[ -f "$WWW_DIR/legacy_hub_v1.html" ]] && git add "$WWW_DIR/legacy_hub_v1.html" || true

# 4) Commit if there are changes
if git diff --cached --quiet; then
  warn "No staged changes. Nothing to commit."
  exit 0
fi

STAMP="$(date +'%Y-%m-%d %H:%M')"
DEFAULT_MSG="Lazy publish: indexes + hubs ($STAMP)"
COMMIT_MSG="${MSG:-$DEFAULT_MSG}"

log "Committing: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

log "Pushing..."
git push

log "Done ✅"
log "Tip: Run local server with:"
echo "  cd \"$WWW_DIR\" && pkill -f http.server 2>/dev/null; python -m http.server 8000"
