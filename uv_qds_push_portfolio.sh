#!/data/data/com.termux/files/usr/bin/bash
set -e
cd ~/OMEGA_EMPIRE/UV_QDS

echo "=== Safe portfolio push ==="
git status

echo ""
echo "[1] Staging ONLY portfolio_market_allinone_v1.html"
git add www/portfolio_market_allinone_v1.html

echo ""
echo "[2] Quick check"
git diff --cached --stat

msg="${1:-Add market all-in-one portfolio + DOI}"
echo ""
echo "[3] Commit: $msg"
git commit -m "$msg"

echo ""
echo "[4] Push"
git push

echo "=== Done ==="
