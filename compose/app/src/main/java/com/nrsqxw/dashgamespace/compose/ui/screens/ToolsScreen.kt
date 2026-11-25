package com.nrsqxw.dashgamespace.compose.ui.screens

import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp

@Composable
fun ToolsScreen(
    onExport: () -> Unit,
    onImport: () -> Unit,
    onSearch: () -> Unit,
    onMonitor: () -> Unit,
    onPermissions: () -> Unit,
    onQuickSettings: () -> Unit,
    onAppearance: () -> Unit,
    onBack: () -> Unit,
) {
    val items = listOf(
        "Quick Settings" to "Brightness, volume, DND, capture",
        "Search" to "Find apps, controls and settings",
        "Monitor" to "Live telemetry",
        "Permissions" to "Overlay and privileged access",
        "Appearance" to "Theme, density, navigation",
        "Language" to "English",
        "Data" to "Games, profiles, widgets",
        "Export Game Space backup" to "Save local JSON",
        "Import Dash backup" to "Requires Dash confirmation",
    )
    Scaffold(
        topBar = {
            @OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
            TopAppBar(
                title = { Text("Tools & Backup") },
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
                .padding(padding),
            contentPadding = PaddingValues(start = 20.dp, end = 20.dp, top = 8.dp, bottom = 32.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp),
        ) {
            items(items.size) { index ->
                val (title, subtitle) = items[index]
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(16.dp))
                        .border(1.dp, MaterialTheme.colorScheme.outline, RoundedCornerShape(16.dp))
                        .clickable(
                            onClick = when (index) {
                                0 -> onQuickSettings
                                1 -> onSearch
                                2 -> onMonitor
                                3 -> onPermissions
                                4 -> onAppearance
                                7 -> onExport
                                8 -> onImport
                                else -> ({})
                            },
                        )
                        .padding(16.dp),
                ) {
                    androidx.compose.foundation.layout.Column {
                        Text(title, style = MaterialTheme.typography.titleMedium)
                        Text(subtitle, style = MaterialTheme.typography.bodyMedium)
                    }
                }
            }
        }
    }
}
