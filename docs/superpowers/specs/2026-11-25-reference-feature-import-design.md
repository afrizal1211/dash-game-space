# Game Space — reference feature import design

Date: 2026-11-25
Status: scope approved ("Semua bertahap"); design pending approval.

## Intent

Import the user-facing features of the reference Game Space app
(`com.zkmnext.gamespace`, read from `app-release.apk`) into this repository's
Compose / Material 3 module. No reference source code is copied — only feature
behavior and UX patterns observed from its changelog, string resources and
manifest.

## Evidence already gathered

- Reference assets: `CHANGELOG_V8.md`, `language_en.xml`, 78 manifest components.
- Missing feature clusters: Quick Settings, Music + floating dot, screen
  recording/screenshot, search, Monitor, Permissions, Appearance, Optimize
  actions, gamepad prompt/transitions, crosshair controls, widget ordering.
- Current repo: Flutter app released as `v1.0.2`; Compose app released as
  `v1.0.0-compose`. Both use the same signing key and Dash bridge.

## Goals

- Add the missing feature clusters to the Compose module first.
- Keep every new control either Dash-bridge backed or an explicit local-only
  feature. No fake values, no dead taps.
- Preserve the OLED/Material 3 visual system already implemented.
- Keep all lists padded for navigation bars and all mode tabs content-aware.

## Non-goals

- Copying reference APK code, assets, or package identity.
- Vendor-specific Xiaomi internals that require hidden APIs.
- Releasing a new version until the owner asks after verification.

## Approaches

1. **Compose-first staged import (chosen).** Add feature screens and state in
   `compose/`, wire them through `GameSpaceApp`, use DashBridge for hardware
   actions, and use Android platform APIs for media/projection. Cost: Flutter
   app stays behind until a later port.
2. Mirror every feature into both Flutter and Compose at once. Rejected:
   doubles work and risks divergent behavior.
3. Only add UI placeholders. Rejected: the owner asked for functional import.

## Feature clusters and behavior

1. Quick Settings: brightness, auto brightness, media volume, DND, Wi‑Fi,
   screenshot, screen recording. Privileged actions go through DashBridge;
   Android settings intents are the fallback with a visible label.
2. Music: local playlist, play/pause/next/prev, media notification, draggable
   floating dot. Implement with Media3 + a foreground service. Permission and
   storage access are explicit.
3. Capture: screenshot and screen recording via MediaProjection with consent.
   State shown in Quick Settings and Monitor.
4. Search: filter Games / Tune / Settings destinations from one search field.
5. Game profile tab: each game row shows the real launcher icon and app label
   from `PackageManager`, plus package name and profile badge. Icons are
   loaded asynchronously and cached; missing icons fall back to a neutral
   vector. This replaces the current text-only rows.
6. Monitor: FPS, CPU/GPU, RAM, temperature, battery from `GET app.fps.light`
   and `GET health`; unavailable values labelled, never zeroed.
7. Permissions: overlay, usage access, DND, Shizuku/root status with reasons.
8. Appearance: accent, card style, dock colour, edge, autohide; persisted in
   Compose DataStore.
9. Optimize: RAM cleanup, DND, heads-up, refresh rate, performance, with
   explicit "applied/unsupported" state from DashBridge.
10. Gamepad: controller detection prompt, button legend, larger focus targets.
11. Widgets: draggable ordering and crosshair size/opacity/edge controls.

### Performance tab must be fully usable

The owner additionally reported that the Performance tab is not fully usable.
Its availability must be derived from real `GET app.capabilities` keys, never
hardcoded to `unavailable`. Every card must have one of three honest states:
`Ready`, `Active`, or `Permission Required` with a clickable action. Cards
whose hardware control is not present in Dash must request the correct bridge
command or show a precise reason. This is part of cluster 1 and 8, not a
cosmetic follow-up.

## Constraints

- Gradle 8.9, AGP 8.7.3, Kotlin 2.0.21, Compose BOM 2024.11.00.
- compileSdk/targetSdk 35, minSdk 31.
- Same signing key as Dash Essential via existing GitHub secrets.
- CI must pass `compose.yml` before any release.

## Delivery order

1. Search + Monitor + Permissions + Appearance.
2. Quick Settings + Optimize.
3. Music + floating dot.
4. Capture + screenshot.
5. Gamepad prompt/transitions + widget ordering + crosshair controls.
6. Final verification and owner-approved release.

## What remains to the builder

- Exact motion durations and icon choices are builder decisions within the
  established Material 3 token system.
- Device-only behavior (actual MediaProjection, overlay permission grant)
  cannot be verified in CI; report it as device validation pending.
