package com.nrsqxw.dashgamespace.compose

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.enableEdgeToEdge
import androidx.activity.compose.setContent
import com.nrsqxw.dashgamespace.compose.ui.GameSpaceApp
import com.nrsqxw.dashgamespace.compose.ui.theme.DashGameSpaceTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        setContent {
            DashGameSpaceTheme(darkTheme = true) {
                GameSpaceApp()
            }
        }
    }
}
