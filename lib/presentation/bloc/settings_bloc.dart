import 'package:flutter/material.dart';

/// Settings state untuk mengelola preferensi user
class SettingsState {
  final bool isLoading;
  final String? error;
  final String languageCode; // 'id' atau 'en'
  final bool notificationsEnabled;
  final bool dataCollectionEnabled;
  final ThemeMode themeMode;
  final DateTime? lastBackupDate;

  const SettingsState({
    this.isLoading = false,
    this.error,
    this.languageCode = 'id',
    this.notificationsEnabled = true,
    this.dataCollectionEnabled = true,
    this.themeMode = ThemeMode.system,
    this.lastBackupDate,
  });

  SettingsState copyWith({
    bool? isLoading,
    String? error,
    String? languageCode,
    bool? notificationsEnabled,
    bool? dataCollectionEnabled,
    ThemeMode? themeMode,
    DateTime? lastBackupDate,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      languageCode: languageCode ?? this.languageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dataCollectionEnabled: dataCollectionEnabled ?? this.dataCollectionEnabled,
      themeMode: themeMode ?? this.themeMode,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }

  /// Get display name untuk language
  String get languageDisplayName {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'id':
      default:
        return 'Bahasa Indonesia';
    }
  }
}

/// Simple settings notifier (alternatif jika tidak menggunakan BLoC/Riverpod)
class SettingsNotifier extends ChangeNotifier {
  SettingsState _state = const SettingsState();

  SettingsState get state => _state;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  String get languageCode => _state.languageCode;
  bool get notificationsEnabled => _state.notificationsEnabled;
  bool get dataCollectionEnabled => _state.dataCollectionEnabled;
  ThemeMode get themeMode => _state.themeMode;
  DateTime? get lastBackupDate => _state.lastBackupDate;

  /// Load settings dari database/preferences
  Future<void> loadSettings() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // TODO: Implement dengan actual loading dari AppPreferences
      await Future.delayed(const Duration(milliseconds: 300));
      
      _state = _state.copyWith(
        isLoading: false,
        languageCode: 'id',
        notificationsEnabled: true,
        dataCollectionEnabled: true,
        themeMode: ThemeMode.system,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    
    notifyListeners();
  }

  /// Toggle language
  void toggleLanguage() {
    _state = _state.copyWith(
      languageCode: _state.languageCode == 'id' ? 'en' : 'id',
    );
    notifyListeners();
  }

  /// Set language
  void setLanguage(String code) {
    _state = _state.copyWith(languageCode: code);
    notifyListeners();
  }

  /// Toggle notifications
  void toggleNotifications() {
    _state = _state.copyWith(
      notificationsEnabled: !_state.notificationsEnabled,
    );
    notifyListeners();
  }

  /// Toggle data collection
  void toggleDataCollection() {
    _state = _state.copyWith(
      dataCollectionEnabled: !_state.dataCollectionEnabled,
    );
    notifyListeners();
  }

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    _state = _state.copyWith(themeMode: mode);
    notifyListeners();
  }

  /// Export backup
  Future<bool> exportBackup() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // TODO: Implement dengan actual backup export
      await Future.delayed(const Duration(seconds: 1));
      
      _state = _state.copyWith(
        isLoading: false,
        lastBackupDate: DateTime.now(),
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  /// Import backup
  Future<bool> importBackup() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // TODO: Implement dengan actual backup import
      await Future.delayed(const Duration(seconds: 1));
      
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _state = _state.copyWith(error: null);
    notifyListeners();
  }
}
