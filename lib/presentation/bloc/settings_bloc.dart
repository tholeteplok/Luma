import 'package:flutter/material.dart';
import '../../data/backup/drive_backup_manager.dart';
import '../../data/db/database_service.dart';
import '../../data/db/models/models.dart';
import '../../data/sync/google_auth_service.dart';
import '../../core/services/background_task_manager.dart';

/// Settings state untuk mengelola preferensi user
class SettingsState {
  final bool isLoading;
  final String? error;
  final String languageCode; // 'id' atau 'en'
  final bool notificationsEnabled;
  final bool dataCollectionEnabled;
  final ThemeMode themeMode;
  final DateTime? lastBackupDate;
  final bool autoBackupEnabled;
  final bool isBackingUp;
  final bool isRestoring;
  final bool reduceMotion; // Aksesibilitas: matikan animasi organik

  /// Email akun Google yang terhubung untuk backup (null = belum sign-in)
  final String? connectedEmail;

  const SettingsState({
    this.isLoading = false,
    this.error,
    this.languageCode = 'id',
    this.notificationsEnabled = true,
    this.dataCollectionEnabled = true,
    this.themeMode = ThemeMode.system,
    this.lastBackupDate,
    this.autoBackupEnabled = true,
    this.isBackingUp = false,
    this.isRestoring = false,
    this.reduceMotion = false,
    this.connectedEmail,
  });

