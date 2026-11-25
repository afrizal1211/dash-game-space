package com.nrsqxw.dashgamespace.compose.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.FilterChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import com.nrsqxw.dashgamespace.compose.ui.AppearanceState

@Composable
fun AppearanceScreen(
    state: AppearanceState,
    onChange: (AppearanceState) -> Unit,
    onBack: () -> Unit,
) {
    Scaffold(
        topBar = {
            @OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
            TopAppBar(
                title = { Text("Appearance") },
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
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(horizontal = 20.dp),
            contentPadding = PaddingValues(bottom = 32.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            item {
                ChoiceRow("Accent", listOf("Cyan", "Mint"), state.accent) { selected ->
                    onChange(state.copy(accent = selected))
                }
            }
            item {
                ChoiceRow("Card style", listOf("Compact", "Expressive"), state.cardStyle) { selected ->
                    onChange(state.copy(cardStyle = selected))
                }
            }
            item {
                ChoiceRow("Dock colour", listOf("Accent", "White"), state.dockColor) { selected ->
                    onChange(state.copy(dockColor = selected))
                }
            }
            item {
                ChoiceRow("Edge", listOf("Both", "Left", "Right"), state.edge) { selected ->
                    onChange(state.copy(edge = selected))
                }
            }
            item {
                androidx.compose.foundation.layout.Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(16.dp))
                        .padding(vertical = 8.dp),
                    verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
                ) {
                    Text("Autohide dock", modifier = Modifier.weight(1f))
                    Switch(
                        checked = state.autohide,
                        onCheckedChange = { onChange(state.copy(autohide = it)) },
                    )
                }
            }
        }
    }
}

@Composable
private fun ChoiceRow(
    label: String,
    options: List<String>,
    current: String,
    onSelect: (String) -> Unit,
) {
    androidx.compose.foundation.layout.Column {
        Text(label, style = MaterialTheme.typography.titleMedium)
        androidx.compose.foundation.layout.Row(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            modifier = Modifier.padding(top = 8.dp),
        ) {
            options.forEach { option ->
                FilterChip(
                    selected = option == current,
                    onClick = { onSelect(option) },
                    label = { Text(option) },
                )
            }
        }
    }
}
