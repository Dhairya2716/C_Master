import 'package:flutter/material.dart';

// ─── Theme Palette Definition ─────────────────────────────────────────────────

class ThemePalette {
  final String name;
  final String id;
  final Color lightPrimary;
  final Color lightSecondary;
  final Color lightAccent;
  final Color darkPrimary;
  final Color darkSecondary;
  final Color darkAccent;

  ThemePalette({
    required this.name,
    required this.id,
    required this.lightPrimary,
    required this.lightSecondary,
    required this.lightAccent,
    required this.darkPrimary,
    required this.darkSecondary,
    required this.darkAccent,
  });

  factory ThemePalette.fromId(String id) {
    return ThemePaletteManager.palettes.firstWhere(
      (p) => p.id == id,
      orElse: () => ThemePaletteManager.palettes.first,
    );
  }
}

// ─── Theme Palette Manager ────────────────────────────────────────────────────

class ThemePaletteManager {
  static const String _defaultPaletteId = 'indigo';

  // Predefined color palettes
  static final List<ThemePalette> palettes = [
    // Indigo (default)
    ThemePalette(
      name: 'Indigo',
      id: 'indigo',
      lightPrimary: const Color(0xFF4F46E5),
      lightSecondary: const Color(0xFF7C3AED),
      lightAccent: const Color(0xFFF59E0B),
      darkPrimary: const Color(0xFF60A5FA),
      darkSecondary: const Color(0xFFA78BFA),
      darkAccent: const Color(0xFFFBBF24),
    ),

    // Blue
    ThemePalette(
      name: 'Blue',
      id: 'blue',
      lightPrimary: const Color(0xFF2563EB),
      lightSecondary: const Color(0xFF1D4ED8),
      lightAccent: const Color(0xFF0284C7),
      darkPrimary: const Color(0xFF60A5FA),
      darkSecondary: const Color(0xFF3B82F6),
      darkAccent: const Color(0xFF0EA5E9),
    ),

    // Purple
    ThemePalette(
      name: 'Purple',
      id: 'purple',
      lightPrimary: const Color(0xFFA855F7),
      lightSecondary: const Color(0xFF9333EA),
      lightAccent: const Color(0xFFD946EF),
      darkPrimary: const Color(0xFFD8B4FE),
      darkSecondary: const Color(0xFFE9D5FF),
      darkAccent: const Color(0xFFF0ABFC),
    ),

    // Green
    ThemePalette(
      name: 'Green',
      id: 'green',
      lightPrimary: const Color(0xFF059669),
      lightSecondary: const Color(0xFF10B981),
      lightAccent: const Color(0xFF14B8A6),
      darkPrimary: const Color(0xFF6EE7B7),
      darkSecondary: const Color(0xFFA7F3D0),
      darkAccent: const Color(0xFF5EEAD4),
    ),

    // Red
    ThemePalette(
      name: 'Red',
      id: 'red',
      lightPrimary: const Color(0xFFDC2626),
      lightSecondary: const Color(0xFFB91C1C),
      lightAccent: const Color(0xFFF97316),
      darkPrimary: const Color(0xFFFCA5A5),
      darkSecondary: const Color(0xFFFECACA),
      darkAccent: const Color(0xFFFDBA74),
    ),

    // Pink
    ThemePalette(
      name: 'Pink',
      id: 'pink',
      lightPrimary: const Color(0xFFEC4899),
      lightSecondary: const Color(0xFFF43F5E),
      lightAccent: const Color(0xFFF97316),
      darkPrimary: const Color(0xFFFB7185),
      darkSecondary: const Color(0xFFFDA4AF),
      darkAccent: const Color(0xFFFECDD3),
    ),

    // Teal
    ThemePalette(
      name: 'Teal',
      id: 'teal',
      lightPrimary: const Color(0xFF0D9488),
      lightSecondary: const Color(0xFF0F766E),
      lightAccent: const Color(0xFF06B6D4),
      darkPrimary: const Color(0xFF2DD4BF),
      darkSecondary: const Color(0xFF67E8F9),
      darkAccent: const Color(0xFF06B6D4),
    ),

    // Amber
    ThemePalette(
      name: 'Amber',
      id: 'amber',
      lightPrimary: const Color(0xFFD97706),
      lightSecondary: const Color(0xFFB45309),
      lightAccent: const Color(0xFFF59E0B),
      darkPrimary: const Color(0xFFFCD34D),
      darkSecondary: const Color(0xFFFBBF24),
      darkAccent: const Color(0xFFFDE047),
    ),

    // Slate
    ThemePalette(
      name: 'Slate',
      id: 'slate',
      lightPrimary: const Color(0xFF475569),
      lightSecondary: const Color(0xFF64748B),
      lightAccent: const Color(0xFF94A3B8),
      darkPrimary: const Color(0xFFCBD5E1),
      darkSecondary: const Color(0xFFE2E8F0),
      darkAccent: const Color(0xFFF1F5F9),
    ),
  ];

  static String get defaultPaletteId => _defaultPaletteId;

  static ThemePalette getPalette(String id) => ThemePalette.fromId(id);

  static List<String> getAllPaletteNames() => palettes.map((p) => p.name).toList();

  static List<String> getAllPaletteIds() => palettes.map((p) => p.id).toList();

  static Color getLightPrimary(String paletteId) => getPalette(paletteId).lightPrimary;

  static Color getDarkPrimary(String paletteId) => getPalette(paletteId).darkPrimary;
}
