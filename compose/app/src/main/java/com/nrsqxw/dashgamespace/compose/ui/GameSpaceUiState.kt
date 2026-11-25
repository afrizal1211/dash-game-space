package com.nrsqxw.dashgamespace.compose.ui

enum class SpaceMode { Explore, Handheld, Gamepad }

enum class PerformanceMode { Powersave, Balanced, Performance }

import androidx.compose.ui.graphics.ImageBitmap

data class GameItem(
    val packageName: String,
    val label: String,
    val profile: String = "Balanced",
    val icon: ImageBitmap? = null,
)

data class WidgetItem(
    val name: String,
    val state: WidgetState,
    val permission: String? = null,
)

enum class WidgetState { Ready, Active, PermissionRequired, Unsupported }

data class GameSpaceUiState(
    val mode: SpaceMode = SpaceMode.Explore,
    val dashConnected: Boolean = false,
    val performanceMode: PerformanceMode = PerformanceMode.Balanced,
    val touchBoost: Boolean = false,
    val bypassCharging: Boolean = false,
    val bypassSupported: Boolean = false,
    val games: List<GameItem> = emptyList(),
    val widgets: List<WidgetItem> = defaultWidgets(),
) {
    companion object {
        fun defaultWidgets(): List<WidgetItem> = listOf(
            WidgetItem("FPS", WidgetState.Ready),
            WidgetItem("CPU / GPU", WidgetState.Ready),
            WidgetItem("Thermal", WidgetState.Ready),
            WidgetItem("Brightness", WidgetState.Ready),
            WidgetItem("Volume", WidgetState.Ready),
            WidgetItem("Crosshair", WidgetState.PermissionRequired, "Overlay"),
            WidgetItem("Live Monitor", WidgetState.Ready),
        )
    }
}
