#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "=== QDS GrowthHub PWA Builder (Termux-safe clean rebuild) ==="

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"
echo "Using base dir: $BASE_DIR"

# 1) Wipe old PWA artifacts
echo "Wiping old PWA artifacts..."
rm -f manifest.json service-worker.js pwa_install_note.txt
rm -rf icons
mkdir -p icons

# 2) Ensure Python + Pillow via Termux packages (preferred)
echo "Ensuring Termux Python + Pillow..."
pkg update -y >/dev/null
pkg install -y python python-pillow >/dev/null

# 3) Generate simple icons
echo "Generating icons..."
python - <<'PY'
from PIL import Image, ImageDraw, ImageFont
import os

def make_icon(size, bg=(10,18,32), fg=(120,220,255), text="QDS"):
    img = Image.new("RGB", (size,size), bg)
    d = ImageDraw.Draw(img)
    r = int(size*0.34)
    cx = cy = size//2
    d.ellipse((cx-r, cy-r, cx+r, cy+r), outline=fg, width=max(2,size//48))
    d.ellipse((cx-r+6, cy-r+6, cx+r-6, cy+r-6), outline=(90,180,230), width=max(1,size//64))
    try:
        font = ImageFont.truetype("DejaVuSans-Bold.ttf", int(size*0.22))
    except:
        font = ImageFont.load_default()
    w, h = d.textsize(text, font=font)
    d.text((cx-w//2, cy-h//2), text, fill=fg, font=font)
    return img

os.makedirs("icons", exist_ok=True)
for s in (192, 384, 512):
    make_icon(s).save(f"icons/icon-{s}.png")

print("Icons built: 192/384/512")
PY

# 4) Write manifest.json
echo "Writing manifest.json..."
cat > manifest.json <<'JSON'
{
  "name": "QDS GrowthHub",
  "short_name": "GrowthHub",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0b1220",
  "theme_color": "#0f172a",
  "icons": [
    { "src": "icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "icons/icon-384.png", "sizes": "384x384", "type": "image/png" },
    { "src": "icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
JSON

# 5) Write service worker
echo "Writing service-worker.js..."
cat > service-worker.js <<'JS'
const CACHE = "qds-growthhub-v1";
const ASSETS = [
  "/",
  "/index.html",
  "/manifest.json",
  "/service-worker.js",
  "/all_pages_index.html",
  "/all_pages_min.html",
  "/icons/icon-192.png",
  "/icons/icon-384.png",
  "/icons/icon-512.png"
];

self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys().then(keys => Promise.all(keys.map(k => k !== CACHE && caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (e) => {
  const req = e.request;
  e.respondWith(
    caches.match(req).then(hit => hit || fetch(req).then(res => {
      const copy = res.clone();
      caches.open(CACHE).then(c => c.put(req, copy)).catch(() => {});
      return res;
    }).catch(() => hit))
  );
});
JS

# 6) Notes
cat > pwa_install_note.txt <<'TXT'
QDS GrowthHub PWA
1) Start local server in this folder: python -m http.server 8011
2) Open: http://127.0.0.1:8011/
3) Chrome menu: Add to Home screen
If you change assets, bump CACHE name in service-worker.js.
TXT

echo "✅ PWA rebuild complete."
