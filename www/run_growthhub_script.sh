#!/data/data/com.termux/files/usr/bin/bash
cd ~/UV_QDS/www

# kill any old server on 8011
pkill -f "http.server 8011" 2>/dev/null

# start fresh server
python -m http.server 8011 --bind 127.0.0.1 &

# give it a moment to start
sleep 2

# open the page
termux-open-url 'http://127.0.0.1:8011/growthhub_meeting_script_v1.html'
