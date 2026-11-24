import 'package:flutter/material.dart';

class GameSpaceTheme {
  static const Color accent = Color(0xFF59BCFF);
  static const Color surface = Color(0x1F1A2028);
  static const Color topEdge = Color(0x66FFFFFF);

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF05080D),
      );
}
