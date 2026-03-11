# PWABuilder — Android TWA Options

## Čo je TWA (Trusted Web Activity)

Nie je to webview! TWA spúšťa tvoj PWA priamo v Chrome — rovnaký engine, rovnaké výsledky ako browser.
URL bar sa skryje → vyzerá ako natívna app. Vyžaduje Chrome 72+.

## Customization options v PWABuilder

- **Package ID** — `com.veinygalaxy.app` (unikátny Android identifikátor)
- **App name** — z `manifest.name`
- **Launcher name** — z `manifest.short_name` (max 12 znakov)
- **App version** — `1.0.0` (zobrazuje sa useróm)
- **App version code** — integer (interný, napr. `1`)
- **Host / Start URL** — z manifestu, prepopulované
- **Status bar color** — z `manifest.theme_color`
- **Nav bar color** — z `manifest.theme_color`
- **Splash screen color** — z `manifest.background_color`
- **Splash screen fade** — default 300ms
- **Icon URL** — 512×512 PNG
- **Maskable icon URL** — pre Android adaptive ikony (rounded corners)
- **Monochrome icon URL** — pre high contrast / dark mode
- **Fallback behavior** — Chrome Custom Tabs (odporúčané)
- **Display mode** — Standalone alebo Fullscreen
- **Notifications** — Android Notification Delegation (push bez browser promptu)
- **Signing** — None (Google Play podpíše) / New / Mine (existujúci keystore)

## Signing odporúčanie

Pre prvý upload: **None** → Google Play podpíše sám (Play App Signing).
Pre update existujúcej app: **Mine** → nahraj pôvodný .keystore súbor.

## Publish do Google Play

1. Download ZIP z PWABuilder (obsahuje APK + upload key)
2. Google Play Console: $25 one-time fee
3. Create app → Production → Upload APK/AAB
4. **Digital Asset Links** — ak chceš odstrániť URL bar, musíš deployovať:
   `/.well-known/assetlinks.json` na tvoj server s fingerprint zo signing key

## AssetLinks pre odstránenie URL baru

Bez AssetLinks sa zobrazí URL bar v app. Pre čistý standalone look:

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.veinygalaxy.app",
    "sha256_cert_fingerprints": ["YOUR_SIGNING_KEY_SHA256"]
  }
}]
```

Fingerprint nájdeš v Google Play Console → Setup → App integrity.
