#!/data/data/com.termux/files/usr/bin/bash
cd ~/UV_QDS/www

# kill any old server
pkill -f "http.server" 2>/dev/null

# start fresh server
python -m http.server 8011 --bind 127.0.0.1 &

# tiny pause so server is ready
sleep 1

# open the lab
termux-open-url 'http://127.0.0.1:8011/qds_avian_lab_v2.html'
