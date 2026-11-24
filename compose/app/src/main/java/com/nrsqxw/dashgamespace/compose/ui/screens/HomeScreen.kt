package com.nrsqxw.dashgamespace.compose.ui.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.itemsIndexed
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Apps
import androidx.compose.material.icons.outlined.Build
import androidx.compose.material.icons.outlined.Layers
import androidx.compose.material.icons.outlined.Tune
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.nrsqxw.dashgamespace.compose.ui.GameSpaceUiState
import com.nrsqxw.dashgamespace.compose.ui.SpaceMode
import com.nrsqxw.dashgamespace.compose.ui.WidgetState
import com.nrsqxw.dashgamespace.compose.ui.components.BentoCard
import com.nrsqxw.dashgamespace.compose.ui.components.ModeSwitcher
import com.nrsqxw.dashgamespace.compose.ui.components.StatusChip
import com.nrsqxw.dashgamespace.compose.ui.components.TelemetryText

@Composable
fun HomeScreen(
    state: GameSpaceUiState,
    onModeChange: (com.nrsqxw.dashgamespace.compose.ui.SpaceMode) -> Unit,
    onOpenGames: () -> Unit,
    onOpenTune: () -> Unit,
    onOpenWidgets: () -> Unit,
    onOpenTools: () -> Unit,
) {
    val largeTargets = state.mode != com.nrsqxw.dashgamespace.compose.ui.SpaceMode.Explore
    Column(modifier = Modifier.fillMaxSize()) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp, vertical = 16.dp),
            verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = "GAME SPACE",
                    style = MaterialTheme.typography.labelLarge.copy(
                        color = MaterialTheme.colorScheme.primary,
                    ),
                )
                Text(
                    text = "Performance, simplified.",
                    style = MaterialTheme.typography.headlineLarge,
                )
            }
            StatusChip(connected = state.dashConnected)
        }

        ModeSwitcher(
            selected = state.mode,
            largeTargets = largeTargets,
            onSelect = onModeChange,
        )

        Spacer(modifier = Modifier.height(18.dp))

        Row(
            modifier = Modifier.padding(horizontal = 20.dp),
            horizontalArrangement = Arrangement.spacedBy(24.dp),
        ) {
            TelemetryText("60", "FPS")
            TelemetryText("42%", "CPU")
            TelemetryText("38°", "TEMP")
            TelemetryText("87%", "BAT")
        }

        Spacer(modifier = Modifier.height(18.dp))

        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            modifier = Modifier.fillMaxSize(),
            contentPadding = PaddingValues(
                start = 20.dp,
                end = 20.dp,
                top = 4.dp,
                bottom = 32.dp,
            ),
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            item(span = { androidx.compose.foundation.lazy.grid.GridItemSpan(2) }) {
                BentoCard(
                    title = "My Games",
                    subtitle = "${state.games.size} games · ${state.performanceMode.name} active",
                    icon = Icons.Outlined.Apps,
                    active = true,
                    showFocusRing = largeTargets,
                    onClick = onOpenGames,
                )
            }
            itemsIndexed(
                listOf(
                    Triple("Tune", "${state.performanceMode.name} · ${if (state.touchBoost) "Touch boost on" else "Touch boost off"}", Icons.Outlined.Tune),
                    Triple("Overlay / Widgets", "${state.widgets.count { it.state == WidgetState.Active }} HUD active", Icons.Outlined.Layers),
                    Triple("Tools & Backup", "Appearance · permissions · data", Icons.Outlined.Build),
                ),
            ) { index, entry ->
                BentoCard(
                    title = entry.first,
                    subtitle = entry.second,
                    icon = entry.third,
                    showFocusRing = largeTargets,
                    onClick = when (index) {
                        0 -> onOpenTune
                        1 -> onOpenWidgets
                        else -> onOpenTools
                    },
                )
            }
        }
    }
}
