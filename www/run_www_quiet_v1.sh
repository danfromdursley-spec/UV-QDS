#!/data/data/com.termux/files/usr/bin/bash
cd ~/OMEGA_EMPIRE/UV_QDS/www
echo "Serving www on http://127.0.0.1:8000/"
echo "(Client disconnects may be silenced.)"
python -m http.server 8000 --bind 127.0.0.1 2>/dev/null