  SettingsState copyWith({
    bool? isLoading,
    String? error,
    String? languageCode,
    bool? notificationsEnabled,
    bool? dataCollectionEnabled,
    ThemeMode? themeMode,
    DateTime? lastBackupDate,
    bool? autoBackupEnabled,
    bool? isBackingUp,
    bool? isRestoring,
    bool? reduceMotion,
    String? connectedEmail,
    bool clearError = false,
    bool clearConnectedEmail = false,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      languageCode: languageCode ?? this.languageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dataCollectionEnabled: dataCollectionEnabled ?? this.dataCollectionEnabled,
      themeMode: themeMode ?? this.themeMode,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      isBackingUp: isBackingUp ?? this.isBackingUp,
      isRestoring: isRestoring ?? this.isRestoring,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      connectedEmail: clearConnectedEmail ? null : (connectedEmail ?? this.connectedEmail),
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

/// SettingsNotifier — State management untuk halaman pengaturan
class SettingsNotifier extends ChangeNotifier {
  SettingsState _state = const SettingsState();

  final DatabaseService _db = DatabaseService();
  final DriveBackupManager _backupManager = DriveBackupManager();

  SettingsState get state => _state;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  String get languageCode => _state.languageCode;
  bool get notificationsEnabled => _state.notificationsEnabled;
  bool get dataCollectionEnabled => _state.dataCollectionEnabled;
  ThemeMode get themeMode => _state.themeMode;
  DateTime? get lastBackupDate => _state.lastBackupDate;
  bool get autoBackupEnabled => _state.autoBackupEnabled;
  bool get isBackingUp => _state.isBackingUp;
  bool get isRestoring => _state.isRestoring;
  bool get reduceMotion => _state.reduceMotion;
  String? get connectedEmail => _state.connectedEmail;

  /// Toggle reduce motion
  void toggleReduceMotion() {
    _state = _state.copyWith(reduceMotion: !_state.reduceMotion);
    notifyListeners();
  }

  /// Load settings dari database/preferences
  Future<void> loadSettings() async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    try {
      final prefs = await _db.db.appPreferences.getByKey('app_settings');

      _state = _state.copyWith(
        isLoading: false,
        languageCode: prefs?.languageCode ?? 'id',
        notificationsEnabled: prefs?.notificationsEnabled ?? true,
        dataCollectionEnabled: prefs?.dataCollectionEnabled ?? true,
        themeMode: (prefs?.useDarkMode ?? true) ? ThemeMode.dark : ThemeMode.light,
        lastBackupDate: prefs?.lastBackupDate,
        autoBackupEnabled: prefs?.backupEnabled ?? true,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }

    notifyListeners();
  }

  // ─────────────────────── SETTINGS ACTIONS ───────────────────────

  /// Toggle language (id ↔ en)
  void toggleLanguage() {
    _state = _state.copyWith(
      languageCode: _state.languageCode == 'id' ? 'en' : 'id',
    );
    _persistPreferences();
    notifyListeners();
  }

  /// Set language by code
  void setLanguage(String code) {
    _state = _state.copyWith(languageCode: code);
    _persistPreferences();
    notifyListeners();
  }

  /// Toggle notifications
  void toggleNotifications() {
    _state = _state.copyWith(
      notificationsEnabled: !_state.notificationsEnabled,
    );
    _persistPreferences();
    notifyListeners();
  }

  /// Toggle data collection
  void toggleDataCollection() {
    _state = _state.copyWith(
      dataCollectionEnabled: !_state.dataCollectionEnabled,
    );
    _persistPreferences();
    notifyListeners();
  }

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    _state = _state.copyWith(themeMode: mode);
    _persistPreferences();
    notifyListeners();
  }

  /// Toggle auto-backup (weekly, charging + WiFi)
  Future<void> toggleAutoBackup() async {
    final newValue = !_state.autoBackupEnabled;
    _state = _state.copyWith(autoBackupEnabled: newValue);
    notifyListeners();

    try {
      if (newValue) {
        await BackgroundTaskInitializer.registerWeeklyBackupTask();
        debugPrint('[SettingsNotifier] Auto-backup ENABLED');
      } else {
        await BackgroundTaskInitializer.cancelWeeklyBackupTask();
        debugPrint('[SettingsNotifier] Auto-backup DISABLED');
      }
      await _persistPreferences();
    } catch (e) {
      debugPrint('[SettingsNotifier] toggleAutoBackup error: $e');
      // Rollback jika gagal mendaftarkan task
      _state = _state.copyWith(autoBackupEnabled: !newValue);
      notifyListeners();
    }
  }

  // ─────────────────────── BACKUP ACTIONS ───────────────────────

  /// Export / backup manual ke Google Drive
  Future<bool> exportBackup() async {
    if (_state.isBackingUp) return false;

    _state = _state.copyWith(isBackingUp: true, clearError: true);
    notifyListeners();

    try {
      final fileName = await _backupManager.backup();
      if (fileName != null) {
        // Ambil email akun yang terhubung setelah backup berhasil
        final email = GoogleAuthService().currentAccount?.email;
        _state = _state.copyWith(
          isBackingUp: false,
          lastBackupDate: DateTime.now(),
          connectedEmail: email,
        );
        notifyListeners();
        return true;
      } else {
        // null bisa berarti: platform tidak didukung, belum dikonfigurasi,
        // sign-in dibatalkan, atau error teknis
        final authError = GoogleAuthService().lastErrorDescription;
        final customError = authError != null
            ? (languageCode == 'id' ? 'Backup gagal: $authError' : 'Backup failed: $authError')
            : (languageCode == 'id'
                ? 'Backup gagal. Pastikan kamu sudah masuk ke akun Google dan koneksi internet aktif.'
                : 'Backup failed. Make sure you are signed in to Google and have an active internet connection.');
        _state = _state.copyWith(
          isBackingUp: false,
          error: customError,
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = _state.copyWith(
        isBackingUp: false,
        error: languageCode == 'id'
            ? 'Backup gagal: ${_friendlyError(e)}'
            : 'Backup failed: ${_friendlyError(e)}',
      );
      notifyListeners();
      return false;
    }
  }

  /// Import / restore dari backup Drive (by fileId)
  Future<bool> importBackup([String? fileId]) async {
    if (_state.isRestoring) return false;

    _state = _state.copyWith(isRestoring: true, clearError: true);
    notifyListeners();

    try {
      String targetFileId = fileId ?? '';
      if (targetFileId.isEmpty) {
        final backups = await _backupManager.listBackups();
        if (backups.isEmpty) {
          _state = _state.copyWith(
            isRestoring: false,
            error: languageCode == 'id'
                ? 'Tidak ada cadangan yang tersedia.'
                : 'No backups available.',
          );
          notifyListeners();
          return false;
        }
        targetFileId = backups.first.fileId;
      }

      final success = await _backupManager.restore(targetFileId);
      if (success) {
        _state = _state.copyWith(isRestoring: false);
        notifyListeners();
        return true;
      } else {
        _state = _state.copyWith(
          isRestoring: false,
          error: languageCode == 'id'
              ? 'Restore gagal. Cadangan mungkin rusak.'
              : 'Restore failed. Backup may be corrupted.',
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = _state.copyWith(
        isRestoring: false,
        error: languageCode == 'id'
            ? 'Restore gagal: ${_friendlyError(e)}'
            : 'Restore failed: ${_friendlyError(e)}',
      );
      notifyListeners();
      return false;
    }
  }

  /// List semua backup yang tersedia di Drive
  Future<List<BackupEntry>> listBackups() async {
    return _backupManager.listBackups();
  }

  /// Hapus backup dari Drive
  Future<bool> deleteBackup(String fileId) async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();
    try {
      final success = await _backupManager.deleteBackup(fileId);
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      return success;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: languageCode == 'id'
            ? 'Gagal menghapus: ${_friendlyError(e)}'
            : 'Failed to delete: ${_friendlyError(e)}',
      );
      notifyListeners();
      return false;
    }
  }

  /// Estimasi ukuran backup dalam bytes
  Future<int> estimateBackupSize() async {
    return _backupManager.estimateBackupSize();
  }


  // ─────────────────────── INTERNAL ───────────────────────

  /// Terjemahkan exception ke pesan yang ramah user
  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket') || msg.contains('connection')) {
      return languageCode == 'id' ? 'Periksa koneksi internet.' : 'Check your internet connection.';
    }
    if (msg.contains('unauthorized') || msg.contains('401') || msg.contains('forbidden')) {
      return languageCode == 'id' ? 'Sesi Google habis. Coba lagi.' : 'Google session expired. Try again.';
    }
    if (msg.contains('quota') || msg.contains('storage')) {
      return languageCode == 'id' ? 'Penyimpanan Drive penuh.' : 'Drive storage is full.';
    }
    return languageCode == 'id' ? 'Coba lagi nanti.' : 'Please try again later.';
  }

  /// Persist preferences ke Isar
  Future<void> _persistPreferences() async {
    try {
      final now = DateTime.now();
      await _db.db.writeTxn(() async {
        final existing = await _db.db.appPreferences.getByKey('app_settings');

        final prefs = existing ?? (AppPreferences()..lastUpdated = now);
        prefs
          ..languageCode = _state.languageCode
          ..notificationsEnabled = _state.notificationsEnabled
          ..dataCollectionEnabled = _state.dataCollectionEnabled
          ..useDarkMode = _state.themeMode == ThemeMode.dark
          ..backupEnabled = _state.autoBackupEnabled
          ..lastUpdated = now;

        await _db.db.appPreferences.put(prefs);
      });
    } catch (e) {
      debugPrint('[SettingsNotifier] _persistPreferences error: $e');
    }
  }

  /// Clear error state
  void clearError() {
    _state = _state.copyWith(clearError: true);
    notifyListeners();
  }
}
