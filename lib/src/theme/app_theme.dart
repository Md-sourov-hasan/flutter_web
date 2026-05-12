import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFFF8F2E8);
  static const backgroundSoft = Color(0xFFE7DED0);
  static const backgroundDeep = Color(0xFFDCCDB8);
  static const panel = Color(0xFF162235);
  static const panelSoft = Color(0xFF22314A);
  static const surface = Color(0xFFF8F4EC);
  static const surfaceAlt = Color(0xFFEFE6D8);
  static const accent = Color(0xFFFF9D5C);
  static const accentStrong = Color(0xFFFFD166);
  static const accentSoft = Color(0xFFFFE1BD);
  static const accentMint = Color(0xFF8FE3C5);
  static const accentRose = Color(0xFFFF8CAB);
  static const textPrimary = Color(0xFFE5EEF9);
  static const textMuted = Color(0xFF9FB0C7);
  static const textDark = Color(0xFF18212F);
  static const textDarkMuted = Color(0xFF566476);
  static const lineLight = Color(0x1FFFFFFF);
  static const lineDark = Color(0x1A101828);

  static ThemeData get theme {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 58,
          height: 0.92,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -2.2,
        ),
        displayMedium: TextStyle(
          fontSize: 44,
          height: 0.95,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -1.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          height: 1.08,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.8,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          height: 1.15,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          height: 1.7,
          color: textMuted,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: textMuted,
        ),
      ),
    );
  }
}
