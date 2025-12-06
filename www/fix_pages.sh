#!/usr/bin/env bash
set -e

REPO_DIR="${1:-.}"
cd "$REPO_DIR"

# 1) sanity
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repo here. cd into your repo and rerun."
  exit 1
fi

# 2) ensure main branch
CURRENT="$(git branch --show-current || echo "")"
if [ "$CURRENT" != "main" ]; then
  git branch -M main >/dev/null 2>&1 || true
  git checkout -B main
fi

# 3) ensure a simple root index.html
if [ ! -f index.html ]; then
  cat > index.html <<'HTML'
<!doctype html><html><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>UV-QDS Pages</title></head>
<body style="font-family:system-ui;background:#0b1020;color:#e9f1ff;padding:24px">
<h1>UV-QDS Hub</h1><p>Root Pages is alive.</p>
</body></html>
HTML
fi

# 4) commit & push
git add -A
git commit -m "Pages: root index refresh" >/dev/null 2>&1 || true

# make sure origin exists
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "No origin remote set. Add it then rerun."
  exit 1
fi

git push -u origin main

# 5) optional: configure Pages via GitHub CLI
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    OWNER_REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
    echo "Configuring Pages for $OWNER_REPO → branch main / root ..."
    gh api --method PUT "repos/$OWNER_REPO/pages" \
      -f source.branch="main" \
      -f source.path="/" >/dev/null
    echo "Done. Pages set to deploy from main (root)."
  else
    echo "gh installed but not logged in. Run: gh auth login"
  fi
else
  echo "gh not found. Skipping auto Pages config."
  echo "Manual: Repo Settings → Pages → Deploy from branch → main / root."
fi

echo "All good. If you just pushed again quickly, older runs may show 'cancelled' — normal."
