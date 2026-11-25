# Changelog

## 1.1.0 (Compose)

### Added

- Game profile rows show real launcher icons, app labels, package names and
  profile badges.
- Performance widgets are capability-aware and actionable, with precise
  unsupported reasons.
- Search, Monitor, Permissions, Appearance, Quick Settings, Music, Capture and
  Crosshair screens.
- Gamepad detection prompt, mode transitions and widget drag ordering.

## 1.0.2

### Fixed

- Game list now filters system packages and overlays, and the last row has
  enough bottom padding.
- Tune shows the active mode and clears error messages when leaving the page.
- Performance and Tools cards open the correct pages with working actions.
- Mode tabs switch content, and each home card has a distinct icon.

### Added

- Native Jetpack Compose / Material 3 module under `compose/` with OLED dark
  theme, bento home, edge-to-edge layout and D-Pad focus states.

## 1.0.1

### Changed

- Rebuilt with the same new release signing key as Dash Essential 1.23.20 so
  the signature-protected bridge is granted. Uninstall the old Game Space and
  Dash Essential builds before installing this set.

## 1.0.0

### Added

- Separate Flutter Game Space app with Dash Essential bridge client.
- Signature-protected ordered-broadcast bridge configuration and Android
  project scaffold.
- Expressive home, glass cards, navigation capsule and three display modes.
- Game library, Dash-compatible profile payloads and tune pages.
- Game bar, widget library, media/input tool state, settings, backup, search
  and gamepad screens.
- GitHub Actions workflow for tests, release APK, artifact upload and tag
  releases.
