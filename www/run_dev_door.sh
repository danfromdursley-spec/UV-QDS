#!/data/data/com.termux/files/usr/bin/bash
cd ~/OMEGA_EMPIRE/UV_QDS/www
pkill -f "http.server 8011" 2>/dev/null
python -m http.server 8011 --bind 127.0.0.1 >/dev/null 2>&1 &
sleep 0.2
termux-open-url "http://127.0.0.1:8011/dev_door_space.html"
