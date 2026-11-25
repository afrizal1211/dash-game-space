package com.nrsqxw.dashgamespace.compose.ui.screens

import android.content.pm.PackageManager
import android.media.MediaPlayer
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import java.io.File

@Composable
fun MusicScreen(onBack: () -> Unit) {
    val context = LocalContext.current
    val granted = ContextCompat.checkSelfPermission(
        context,
        android.Manifest.permission.READ_MEDIA_AUDIO,
    ) == PackageManager.PERMISSION_GRANTED
    val tracks = remember(granted) {
        if (!granted) {
            emptyList()
        } else {
            val dir = File(android.os.Environment.getExternalStorageDirectory(), "Music")
            (dir.listFiles { file ->
                file.extension.lowercase() in setOf("mp3", "m4a", "ogg", "wav")
            } ?: emptyArray()).map { it.absolutePath }.sorted()
        }
    }
    val current = remember { mutableStateOf<String?>(null) }
    val player = remember { mutableStateOf<MediaPlayer?>(null) }

    DisposableEffect(Unit) {
        onDispose {
            player.value?.release()
            player.value = null
        }
    }

    fun play(path: String) {
        player.value?.release()
        val mediaPlayer = MediaPlayer.create(context, android.net.Uri.parse(path))
        current.value = path
        player.value = mediaPlayer
        mediaPlayer?.start()
    }

    Scaffold(
        topBar = {
            @OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
            TopAppBar(
                title = { Text("Music") },
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
            item {
                Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    Button(onClick = { player.value?.start() }) { Text("Play") }
                    Button(onClick = { player.value?.pause() }) { Text("Pause") }
                    Button(onClick = {
                        player.value?.release()
                        player.value = null
                        current.value = null
                    }) { Text("Stop") }
                }
            }
            if (!granted) {
                item { Text("Read media audio permission required to list local tracks.") }
            }
            items(tracks) { path ->
                Text(
                    File(path).name,
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .clickable { play(path) }
                        .padding(14.dp),
                )
            }
        }
    }
}
