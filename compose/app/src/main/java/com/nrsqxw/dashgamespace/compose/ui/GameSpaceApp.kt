package com.nrsqxw.dashgamespace.compose.ui

import androidx.activity.compose.BackHandler
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import com.nrsqxw.dashgamespace.compose.DashBridge
import com.nrsqxw.dashgamespace.compose.ui.screens.GamesScreen
import com.nrsqxw.dashgamespace.compose.ui.screens.HomeScreen
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
        DashBridge.send(context, "GET app.capabilities") { raw ->
            val keys = runCatching {
                val root = JSONObject(raw)
                val result = root.optString("result", "{}")
                JSONObject(result).keys().asSequence().toSet()
            }.getOrDefault(emptySet())
            state.value = state.value.copy(dashConnected = keys.isNotEmpty())
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

    when (screen.value) {
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
            onLaunch = { DashBridge.send(context, "ACTION game.launch ${it.packageName}") {} },
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
                if (widget.state == WidgetState.PermissionRequired) {
                    DashBridge.send(context, "ACTION game.request.overlay") {}
                }
            },
            onBack = ::navigateBack,
        )
        Screen.Tools -> ToolsScreen(
            onExport = {},
            onImport = { DashBridge.send(context, "GET game.confirm import") {} },
            onBack = ::navigateBack,
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
