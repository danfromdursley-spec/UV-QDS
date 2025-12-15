#!/data/data/com.termux/files/usr/bin/bash
set -e
cd "$HOME/OMEGA_EMPIRE/UV_QDS/www"

# 1) Generate a fresh linked GrowthHub copy
./qds_growthhub_autolink_v1.sh

# 2) Open the newest linked page
echo
./run_growthhub_latest_linked.sh
