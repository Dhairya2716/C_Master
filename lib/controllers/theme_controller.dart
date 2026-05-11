import 'package:flutter/material.dart';
import 'package:c_master/core/constants/theme_palette.dart';
import 'package:c_master/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static const _themeKeyLocal = 'theme_palette_id';

  final _box = GetStorage();
  final _firestoreService = FirestoreService();

  // ── Observables ────────────────────────────────────────────────────────────

  final currentThemeId = ThemePaletteManager.defaultPaletteId.obs;

  // ── Computed ───────────────────────────────────────────────────────────────

  ThemePalette get currentPalette => ThemePalette.fromId(currentThemeId.value);

  String get currentThemeName => currentPalette.name;

  List<ThemePalette> get availablePalettes => ThemePaletteManager.palettes;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadLocal();
    _syncFirestore();
  }

  void _loadLocal() {
    final saved = _box.read<String>(_themeKeyLocal);
    if (saved != null &&
        ThemePaletteManager.getAllPaletteIds().contains(saved)) {
      currentThemeId.value = saved;
    }
  }

  Future<void> _syncFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final remote = await _firestoreService.loadThemePreference(uid);
      if (remote != null &&
          ThemePaletteManager.getAllPaletteIds().contains(remote)) {
        currentThemeId.value = remote;
      }
    } catch (e) {
      print('Error syncing theme from Firestore: $e');
    }
  }

  // ── Change Theme ───────────────────────────────────────────────────────────

  Future<void> setTheme(String paletteId) async {
    if (!ThemePaletteManager.getAllPaletteIds().contains(paletteId)) {
      print('Invalid palette ID: $paletteId');
      return;
    }

    currentThemeId.value = paletteId;
    await _saveToStorage(paletteId);
    await _saveToFirestore(paletteId);
  }

  // ── Storage & Sync ─────────────────────────────────────────────────────────

  Future<void> _saveToStorage(String paletteId) async {
    await _box.write(_themeKeyLocal, paletteId);
  }

  Future<void> _saveToFirestore(String paletteId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await _firestoreService.saveThemePreference(uid, paletteId);
    } catch (e) {
      print('Error saving theme to Firestore: $e');
    }
  }

  // ── Get Theme Colors ───────────────────────────────────────────────────────

  Map<String, Color> getCurrentLightColors() => {
    'primary': currentPalette.lightPrimary,
    'secondary': currentPalette.lightSecondary,
    'accent': currentPalette.lightAccent,
  };

  Map<String, Color> getCurrentDarkColors() => {
    'primary': currentPalette.darkPrimary,
    'secondary': currentPalette.darkSecondary,
    'accent': currentPalette.darkAccent,
  };
}
