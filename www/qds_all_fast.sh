#!/data/data/com.termux/files/usr/bin/bash
cd "$HOME/OMEGA_EMPIRE/UV_QDS/www" || exit 1
chmod +x qds_inject_offer_links_v1.sh qds_growthhub_autolink_v1.sh 2>/dev/null || true
./qds_inject_offer_links_v1.sh 2>/dev/null || true
./qds_growthhub_autolink_v1.sh 2>/dev/null || true
ls -1t growthhub_linked_*.html 2>/dev/null | head -n 1 | sed 's|^|Latest linked: |' || true
