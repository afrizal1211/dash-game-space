package com.nrsqxw.dashgamespace.compose.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun CrosshairScreen(onBack: () -> Unit) {
    val size = remember { mutableFloatStateOf(24f) }
    val opacity = remember { mutableFloatStateOf(0.8f) }
    Scaffold(
        topBar = {
            @OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
            TopAppBar(
                title = { Text("Crosshair") },
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
            verticalArrangement = Arrangement.spacedBy(18.dp),
        ) {
            item {
                Text("Size: ${size.floatValue.toInt()} dp", style = MaterialTheme.typography.titleMedium)
                Slider(
                    value = size.floatValue,
                    onValueChange = { size.floatValue = it },
                    valueRange = 12f..64f,
                )
            }
            item {
                Text("Opacity: ${(opacity.floatValue * 100).toInt()}%", style = MaterialTheme.typography.titleMedium)
                Slider(
                    value = opacity.floatValue,
                    onValueChange = { opacity.floatValue = it },
                    valueRange = 0.2f..1f,
                )
            }
        }
    }
}
