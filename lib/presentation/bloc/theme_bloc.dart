import 'package:flutter/material.dart';

/// Theme state untuk mengelola dark/light mode
class ThemeState {
  final bool isDarkMode;
  final ThemeMode themeMode;

  const ThemeState({
    this.isDarkMode = true,
    this.themeMode = ThemeMode.system,
  });

  ThemeState copyWith({
    bool? isDarkMode,
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// Toggle antara dark dan light mode
  ThemeState toggle() {
    return copyWith(
      isDarkMode: !isDarkMode,
      themeMode: isDarkMode ? ThemeMode.light : ThemeMode.dark,
    );
  }

  /// Set ke system default
  ThemeState setSystem() {
    return copyWith(themeMode: ThemeMode.system);
  }

  /// Set ke dark mode
  ThemeState setDark() {
    return copyWith(
      isDarkMode: true,
      themeMode: ThemeMode.dark,
    );
  }

  /// Set ke light mode
  ThemeState setLight() {
    return copyWith(
      isDarkMode: false,
      themeMode: ThemeMode.light,
    );
  }
}

/// Simple theme notifier (alternatif jika tidak menggunakan BLoC/Riverpod)
class ThemeNotifier extends ChangeNotifier {
  ThemeState _state = const ThemeState(isDarkMode: true);

  ThemeState get state => _state;
  bool get isDarkMode => _state.isDarkMode;
  ThemeMode get themeMode => _state.themeMode;

  void toggle() {
    _state = _state.toggle();
    notifyListeners();
  }

  void setSystem() {
    _state = _state.setSystem();
    notifyListeners();
  }

  void setDark() {
    _state = _state.setDark();
    notifyListeners();
  }

  void setLight() {
    _state = _state.setLight();
    notifyListeners();
  }

  /// Set theme mode langsung dari ThemeMode enum
  void setThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        setDark();
      case ThemeMode.light:
        setLight();
      case ThemeMode.system:
        setSystem();
    }
  }

  /// Load dari preferences (akan diimplementasikan dengan SharedPreferences)
  Future<void> loadFromPrefs() async {
    // TODO: Implement dengan SharedPreferences
    notifyListeners();
  }

  /// Save ke preferences
  Future<void> saveToPrefs() async {
    // TODO: Implement dengan SharedPreferences
  }
}
