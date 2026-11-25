package com.nrsqxw.dashgamespace.compose.ui.screens

import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.lazy.grid.itemsIndexed
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Layers
import com.nrsqxw.dashgamespace.compose.ui.GameSpaceUiState
import com.nrsqxw.dashgamespace.compose.ui.WidgetItem
import com.nrsqxw.dashgamespace.compose.ui.WidgetState

@Composable
fun WidgetsScreen(
    state: GameSpaceUiState,
    onWidgetClick: (WidgetItem) -> Unit,
    onMove: (Int, Int) -> Unit,
    onBack: () -> Unit,
) {
    Scaffold(
        topBar = {
            @OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
            TopAppBar(
                title = { Text("Widgets") },
                navigationIcon = {
                    Text(
                        "←",
                        modifier = Modifier
                            .padding(horizontal = 20.dp)
                            .clickable(onClick = onBack),
                    )
                },
            )
        },
    ) { padding ->
        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            modifier = Modifier
                .fillMaxSize()
                .padding(padding),
            contentPadding = PaddingValues(start = 20.dp, end = 20.dp, top = 8.dp, bottom = 32.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            itemsIndexed(state.widgets) { index, widget ->
                WidgetCard(
                    widget = widget,
                    onClick = { onWidgetClick(widget) },
                    onMove = { delta -> onMove(index, (index + delta).coerceIn(0, state.widgets.lastIndex)) },
                )
            }
        }
    }
}

@Composable
private fun WidgetCard(
    widget: WidgetItem,
    onClick: () -> Unit,
    onMove: (Int) -> Unit,
) {
    val dragY = remember { mutableFloatStateOf(0f) }
    val accent = when (widget.state) {
        WidgetState.Active -> MaterialTheme.colorScheme.primary
        WidgetState.PermissionRequired -> MaterialTheme.colorScheme.error
        WidgetState.Unsupported -> MaterialTheme.colorScheme.onSurfaceVariant
        WidgetState.Ready -> MaterialTheme.colorScheme.secondary
    }
    Column(
        modifier = Modifier
            .clip(RoundedCornerShape(16.dp))
            .border(1.dp, MaterialTheme.colorScheme.outline, RoundedCornerShape(16.dp))
            .clickable(onClick = onClick)
            .pointerInput(Unit) {
                detectDragGestures(
                    onDrag = { _, dragAmount -> dragY.floatValue += dragAmount.y },
                    onDragEnd = {
                        val steps = (dragY.floatValue / 130f).toInt()
                        dragY.floatValue = 0f
                        if (steps != 0) onMove(steps)
                    },
                )
            }
            .padding(16.dp),
    ) {
        Icon(
            imageVector = Icons.Outlined.Layers as ImageVector,
            contentDescription = null,
            tint = accent,
        )
        Text(widget.name, style = MaterialTheme.typography.titleMedium, modifier = Modifier.padding(top = 10.dp))
        Text(
            text = when (widget.state) {
                WidgetState.Active -> "Active"
                WidgetState.Ready -> "Ready"
                WidgetState.PermissionRequired ->
                    widget.permission?.let { "Permission Required · $it" } ?: "Permission Required"
                WidgetState.Unsupported ->
                    widget.permission?.let { "Unsupported · $it" } ?: "Unsupported"
            },
            style = MaterialTheme.typography.bodyMedium.copy(color = accent),
        )
    }
}
