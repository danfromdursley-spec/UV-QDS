const CACHE = "growthhub-aio-v1-1";
const ASSETS = [
  "./growthhub_allinone_v1_1.html",
  "./manifest-growthhub.json",
  "./sw-growthhub.js",
  "./growthhub_icon.svg"
];

self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});
self.addEventListener("activate", (e) => {
  e.waitUntil(caches.keys().then((keys) =>
    Promise.all(keys.map((k) => (k !== CACHE ? caches.delete(k) : null)))
  ).then(() => self.clients.claim()));
});
self.addEventListener("fetch", (e) => {
  e.respondWith(caches.match(e.request).then((cached) => cached || fetch(e.request)));
});
