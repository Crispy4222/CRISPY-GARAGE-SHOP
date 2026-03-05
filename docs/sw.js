self.addEventListener('install', installEvent=>{
  installEvent.waitUntil(caches.open('garage-v1').then(appCache=>appCache.addAll(['./','./index.html','./manifest.webmanifest'])));
});
self.addEventListener('fetch', fetchEvent=>{
  fetchEvent.respondWith(caches.match(fetchEvent.request).then(cachedResponse=>cachedResponse || fetch(fetchEvent.request)));
});
