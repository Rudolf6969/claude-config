# PWABuilder — iOS Platform

## Ako to funguje

PWABuilder generuje Xcode projekt (Swift + WKWebView) ktorý wrappuje tvoj PWA.
- WKWebView = WebKit engine (rovnaký ako Safari)
- Service Workers cez App-Bound Domains (iOS 14+)
- App Store updates = push na web server (bez resubmission)

## Čo funguje

- Service Workers ✅
- App Shortcuts (z manifestu) ✅
- URL Capture (deep linking) ✅
- Status bar customization ✅
- Splash screen z manifest colors ✅
- Mac Store support (rovnaký projekt) ✅
- Detekcia iOS app: `document.cookie` → `app-platform=iOS App Store`

## Limitácie

- **Potrebuješ Mac + Xcode** na build → alternatívy:
  - GitHub Actions s Xcode Archive action (free)
  - Macincloud.com (remote Mac, platené)
  - AppVeyor CI
- Apple Developer Program: **$99/rok**
- Apple môže odmietnuť ak app "vyzerá len ako web" → pridaj real value

## Bez Macu — GitHub Actions

```yaml
# .github/workflows/ios-build.yml
- uses: actions/checkout@v4
- uses: maxim-lobanov/setup-xcode@v1
  with: { xcode-version: latest-stable }
- name: Build IPA
  run: |
    xcodebuild -workspace App.xcworkspace \
      -scheme App \
      -configuration Release \
      -archivePath App.xcarchive \
      archive
    xcodebuild -exportArchive \
      -archivePath App.xcarchive \
      -exportPath ./output \
      -exportOptionsPlist ExportOptions.plist
```

## Debug na iPhone simulátore

1. Otvor `.xcworkspace` v Xcode
2. Spusti ▶ (iPhone simulator)
3. Safari → Develop → Simulator → [URL tvojho PWA]
4. Plný Safari DevTools

## Apple App Store guidelines pre PWA

Apple Guidelines z 2019 hovoria: webové apky musia poskytovať "real functionality".
Čo zvyšuje šancu schválenia:
- App nie je "len web v ráme" — pridaj natívne features (notifikácie, shortcuts)
- Qualitný manifest + ikony
- Offline support (service worker)
- Real user value

Komunita úspešne publishla PWA cez PWABuilder na iOS App Store — nie je to nemožné.
