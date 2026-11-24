# Dash Game Space

Game Space with Dash Essential integration.

A separate Flutter companion app that follows the reference Game Space look and
uses Dash Essential as its protected hardware backend. It never talks to the
root daemon directly.

## Features

- Expressive glass-card home with Explore / Handheld / Gamepad modes.
- Game library, per-game profiles and Dash-backed tune pages.
- Game bar and twelve widget groups.
- Music, capture and input-tool scaffolding.
- Settings, backup/search/gamepad screens.
- Local-only basic mode when Dash Essential is unavailable.

## Requirements

- Android 12 (API 31) or newer.
- Dash Essential 1.23.18-dash or newer installed.
- Both apps signed with the same release key. The bridge uses a `signature`
  permission and refuses callers with a different signing identity.

## How to use

1. Install Dash Essential first, then install Dash Game Space.
2. Open Dash Game Space. It probes the Dash bridge on startup.
3. If Dash is unavailable, the app shows a labelled local-only basic mode.
4. Tap **Game profile** to add or open a game, then apply a profile.
5. Tap **Tune** for Dash-backed performance, touch and charging controls.
6. Tap **Performance** for the widget panel and game bar.
7. **Settings** holds appearance, permissions, data and backup actions.

Profile changes are applied through Dash Essential and follow the same
per-game profile rules as Dash's own controls.

## Build

```sh
flutter pub get
flutter test
flutter build apk --release
```

CI generates the Android scaffold with `flutter create`, copies
`config/AndroidManifest.xml` and `config/BridgeChannel.kt`, then runs tests and
builds the release APK.

## Author

[afrizal1211](https://github.com/afrizal1211)
