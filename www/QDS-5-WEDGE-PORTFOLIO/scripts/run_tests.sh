#!/usr/bin/env bash
set -e
ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www/QDS-5-WEDGE-PORTFOLIO"

echo "=== QDS 5-Wedge — Microtests 🎩 ==="
echo "Root: $ROOT"
echo

python "$ROOT/tests/qds_battery_ar1_toy.py"
echo
python "$ROOT/tests/qds_compression_toy.py"
echo
python "$ROOT/tests/qds_fieldkit_logger.py"
echo
echo "✅ Microtests complete."
