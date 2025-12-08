import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Shadcn-inspired color palette
  // Light theme colors
  static const Color _lightPrimary =
      Color(0xFF8B5CF6); // hsl(262.1 83.3% 57.8%)
  static const Color _lightBackground = Color(0xFFFFFFFF); // hsl(0 0% 100%)
  static const Color _lightForeground =
      Color(0xFF020817); // hsl(224 71.4% 4.1%)
  static const Color _lightCard = Color(0xFFFFFFFF); // hsl(0 0% 100%)
  static const Color _lightSecondary =
      Color(0xFFF1F5F9); // hsl(220 14.3% 95.9%)
  static const Color _lightSecondaryForeground =
      Color(0xFF0F172A); // hsl(220.9 39.3% 11%)
  static const Color _lightMuted = Color(0xFFF1F5F9); // hsl(220 14.3% 95.9%)
  static const Color _lightMutedForeground =
      Color(0xFF64748B); // hsl(220 8.9% 46.1%)
  static const Color _lightBorder = Color(0xFFE2E8F0); // hsl(220 13% 91%)
  static const Color _lightDestructive =
      Color(0xFFEF4444); // hsl(0 84.2% 60.2%)
  static const Color _lightRing = Color(0xFF8B5CF6); // hsl(262.1 83.3% 57.8%)

  // Dark theme colors
  static const Color _darkPrimary = Color(0xFF7C3AED); // hsl(263.4 70% 50.4%)
  static const Color _darkBackground = Color(0xFF020817); // hsl(224 71.4% 4.1%)
  static const Color _darkForeground = Color(0xFFFAFAFA); // hsl(210 20% 98%)
  static const Color _darkCard = Color(0xFF020817); // hsl(224 71.4% 4.1%)
  static const Color _darkSecondary = Color(0xFF1E293B); // hsl(215 27.9% 16.9%)
  static const Color _darkMuted = Color(0xFF1E293B); // hsl(215 27.9% 16.9%)
  static const Color _darkMutedForeground =
      Color(0xFF94A3B8); // hsl(217.9 10.6% 64.9%)
  static const Color _darkBorder = Color(0xFF1E293B); // hsl(215 27.9% 16.9%)
  static const Color _darkDestructive = Color(0xFF7F1D1D); // hsl(0 62.8% 30.6%)

  // Border radius
  static const double _borderRadius = 10.4; // 0.65rem * 16

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        surface: _lightCard,
        error: _lightDestructive,
        onPrimary: _lightBackground,
        onSecondary: _lightSecondaryForeground,
        onSurface: _lightForeground,
        onError: _lightBackground,
        outline: _lightBorder,
      ),
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _lightCard,
        foregroundColor: _lightForeground,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _lightCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          side: const BorderSide(color: _lightBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _lightPrimary,
          foregroundColor: _lightBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: _lightForeground,
          side: const BorderSide(color: _lightBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _lightRing, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _lightDestructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _lightDestructive, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _lightSecondary,
        selectedColor: _lightPrimary,
        labelStyle: const TextStyle(color: _lightSecondaryForeground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: _lightBorder,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 96, fontWeight: FontWeight.w300, color: _lightForeground,),
        displayMedium: TextStyle(
            fontSize: 60, fontWeight: FontWeight.w300, color: _lightForeground,),
        displaySmall: TextStyle(
            fontSize: 48, fontWeight: FontWeight.w400, color: _lightForeground,),
        headlineMedium: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w600, color: _lightForeground,),
        headlineSmall: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: _lightForeground,),
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: _lightForeground,),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: _lightForeground,),
        titleSmall: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: _lightForeground,),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: _lightForeground,),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: _lightForeground,),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _lightMutedForeground,),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: _lightForeground,),
        labelMedium: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: _lightForeground,),
        labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: _lightMutedForeground,),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        surface: _darkCard,
        error: _darkDestructive,
        onPrimary: _darkForeground,
        onSecondary: _darkForeground,
        onSurface: _darkForeground,
        onError: _darkForeground,
        outline: _darkBorder,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _darkCard,
        foregroundColor: _darkForeground,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _darkCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          side: const BorderSide(color: _darkBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _darkPrimary,
          foregroundColor: _darkForeground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: _darkForeground,
          side: const BorderSide(color: _darkBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _darkDestructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: const BorderSide(color: _darkDestructive, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _darkSecondary,
        selectedColor: _darkPrimary,
        labelStyle: const TextStyle(color: _darkForeground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: _darkBorder,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 96, fontWeight: FontWeight.w300, color: _darkForeground,),
        displayMedium: TextStyle(
            fontSize: 60, fontWeight: FontWeight.w300, color: _darkForeground,),
        displaySmall: TextStyle(
            fontSize: 48, fontWeight: FontWeight.w400, color: _darkForeground,),
        headlineMedium: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w600, color: _darkForeground,),
        headlineSmall: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: _darkForeground,),
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: _darkForeground,),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: _darkForeground,),
        titleSmall: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: _darkForeground,),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: _darkForeground,),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: _darkForeground,),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _darkMutedForeground,),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: _darkForeground,),
        labelMedium: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: _darkForeground,),
        labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: _darkMutedForeground,),
      ),
    );
  }
}
