package com.nrsqxw.dashgamespace.compose.ui

import androidx.compose.animation.Crossfade
import androidx.activity.compose.BackHandler
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.view.InputDevice
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import com.nrsqxw.dashgamespace.compose.DashBridge
import com.nrsqxw.dashgamespace.compose.ui.screens.AppearanceScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.CaptureScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.CrosshairScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.GamesScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.HomeScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.MonitorScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.MusicScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.PermissionsScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.QuickSettingsScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.SearchScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.ToolsScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.TuneScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.WidgetsScreen
import org.json.JSONObject

private sealed interface Screen {
    data object Home : Screen
    data object Games : Screen
    data object Tune : Screen
    data object Widgets : Screen
    data object Tools : Screen
    data object Search : Screen
    data object Monitor : Screen
    data object Permissions : Screen
    data object Appearance : Screen
    data object QuickSettings : Screen
    data object Music : Screen
    data object Capture : Screen
    data object Crosshair : Screen
}

@Composable
fun GameSpaceApp() {
    val state = remember { mutableStateOf(GameSpaceUiState()) }
    val screen = remember { mutableStateOf<Screen>(Screen.Home) }
    val context = androidx.compose.ui.platform.LocalContext.current

    fun navigateBack() {
        screen.value = Screen.Home
    }

    BackHandler(enabled = screen.value != Screen.Home) {
        navigateBack()
    }

    LaunchedEffect(Unit) {
        val manager = context.getSystemService(InputManager::class.java)
        val gamepad = manager?.inputDeviceIds?.any { id ->
            manager.getInputDevice(id)?.sources?.and(InputDevice.SOURCE_GAMEPAD) ==
                InputDevice.SOURCE_GAMEPAD
        } == true
        state.value = state.value.copy(gamepadConnected = gamepad)
        DashBridge.send(context, "GET app.capabilities") { raw ->
            val keys = runCatching {
                val root = JSONObject(raw)
                val result = root.optString("result", "{}")
                JSONObject(result).keys().asSequence().toSet()
            }.getOrDefault(emptySet())
            state.value = state.value.copy(
                dashConnected = keys.isNotEmpty(),
                capabilities = keys,
                widgets = GameSpaceUiState.widgetsFor(keys),
            )
        }
        DashBridge.send(context, "GET app.list") { raw ->
            val games = runCatching {
                val root = JSONObject(raw)
                val result = root.optString("result", "[]")
                val array = org.json.JSONArray(result)
                (0 until array.length()).mapNotNull { index ->
                    val item = array.getJSONObject(index)
                    val pkg = item.optString("package")
                    val system = item.optBoolean("system")
                    val launchable = item.optBoolean("launchable")
                    if (pkg.isEmpty() || (system && !launchable)) null else GameItem(
                        packageName = pkg,
                        label = item.optString("label", pkg),
                        icon = runCatching {
                            val info = context.packageManager.getApplicationInfo(pkg, 0)
                            context.packageManager.getApplicationIcon(info).toImageBitmap()
                        }.getOrNull(),
                    )
                }
            }.getOrDefault(emptyList())
            state.value = state.value.copy(games = games)
        }
    }

    Crossfade(targetState = screen.value, label = "screen") { target ->
        when (target) {
            Screen.Home -> HomeScreen(
                state = state.value,
                onModeChange = { state.value = state.value.copy(mode = it) },
                onOpenGames = { screen.value = Screen.Games },
                onOpenTune = { screen.value = Screen.Tune },
                onOpenWidgets = { screen.value = Screen.Widgets },
                onOpenTools = { screen.value = Screen.Tools },
            )
            Screen.Games -> GamesScreen(
                state = state.value,
                onLaunch = { launchGame(context, it.packageName) },
                onBack = ::navigateBack,
            )
            Screen.Tune -> TuneScreen(
                state = state.value,
                onModeChange = {
                    state.value = state.value.copy(performanceMode = it)
                    val command = when (it) {
                        PerformanceMode.Powersave -> "SET perf 0"
                        PerformanceMode.Balanced -> "SET perf 1"
                        PerformanceMode.Performance -> "SET perf 2"
                    }
                    DashBridge.send(context, command) {}
                },
                onTouchBoostChange = {
                    state.value = state.value.copy(touchBoost = it)
                    DashBridge.send(context, if (it) "SET touch 3" else "SET touch 0") {}
                },
                onBypassChange = {
                    state.value = state.value.copy(bypassCharging = it)
                    DashBridge.send(context, "SET charging.bypass ${if (it) 1 else 0}") {}
                },
                onBack = ::navigateBack,
            )
            Screen.Widgets -> WidgetsScreen(
                state = state.value,
                    onWidgetClick = { widget ->
                        widget.command?.let { command ->
                            DashBridge.send(context, command) {}
                        }
                    },
                    onMove = { from, to ->
                        val current = state.value.widgets.toMutableList()
                        if (from in current.indices && to in current.indices) {
                            val item = current.removeAt(from)
                            current.add(to, item)
                            state.value = state.value.copy(widgets = current)
                        }
                    },
                onBack = ::navigateBack,
            )
            Screen.Tools -> ToolsScreen(
                onExport = {},
                onImport = { DashBridge.send(context, "GET game.confirm import") {} },
                onSearch = { screen.value = Screen.Search },
                onMonitor = { screen.value = Screen.Monitor },
                onPermissions = { screen.value = Screen.Permissions },
                onQuickSettings = { screen.value = Screen.QuickSettings },
                onAppearance = { screen.value = Screen.Appearance },
                onMusic = { screen.value = Screen.Music },
                onCapture = { screen.value = Screen.Capture },
                onCrosshair = { screen.value = Screen.Crosshair },
                onBack = ::navigateBack,
            )
            Screen.Search -> SearchScreen(
                gameNames = state.value.games.map { it.label },
                onOpenGame = { label ->
                    state.value.games.firstOrNull { it.label == label }?.let { game ->
                        launchGame(context, game.packageName)
                    }
                },
                onOpenTune = { screen.value = Screen.Tune },
                onOpenSettings = { screen.value = Screen.Tools },
                onBack = ::navigateBack,
            )
            Screen.Monitor -> MonitorScreen(
                state = state.value,
                onRefresh = { DashBridge.send(context, "GET health") {} },
                onBack = ::navigateBack,
            )
            Screen.Permissions -> PermissionsScreen(
                onRequestOverlay = { openOverlaySettings(context) },
                onBack = ::navigateBack,
            )
            Screen.Appearance -> AppearanceScreen(
                state = state.value.appearance,
                onChange = { state.value = state.value.copy(appearance = it) },
                onBack = ::navigateBack,
            )
            Screen.QuickSettings -> QuickSettingsScreen(
                onCommand = { DashBridge.send(context, it) {} },
                onBack = ::navigateBack,
            )
            Screen.Music -> MusicScreen(onBack = ::navigateBack)
            Screen.Capture -> CaptureScreen(
                onScreenshot = { DashBridge.send(context, "ACTION game.screenshot") {} },
                onToggleRecording = { DashBridge.send(context, "ACTION game.record.screen") {} },
                onBack = ::navigateBack,
            )
            Screen.Crosshair -> CrosshairScreen(onBack = ::navigateBack)
        }
    }

    if (state.value.gamepadConnected && !state.value.gamepadPromptShown) {
        AlertDialog(
            onDismissRequest = {
                state.value = state.value.copy(gamepadPromptShown = true)
            },
            title = { Text("Gamepad detected") },
            text = { Text("Switch to Gamepad mode for larger targets and D-Pad navigation?") },
            confirmButton = {
                Button(onClick = {
                    state.value = state.value.copy(
                        gamepadPromptShown = true,
                        mode = SpaceMode.Gamepad,
                    )
                }) { Text("Switch") }
            },
            dismissButton = {
                TextButton(onClick = {
                    state.value = state.value.copy(gamepadPromptShown = true)
                }) { Text("Stay") }
            },
        )
    }
}

private fun Drawable.toImageBitmap(): ImageBitmap? {
    if (this is BitmapDrawable) return bitmap.asImageBitmap()
    val width = intrinsicWidth.coerceAtLeast(1)
    val height = intrinsicHeight.coerceAtLeast(1)
    val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)
    setBounds(0, 0, width, height)
    draw(canvas)
    return bitmap.asImageBitmap()
}

private fun launchGame(context: Context, packageName: String) {
    val intent = context.packageManager.getLaunchIntentForPackage(packageName) ?: return
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    context.startActivity(intent)
}

private fun openOverlaySettings(context: Context) {
    val intent = Intent(
        Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
        Uri.parse("package:${context.packageName}"),
    )
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    context.startActivity(intent)
}
