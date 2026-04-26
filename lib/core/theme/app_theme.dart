import 'package:flutter/material.dart';

class AppTheme {
  static const _bg = Color(0xFF0B0F14);
  static const _surface = Color(0xFF111827);
  static const _surface2 = Color(0xFF0F172A);
  static const _outline = Color(0xFF263244);
  static const _text = Color(0xFFE5E7EB);
  static const _muted = Color(0xFF9CA3AF);
  static const _positive = Color(0xFF22C55E);
  static const _negative = Color(0xFFEF4444);

  static ThemeData dark({double textScale = 1.0}) {
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: const Color(0xFF60A5FA),
      secondary: const Color(0xFF34D399),
      surface: _surface,
      error: _negative,
      onSurface: _text,
      onPrimary: Colors.black,
      outline: _outline,
    );

    final textTheme = _textTheme(
      textScale,
    ).apply(bodyColor: _text, displayColor: _text);

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _bg,
      textTheme: textTheme,
      dividerColor: _outline,
      appBarTheme: AppBarTheme(
        backgroundColor: _bg,
        foregroundColor: _text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _outline.withValues(alpha: 0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _outline.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.9),
          ),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: _muted),
        prefixIconColor: _muted,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: _text,
        unselectedLabelColor: _muted,
        indicatorColor: colorScheme.primary,
        dividerColor: Colors.transparent,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _bg,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: _muted,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: _outline.withValues(alpha: 0.45)),
        ),
      ),
      listTileTheme: const ListTileThemeData(iconColor: _muted),
    );
  }

  static Color positive(BuildContext context) => _positive;
  static Color negative(BuildContext context) => _negative;
  static Color muted(BuildContext context) => _muted;
  static Color surface2(BuildContext context) => _surface2;

  static TextTheme _textTheme(double scale) {
    double s(double v) => v * scale;
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: s(36),
        fontWeight: FontWeight.w700,
        height: 1.1,
      ),
      headlineSmall: TextStyle(
        fontSize: s(24),
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      titleLarge: TextStyle(
        fontSize: s(18),
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      titleMedium: TextStyle(
        fontSize: s(16),
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      titleSmall: TextStyle(
        fontSize: s(13),
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      bodyLarge: TextStyle(
        fontSize: s(16),
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
      bodyMedium: TextStyle(
        fontSize: s(14),
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
      bodySmall: TextStyle(
        fontSize: s(12),
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
      labelLarge: TextStyle(
        fontSize: s(13),
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        fontSize: s(12),
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        fontSize: s(11),
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }
}
