# Reference Feature Import Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Import the reference Game Space features into the Compose module, starting with a fully usable Game profile and Performance tab, then Search, Monitor, Permissions and Appearance.

**Architecture:** Compose UI state lives in `GameSpaceUiState`; screens call DashBridge for hardware actions and Android APIs for icons/permissions. Availability is derived from real `GET app.capabilities` keys. No reference APK code is copied.

**Tech Stack:** Kotlin, Jetpack Compose Material 3, Gradle 8.9, Kotlin 2.0.21.

**Spec:** `docs/superpowers/specs/2026-11-25-reference-feature-import-design.md`

## Global Constraints

- Compose only: `compose/` module. Flutter app stays as released.
- minSdk 31, targetSdk 35, compileSdk 35.
- Same signing key via existing GitHub secrets.
- CI `compose.yml` must pass before release.
- No device tests locally; CI build is the gate.

## Review Focus

- Game profile rows must show real icons and labels, never blank fallback for installed apps.
- Performance cards must be usable or show a precise reason; no blanket `unavailable`.
- Capabilities must be parsed from Dash's real JSON object.
- Lists need bottom padding for navigation bar.
- Permission states must be explicit, not silent failures.

---

### Task 1: Game profile icons and labels

**Files:**
- Modify: `compose/app/src/main/java/com/nrsqxw/dashgamespace/compose/ui/screens/GamesScreen.kt`
- Modify: `compose/app/src/main/java/com/nrsqxw/dashgamespace/compose/ui/GameSpaceApp.kt`
- Test: CI Compose build

- [ ] **Step 1: Load app icons via PackageManager in `GameSpaceApp`**

For each `GET app.list` entry, call `packageManager.getApplicationInfo` and
`getApplicationIcon`, convert drawable to `ImageBitmap`, and store in
`GameItem.icon`. Fall back to the built-in vector only if PackageManager fails.

- [ ] **Step 2: Render icon, label, package, and profile badge in `GamesScreen`**

Replace the generic `Icons.Outlined.Apps` row with `Image(painter = icon.asPainter())`,
label as primary text, package as secondary, and profile badge.

- [ ] **Step 3: Build and commit**

Run CI Compose build. Commit with `feat(compose): show real app icons in game list`.

---

### Task 2: Performance tab fully usable

**Files:**
- Modify: `compose/app/src/main/java/com/nrsqxw/dashgamespace/compose/ui/GameSpaceUiState.kt`
- Modify: `compose/app/src/main/java/com/nrsqxw/dashgamespace/compose/ui/GameSpaceApp.kt`
- Modify: `compose/app/src/main/java/com/nrsqxw/dashgamespace/compose/ui/screens/WidgetsScreen.kt`

- [ ] **Step 1: Parse capabilities object into a typed set**

`GET app.capabilities` returns a JSON object. Store keys as `Set<String>` and
derive `WidgetState` from exact keys.

- [ ] **Step 2: Map every Performance card to a bridge command**

No card is hardcoded `unavailable`. Each card is `Active`, `Ready`, or
`Permission Required` with a click action.

- [ ] **Step 3: Build and commit**

Commit with `feat(compose): make performance widgets actionable`.

---

### Task 3: Search, Monitor, Permissions

**Files:**
- Create: `compose/.../ui/screens/SearchScreen.kt`
- Create: `compose/.../ui/screens/MonitorScreen.kt`
- Create: `compose/.../ui/screens/PermissionsScreen.kt`
- Modify: `compose/.../ui/GameSpaceApp.kt`

- [ ] **Step 1: Add Search screen with Games/Tune/Settings filters**
- [ ] **Step 2: Add Monitor screen with FPS/RAM/temp/battery from bridge**
- [ ] **Step 3: Add Permissions screen with overlay/usage/DND status and reasons**
- [ ] **Step 4: Wire navigation and commit**

---

### Task 4: Appearance and Quick Settings

**Files:**
- Create: `compose/.../ui/screens/AppearanceScreen.kt`
- Create: `compose/.../ui/screens/QuickSettingsScreen.kt`
- Modify: `compose/.../ui/GameSpaceApp.kt`

- [ ] **Step 1: Persist accent, card style, dock colour, edge and autohide**
- [ ] **Step 2: Add Quick Settings hub with bridge-backed and Android-intent actions**
- [ ] **Step 3: Wire navigation and commit**

---

### Task 5: Final verification

- [ ] Run `compose.yml`, confirm build and artifact.
- [ ] Report device-only items as pending.
