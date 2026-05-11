import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_palette.dart';

// ─── Palette ──────────────────────────────────────────────────────────────────

class AppColors {
  // Light
  static const lightPrimary = Color(0xFF4F46E5); // Indigo
  static const lightSecondary = Color(0xFF7C3AED); // Violet
  static const lightAccent = Color(0xFFF59E0B); // Amber
  static const lightBg = Color(0xFFF8F9FE);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightOnPrimary = Colors.white;
  static const lightOnBg = Color(0xFF1E1B4B);
  static const lightSubtitle = Color(0xFF6B7280);

  // Dark
  static const darkPrimary = Color(0xFF60A5FA); // Sky blue
  static const darkSecondary = Color(0xFFA78BFA); // Lavender
  static const darkAccent = Color(0xFFFBBF24); // Gold
  static const darkBg = Color(0xFF0F172A); // Deep Navy
  static const darkSurface = Color(0xFF1E293B); // Slate
  static const darkCard = Color(0xFF1E293B);
  static const darkOnPrimary = Color(0xFF0F172A);
  static const darkOnBg = Color(0xFFF1F5F9);
  static const darkSubtitle = Color(0xFF94A3B8);

  // Shared card gradients for dashboard tiles
  static const List<List<Color>> tileGradients = [
    [Color(0xFF4F46E5), Color(0xFF7C3AED)], // Learn C – Indigo→Violet
    [Color(0xFF0EA5E9), Color(0xFF6366F1)], // Quiz – Sky→Indigo
    [Color(0xFF10B981), Color(0xFF059669)], // Code – Emerald
    [Color(0xFFF59E0B), Color(0xFFEF4444)], // Bookmarks – Amber→Red
    [Color(0xFFEC4899), Color(0xFFA855F7)], // Progress – Pink→Purple
    [Color(0xFF06B6D4), Color(0xFF3B82F6)], // AI – Cyan→Blue
  ];
}

// ─── Theme ────────────────────────────────────────────────────────────────────

class AppTheme {
  static ThemeData lightTheme(ThemePalette? palette) {
    palette ??= ThemePalette.fromId(ThemePaletteManager.defaultPaletteId);

    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.light(
        primary: palette.lightPrimary,
        secondary: palette.lightSecondary,
        tertiary: palette.lightAccent,
        surface: AppColors.lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightOnBg,
      ),
      scaffoldBackgroundColor: AppColors.lightBg,
      textTheme: _textTheme(AppColors.lightOnBg, AppColors.lightSubtitle),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.lightPrimary),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.lightOnBg,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: palette.lightPrimary.withOpacity(0.08),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.lightPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: _inputTheme(
        palette.lightPrimary,
        AppColors.lightSubtitle,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette?.lightPrimary
              : Colors.grey.shade400,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette?.lightPrimary.withOpacity(0.3)
              : Colors.grey.shade300,
        ),
      ),
      dividerColor: Colors.grey.shade200,
      useMaterial3: true,
    );
  }

  static ThemeData darkTheme(ThemePalette? palette) {
    palette ??= ThemePalette.fromId(ThemePaletteManager.defaultPaletteId);

    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: palette.darkPrimary,
        secondary: palette.darkSecondary,
        tertiary: palette.darkAccent,
        surface: AppColors.darkSurface,
        onPrimary: AppColors.darkOnPrimary,
        onSecondary: Colors.white,
        onSurface: AppColors.darkOnBg,
      ),
      scaffoldBackgroundColor: AppColors.darkBg,
      textTheme: _textTheme(AppColors.darkOnBg, AppColors.darkSubtitle),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.darkPrimary),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.darkOnBg,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: _inputTheme(
        palette.darkPrimary,
        AppColors.darkSubtitle,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette?.darkPrimary
              : Colors.grey.shade600,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette?.darkPrimary.withOpacity(0.35)
              : Colors.grey.shade800,
        ),
      ),
      dividerColor: Colors.white.withOpacity(0.08),
      useMaterial3: true,
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  static TextTheme _textTheme(Color main, Color sub) => TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: main,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: main,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: main,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: main,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: main,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: main,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: main,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: sub,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: main,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: main,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: sub,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: main,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: sub,
    ),
  );

  static InputDecorationTheme _inputTheme(Color primary, Color hint) =>
      InputDecorationTheme(
        filled: true,
        fillColor: primary.withOpacity(0.06),
        hintStyle: GoogleFonts.poppins(color: hint, fontSize: 14),
        labelStyle: GoogleFonts.poppins(color: hint, fontSize: 14),
        prefixIconColor: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      );
}

// ─── Context Extension ────────────────────────────────────────────────────────

extension AppThemeX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
