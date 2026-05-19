import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ThemeNotifier — Sumber kebenaran tema aktif untuk MaterialApp.
///
/// Persisted via SharedPreferences di key `luma_theme_mode`.
/// Disinkronkan dengan SettingsNotifier — toggle dari settings page
/// akan memperbarui notifier ini juga.
class ThemeNotifier extends ChangeNotifier {
  static const _prefsKey = 'luma_theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  bool _hydrated = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// True ketika preferensi sudah dibaca dari disk.
  /// Sebelum hydrated, MaterialApp boleh fallback ke system default.
  bool get hydrated => _hydrated;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_prefsKey);
      _themeMode = _parseThemeMode(stored) ?? ThemeMode.system;
    } catch (_) {
      _themeMode = ThemeMode.system;
    }
    _hydrated = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, _themeMode.name);
    } catch (_) {
      // best-effort persist; jangan crash UI saat write gagal
    }
  }

  /// Set theme mode langsung
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    _persist();
  }

  /// Toggle dark ↔ light. Jika sebelumnya `system`, ikuti hasil resolved
  /// (dark menjadi light, light menjadi dark).
  void toggle() {
    setThemeMode(_themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void setDark()   => setThemeMode(ThemeMode.dark);
  void setLight()  => setThemeMode(ThemeMode.light);
  void setSystem() => setThemeMode(ThemeMode.system);

  ThemeMode? _parseThemeMode(String? raw) {
    switch (raw) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }
}
