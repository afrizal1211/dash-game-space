package com.nrsqxw.dashgamespace.compose.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.FilterChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp

private enum class SearchFilter { Games, Tune, Settings }

@Composable
fun SearchScreen(
    gameNames: List<String>,
    onOpenGame: (String) -> Unit,
    onOpenTune: () -> Unit,
    onOpenSettings: () -> Unit,
    onBack: () -> Unit,
) {
    val query = remember { mutableStateOf("") }
    val filter = remember { mutableStateOf(SearchFilter.Games) }

    Scaffold(
        topBar = {
            @OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
            TopAppBar(
                title = { Text("Search") },
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
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(horizontal = 20.dp),
        ) {
            OutlinedTextField(
                value = query.value,
                onValueChange = { query.value = it },
                label = { Text("Search apps, controls, settings") },
                modifier = Modifier.fillMaxWidth(),
            )
            androidx.compose.foundation.layout.Row(
                modifier = Modifier.padding(vertical = 12.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                SearchFilter.entries.forEach { item ->
                    FilterChip(
                        selected = filter.value == item,
                        onClick = { filter.value = item },
                        label = { Text(item.name) },
                    )
                }
            }
            val needle = query.value.trim()
            val results = when (filter.value) {
                SearchFilter.Games -> gameNames.filter { it.contains(needle, ignoreCase = true) }
                SearchFilter.Tune -> listOf("Performance", "Balanced", "Touch boost")
                    .filter { it.contains(needle, ignoreCase = true) }
                SearchFilter.Settings -> listOf("Appearance", "Permissions", "Backup")
                    .filter { it.contains(needle, ignoreCase = true) }
            }
            LazyColumn(
                contentPadding = PaddingValues(bottom = 32.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                items(results) { result ->
                    Text(
                        result,
                        style = MaterialTheme.typography.titleMedium,
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .clickable {
                                when (filter.value) {
                                    SearchFilter.Games -> onOpenGame(result)
                                    SearchFilter.Tune -> onOpenTune()
                                    SearchFilter.Settings -> onOpenSettings()
                                }
                            }
                            .padding(14.dp),
                    )
                }
            }
        }
    }
}
