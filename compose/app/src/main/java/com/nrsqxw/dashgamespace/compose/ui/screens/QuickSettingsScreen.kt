package com.nrsqxw.dashgamespace.compose.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp

@Composable
fun QuickSettingsScreen(
    onCommand: (String) -> Unit,
    onBack: () -> Unit,
) {
    val toggles = remember {
        mutableStateOf(
            linkedMapOf(
                "Auto brightness" to false,
                "Do not disturb" to false,
                "Wi-Fi" to true,
            ),
        )
    }
    Scaffold(
        topBar = {
            @OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
            TopAppBar(
                title = { Text("Quick Settings") },
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
            verticalArrangement = Arrangement.spacedBy(10.dp),
        ) {
            items(toggles.value.size) { index ->
                val key = toggles.value.keys.elementAt(index)
                androidx.compose.foundation.layout.Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(16.dp))
                        .padding(14.dp),
                    verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
                ) {
                    Text(key, modifier = Modifier.weight(1f))
                    Switch(
                        checked = toggles.value[key] == true,
                        onCheckedChange = { checked ->
                            val updated = LinkedHashMap(toggles.value)
                            updated[key] = checked
                            toggles.value = updated
                        },
                    )
                }
            }
            item {
                ActionRow("Brightness +") { onCommand("SET display.brightness 200") }
            }
            item {
                ActionRow("Media volume +") { onCommand("SET audio.volume 3 70") }
            }
            item {
                ActionRow("Screenshot") { onCommand("ACTION game.screenshot") }
            }
            item {
                ActionRow("Screen recording") { onCommand("ACTION game.record.screen") }
            }
        }
    }
}

@Composable
private fun ActionRow(label: String, onClick: () -> Unit) {
    Text(
        label,
        style = MaterialTheme.typography.titleMedium,
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .clickable(onClick = onClick)
            .padding(16.dp),
    )
}
