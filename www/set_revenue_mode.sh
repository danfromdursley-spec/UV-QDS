#!/data/data/com.termux/files/usr/bin/bash
# Usage: ./set_revenue_mode.sh base|stretch

cd "$(dirname "$0")"

case "$1" in
  base)
    cp qds_revenue_floor_BASE.html qds_revenue_floor_v2.html
    echo "Revenue mode: BASE"
    ;;
  stretch)
    cp qds_revenue_floor_STRETCH.html qds_revenue_floor_v2.html
    echo "Revenue mode: STRETCH"
    ;;
  *)
    echo "Usage: $0 base|stretch"
    exit 1
    ;;
esac
