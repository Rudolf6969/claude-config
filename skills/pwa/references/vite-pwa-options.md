# VitePWA — Kompletné options

```typescript
VitePWA({
  // Ako sa registruje service worker
  registerType: 'autoUpdate' | 'prompt',
  // autoUpdate — SW sa updatuje automaticky pri novom deployi
  // prompt   — zobrazí prompt useróvi (použitie: useRegisterSW hook)

  // Súbory ktoré sa vždy cachujú (prekaching)
  includeAssets: ['favicon.ico', 'robots.txt', 'apple-touch-icon.png'],

  // Web App Manifest
  manifest: {
    name: 'Full App Name',
    short_name: 'Short',          // max 12 znakov (icon label)
    description: '...',
    theme_color: '#0A0805',        // farba status baru
    background_color: '#0A0805',  // splash screen pozadie
    display: 'standalone',         // standalone | fullscreen | minimal-ui
    orientation: 'portrait',
    start_url: '/?source=pwa',    // tracking parameter
    scope: '/',
    lang: 'sk',
    categories: ['shopping', 'lifestyle'],
    icons: [
      { src: 'icon-72.png',   sizes: '72x72',   type: 'image/png' },
      { src: 'icon-96.png',   sizes: '96x96',   type: 'image/png' },
      { src: 'icon-128.png',  sizes: '128x128', type: 'image/png' },
      { src: 'icon-144.png',  sizes: '144x144', type: 'image/png' },
      { src: 'icon-152.png',  sizes: '152x152', type: 'image/png' },
      { src: 'icon-192.png',  sizes: '192x192', type: 'image/png' },
      { src: 'icon-384.png',  sizes: '384x384', type: 'image/png' },
      { src: 'icon-512.png',  sizes: '512x512', type: 'image/png' },
      // maskable — Android adaptive icon (bez bieleho borderu)
      { src: 'icon-512-maskable.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' }
    ],
    // Skratky v kontextovom menu
    shortcuts: [
      { name: 'Produkty', url: '/products', icons: [{ src: 'icon-96.png', sizes: '96x96' }] },
      { name: 'Košík',    url: '/cart',     icons: [{ src: 'icon-96.png', sizes: '96x96' }] }
    ],
    // Screenshots pre App Store listing
    screenshots: [
      { src: 'screenshot-mobile.png', sizes: '390x844', type: 'image/png', form_factor: 'narrow' },
      { src: 'screenshot-desktop.png', sizes: '1280x720', type: 'image/png', form_factor: 'wide' }
    ]
  },

  // Workbox config
  workbox: {
    // Precache patterns
    globPatterns: ['**/*.{js,css,html,ico,png,svg,webp,woff2}'],
    globIgnores: ['**/node_modules/**'],

    // Max veľkosť súboru pre precache (default: 2MB)
    maximumFileSizeToCacheInBytes: 5 * 1024 * 1024, // 5MB

    // Skip waiting — nový SW aktivuje hneď
    skipWaiting: true,
    clientsClaim: true,

    // Runtime caching
    runtimeCaching: [
      {
        urlPattern: /^https:\/\/fonts\.googleapis\.com\/.*/i,
        handler: 'CacheFirst',
        options: { cacheName: 'google-fonts-cache', expiration: { maxAgeSeconds: 60*60*24*365 } }
      },
      {
        urlPattern: /^https:\/\/.*\.b-cdn\.net\/.*/i,
        handler: 'CacheFirst',
        options: { cacheName: 'bunny-cdn', expiration: { maxEntries: 200, maxAgeSeconds: 60*60*24*30 } }
      },
      {
        urlPattern: /\/api\/.*/i,
        handler: 'NetworkFirst',
        options: { cacheName: 'api-cache', networkTimeoutSeconds: 10 }
      }
    ],

    // Navigačný fallback (SPA routing)
    navigateFallback: '/index.html',
    navigateFallbackDenylist: [/^\/api/, /^\/admin/]
  },

  // Dev mode (zobrazí SW v development)
  devOptions: {
    enabled: false  // true = SW aj v dev (pomalšie)
  }
})
```
