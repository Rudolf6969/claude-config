# PWA Skill — Progressive Web App (Vite + React + PWABuilder)

## Stav v 2025: STÁLE RELEVANTNÉ A SILNÉ

PWA nie je zastarané. iOS Safari 16.4+ (2023) odblokoval push notifikácie.
**PWABuilder** (Microsoft, free) dokáže akékoľvek deploynuté PWA zbaliť do:
- Google Play Store (Android TWA — natívne Chrome rendrovanie)
- iOS App Store (WKWebView + Xcode projekt)
- Windows Store

**Workflow**: Build PWA → Deploy → pwabuilder.com → Store packages. Žiadny Capacitor, žiadne React Native.

---

## Krok 1: Vite + React → PWA

```bash
pnpm add -D vite-plugin-pwa
```

### vite.config.ts

```typescript
import { VitePWA } from 'vite-plugin-pwa'

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.ico', 'apple-touch-icon.png'],
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
          { src: 'icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' }
        ]
      },
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg,woff2}'],
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/.*\.b-cdn\.net\/.*/i,  // Bunny CDN
            handler: 'CacheFirst',
            options: {
              cacheName: 'cdn-images',
              expiration: { maxEntries: 200, maxAgeSeconds: 60 * 60 * 24 * 30 }
            }
          }
        ]
      }
    })
  ]
})
```

### Ikony (potrebuješ len jeden 512x512 PNG)

```bash
pnpm dlx pwa-asset-generator logo.png public/icons
# alebo online: realfavicongenerator.net
```

Potrebné veľkosti: 192×192, 512×512, 180×180 (apple-touch-icon)

---

## Krok 2: Deploy (Vercel)

```bash
bash ~/.claude/skills/deploy-to-vercel/resources/deploy.sh
```

PWA musí byť na HTTPS — Vercel to má automaticky.

---

## Krok 3: PWABuilder → App Store packages

**pwabuilder.com** (Microsoft, free, open source)

1. Zadaj URL svojho deploynutého PWA
2. PWABuilder analyzuje manifest + service worker (skóre 0-100)
3. Klikni "Package for Stores" → vyber platformu:
   - **Android** → TWA (Trusted Web Activity) = APK pre Google Play
   - **iOS** → WKWebView + Xcode projekt (potrebný Mac)
   - **Windows** → MSIX pre Windows Store
4. Download ZIP s app package

### Android (TWA) — najjednoduchší

- Trusted Web Activity = tvoj PWA beží v natívnom Chrome (nie webview)
- URL bar zmizne → vyzerá ako natívna app
- Push notifikácie bez browser promptu ak povolíš v PWABuilder options
- Signing: vyber "None" = Google Play podpíše sám (odporúčané)
- Google Play: $25 one-time fee

### iOS (WKWebView) — potrebuješ Mac alebo GitHub Actions

- WKWebView + Swift wrapper → natívna App Store app
- Service workers fungujú cez App-Bound Domains (iOS 14+)
- Automatická detekcia: `document.cookie` obsahuje `app-platform=iOS App Store`
- Bez Macu: GitHub Actions s Xcode Archive / Macincloud.com (remote Mac)
- Apple Developer: $99/rok
- ⚠️ Apple môže odmietnuť ak app "vyzerá len ako web" — pridaj real value

### Updates = automatické

Zmena v kóde → `git push` → Vercel deploy → **všetky store apky sa updatujú automaticky**.
App Store resubmission len ak meníš natívnu vrstvu (Xcode projekt).

---

## PWABuilder CLI (pre nové projekty)

```bash
npm install -g @pwabuilder/cli

pwa create my-app          # vytvorí PWA projekt
pwa create my-app -t basic # minimalistická verzia
pwa start                  # dev server
pwa build                  # produkčný build
```

Templates: `default` (Lit + Vite), `basic` (vanilla), `whisper` (+ AI/Transformers.js)

---

## Install prompt (vlastný UI)

```typescript
// hooks/usePWAInstall.ts
import { useEffect, useState } from 'react'

export function usePWAInstall() {
  const [prompt, setPrompt] = useState<BeforeInstallPromptEvent | null>(null)
  const [installed, setInstalled] = useState(false)

  useEffect(() => {
    const handler = (e: Event) => { e.preventDefault(); setPrompt(e as any) }
    const installed = () => setInstalled(true)
    window.addEventListener('beforeinstallprompt', handler)
    window.addEventListener('appinstalled', installed)
    return () => {
      window.removeEventListener('beforeinstallprompt', handler)
      window.removeEventListener('appinstalled', installed)
    }
  }, [])

  const install = async () => {
    if (!prompt) return
    prompt.prompt()
    const { outcome } = await prompt.userChoice
    if (outcome === 'accepted') setPrompt(null)
  }

  return { canInstall: !!prompt && !installed, install }
}
```

---

## Platform support 2025

| Feature | iOS Safari 16.4+ | Chrome/Android |
|---------|-----------------|----------------|
| Inštalácia na plochu | ✅ | ✅ |
| Offline mode | ✅ | ✅ |
| Push notifikácie | ✅ | ✅ |
| Service Workers | ✅ | ✅ |
| App Store (cez PWABuilder) | ✅ WKWebView | ✅ TWA |
| Background sync | ⚠️ limitované | ✅ |

---

## PWA vs alternatívy (2025)

| | PWA + PWABuilder | Capacitor | React Native |
|--|--|--|--|
| Jeden codebase | ✅ web + stores | ✅ | ✅ |
| Update bez Store review | ✅ | ✅ | ⚠️ (JS only) |
| Native APIs | ⚠️ web APIs only | ✅ plný prístup | ✅ plný prístup |
| App Store | ✅ cez PWABuilder | ✅ | ✅ |
| Náročnosť | 🟢 nízka | 🟡 stredná | 🔴 vysoká |

**Pre e-shop (Veiny Galaxy) → PWA + PWABuilder je ideálne.**

---

## Referencie
- `references/vite-pwa-options.md` — kompletné VitePWA + Workbox options
- `references/pwabuilder-android.md` — Android TWA options detail
- `references/pwabuilder-ios.md` — iOS limitations + Mac-free build options
