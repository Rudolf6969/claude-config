# PWA Skill — Progressive Web App (Vite + React)

## Stav v 2025: STÁLE RELEVANTNÉ

PWA nie je zastarané. Je aktívne používané v produkcii:
- **Twitter/X, Pinterest, Starbucks, Uber, Spotify** — všetci majú PWA
- iOS Safari 16.4+ (2023) konečne pridalo push notifikácie — hlavný blocker bol odblokovaný
- Chrome, Edge, Firefox — plná podpora
- Google Play Store akceptuje PWA cez TWA (Trusted Web Activity)

**Výhoda vs natívna app**: žiadny App Store approval, okamžitý update, jeden codebase.
**Výhoda vs Capacitor**: žiadny build pipeline, žiadne certifikáty, 0 overhead.

---

## Stack pre React + Vite

```bash
pnpm add -D vite-plugin-pwa workbox-window
```

### vite.config.ts

```typescript
import { VitePWA } from 'vite-plugin-pwa'

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.ico', 'apple-touch-icon.png', 'icon-*.png'],
      manifest: {
        name: 'Veiny Galaxy',
        short_name: 'VG Shop',
        description: 'Premium fitness e-shop',
        theme_color: '#0A0805',
        background_color: '#0A0805',
        display: 'standalone',
        orientation: 'portrait',
        start_url: '/',
        icons: [
          { src: 'icon-192.png', sizes: '192x192', type: 'image/png' },
          { src: 'icon-512.png', sizes: '512x512', type: 'image/png' },
          { src: 'icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'any maskable' }
        ]
      },
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg,woff2}'],
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/.*\.b-cdn\.net\/.*/i,  // Bunny CDN images
            handler: 'CacheFirst',
            options: {
              cacheName: 'cdn-images',
              expiration: { maxEntries: 100, maxAgeSeconds: 60 * 60 * 24 * 30 }
            }
          }
        ]
      }
    })
  ]
})
```

---

## Čo PWA robí

| Feature | iOS Safari 16.4+ | Chrome/Android |
|---------|-----------------|----------------|
| Inštalácia na plochu | ✅ | ✅ |
| Offline mode | ✅ | ✅ |
| Push notifikácie | ✅ (16.4+) | ✅ |
| Splash screen | ✅ | ✅ |
| Fullscreen / standalone | ✅ | ✅ |
| App Store (TWA) | ❌ (App Store) | ✅ Google Play |
| Background sync | ⚠️ limitované | ✅ |

---

## Ikony — rýchla generácia

```bash
# Potrebuješ len jeden 512x512 PNG, zvyšok vygeneruje:
pnpm dlx pwa-asset-generator logo.png public/icons --manifest public/manifest.json
```

Alebo online: **realfavicongenerator.net** → generuje všetky veľkosti.

---

## Install prompt (vlastný UI)

```typescript
// hook: usePWAInstall.ts
import { useEffect, useState } from 'react'

export function usePWAInstall() {
  const [prompt, setPrompt] = useState<BeforeInstallPromptEvent | null>(null)

  useEffect(() => {
    const handler = (e: Event) => {
      e.preventDefault()
      setPrompt(e as BeforeInstallPromptEvent)
    }
    window.addEventListener('beforeinstallprompt', handler)
    return () => window.removeEventListener('beforeinstallprompt', handler)
  }, [])

  const install = async () => {
    if (!prompt) return
    prompt.prompt()
    const { outcome } = await prompt.userChoice
    if (outcome === 'accepted') setPrompt(null)
  }

  return { canInstall: !!prompt, install }
}
```

---

## PWA vs alternatívy (2025 verdict)

| Prístup | Kedy použiť |
|---------|-------------|
| **PWA** | Web app chceš sprístupniť "ako appku" — rýchle, free, cross-platform |
| **Capacitor** | Potrebuješ App Store listing, native APIs (kamera, biometria, BLE) |
| **React Native** | Úplne nový projekt, max native performance, team má RN skúsenosti |

**Pre Veiny Galaxy e-shop → PWA je správna voľba.**
- Žiadny App Store → žiadne 30% Apple cut
- Fungiuje na iOS aj Android
- Deploy = git push, nie App Store review

---

## Rýchly start pre vg-shadcn

```bash
# 1. Inštalácia
pnpm add -D vite-plugin-pwa

# 2. Ikony do public/
# icon-192.png + icon-512.png + apple-touch-icon.png (180x180)

# 3. vite.config.ts — pridaj VitePWA() plugin (pozri hore)

# 4. Build
pnpm build

# 5. Testovanie (Lighthouse → PWA audit)
pnpm dlx serve dist
# Chrome DevTools → Application → Manifest + Service Workers
```

---

## Offline stratégie (Workbox)

- **CacheFirst** — statické assets, CDN obrázky (dlhá platnosť)
- **NetworkFirst** — API volania, dynamický obsah
- **StaleWhileRevalidate** — semi-dynamické stránky (produktový listing)

---

## Referencie
- `references/vite-pwa-options.md` — kompletné VitePWA options
- `references/workbox-strategies.md` — Workbox caching stratégie
