package com.nrsqxw.dashgamespace.compose.ui

import androidx.compose.ui.graphics.ImageBitmap

enum class SpaceMode { Explore, Handheld, Gamepad }

enum class PerformanceMode { Powersave, Balanced, Performance }

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
    val command: String? = null,
)

enum class WidgetState { Ready, Active, PermissionRequired, Unsupported }

data class AppearanceState(
    val accent: String = "Cyan",
    val cardStyle: String = "Compact",
    val dockColor: String = "Accent",
    val edge: String = "Both",
    val autohide: Boolean = true,
)

data class GameSpaceUiState(
    val mode: SpaceMode = SpaceMode.Explore,
    val dashConnected: Boolean = false,
    val capabilities: Set<String> = emptySet(),
    val performanceMode: PerformanceMode = PerformanceMode.Balanced,
    val touchBoost: Boolean = false,
    val bypassCharging: Boolean = false,
    val bypassSupported: Boolean = false,
    val games: List<GameItem> = emptyList(),
    val appearance: AppearanceState = AppearanceState(),
    val gamepadConnected: Boolean = false,
    val gamepadPromptShown: Boolean = false,
    val widgets: List<WidgetItem> = widgetsFor(emptySet()),
) {
    companion object {
        private data class Definition(
            val name: String,
            val required: String,
            val command: String,
            val reason: String,
        )

        private val definitions = listOf(
            Definition("FPS", "fps", "GET app.fps.light", "FPS node not exposed"),
            Definition("CPU / GPU", "gpu", "GET health", "GPU telemetry unavailable"),
            Definition("Thermal", "thermal", "GET health", "Thermal node unavailable"),
            Definition("Brightness", "display", "SET display.brightness 180", "Display control unavailable"),
            Definition("Volume", "audio", "SET audio.volume 3 50", "Audio control unavailable"),
            Definition("Crosshair", "overlay", "ACTION game.request.overlay", "Overlay permission needed"),
            Definition("Live Monitor", "fps", "GET app.fps.light", "FPS node not exposed"),
        )

        fun widgetsFor(capabilities: Set<String>): List<WidgetItem> =
            definitions.map { definition ->
                val supported = capabilities.contains(definition.required)
                WidgetItem(
                    name = definition.name,
                    state = when {
                        supported && definition.required == "overlay" -> WidgetState.PermissionRequired
                        supported -> WidgetState.Active
                        else -> WidgetState.Unsupported
                    },
                    permission = if (supported) null else definition.reason,
                    command = definition.command,
                )
            }
    }
}
