package com.nrsqxw.dashgamespace.compose.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val DarkScheme = darkColorScheme(
    primary = DashColors.Accent,
    onPrimary = DashColors.Background,
    secondary = DashColors.AccentMint,
    surface = DashColors.Surface,
    onSurface = DashColors.TextPrimary,
    surfaceVariant = DashColors.SurfaceElevated,
    onSurfaceVariant = DashColors.TextSecondary,
    outline = DashColors.Border,
    background = DashColors.Background,
    onBackground = DashColors.TextPrimary,
)

private val LightScheme = lightColorScheme(
    primary = DashColors.Accent,
    onPrimary = DashColors.Background,
    surface = DashColors.Surface,
    onSurface = DashColors.TextPrimary,
)

@Composable
fun DashGameSpaceTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    MaterialTheme(
        colorScheme = if (darkTheme) DarkScheme else LightScheme,
        typography = DashTypography,
        content = content,
    )
}
