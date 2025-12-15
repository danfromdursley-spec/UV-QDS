#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "[GH] Creating neon battery icons…"

# Make sure ImageMagick is installed
pkg install -y imagemagick >/dev/null 2>&1 || true

cd "$(dirname "$0")"
mkdir -p icons

# Big 512×512 icon
convert -size 512x512 xc:'#05080f' \
  -fill '#00c8ff' -stroke '#00f0ff' -strokewidth 22 \
  -draw "circle 256,256 256,72" \
  -fill '#39ff88' -stroke '#39ff88' -strokewidth 0 \
  -draw "roundrectangle 150,208 362,304 34,34" \
  -fill '#05080f' \
  -draw "roundrectangle 176,230 336,282 24,24" \
  -fill '#39ff88' \
  -draw "rectangle 362,236 392,276" \
  -font DejaVu-Sans-Bold -pointsize 110 -fill '#00f5ff' \
  -gravity center -annotate 0 "GH" \
  icons/icon-512.png

# Smaller 192×192 icon
convert icons/icon-512.png -resize 192x192 icons/icon-192.png

echo "[GH] Icons written to icons/icon-512.png and icons/icon-192.png"
echo "[GH] Now remove and re-add the home-screen shortcut so Android picks up the new artwork."
