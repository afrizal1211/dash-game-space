import 'package:flutter/material.dart';

class GameSpaceTheme {
  static const Color accent = Color(0xFF6FD3FF);
  static const Color accentDeep = Color(0xFF2E7BFF);
  static const Color ink = Color(0xFF050912);
  static const Color surface = Color(0x1F162033);
  static const Color border = Color(0x33FFFFFF);
  static const Color muted = Color(0xFF9AA7B8);

  static ThemeData dark() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: accentDeep,
      brightness: Brightness.dark,
    ).copyWith(
      primary: accent,
      onPrimary: ink,
      secondary: const Color(0xFFB388FF),
      surface: const Color(0xFF111827),
      onSurface: Colors.white,
      outline: border,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: ink,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: border),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFC7D0DE)),
      ),
    );
  }

  static BoxDecoration panel({bool active = false}) => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: active
              ? <Color>[Color(0x664FA8FF), Color(0x33162B4D)]
              : <Color>[Color(0x2BFFFFFF), Color(0x0F1B2740)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: active ? accent.withOpacity(0.65) : border,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      );
}
