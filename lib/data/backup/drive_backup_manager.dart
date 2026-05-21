import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:isar/isar.dart';import '../db/database_service.dart';
import '../db/models/models.dart';
import '../encryption/encryption_service.dart';
import '../sync/drive_key_manager.dart';
import '../sync/google_auth_service.dart';

/// Representasi metadata satu file backup di Drive
class BackupEntry {
  final String fileId;
  final String fileName;
  final DateTime createdAt;
  final int sizeBytes;

  const BackupEntry({
    required this.fileId,
    required this.fileName,
    required this.createdAt,
    required this.sizeBytes,
  });
}

/// DriveBackupManager — Backup & Restore pragmatis ke Google Drive
///
/// Scope backup sesuai ADR-001:
///  - insight (semua)
///  - weekly_profile (4 minggu terakhir)
///  - baseline (global_baseline)
///  - app_preferences
///
/// Format: JSON terenkripsi (AES-256-GCM) di appDataFolder
/// File name: luma_backup_{timestamp}.lmb
class DriveBackupManager {
  static final DriveBackupManager _instance = DriveBackupManager._internal();
  factory DriveBackupManager() => _instance;
  DriveBackupManager._internal();

  static const String _backupPrefix = 'luma_backup_';
  static const String _backupExtension = '.lmb';
  static const String _appDataFolder = 'appDataFolder';

  final DatabaseService _db = DatabaseService();
  final EncryptionService _encryption = EncryptionService();
  final DriveKeyManager _keyManager = DriveKeyManager();
  final GoogleAuthService _auth = GoogleAuthService();

  drive.DriveApi? _driveApi;
  bool _isInitialized = false;

  /// Inisialisasi dengan authenticated client (manual — untuk testing / background task)
  Future<void> initialize(auth.AuthClient authClient) async {
    _driveApi = drive.DriveApi(authClient);
    await _keyManager.initialize(authClient);
    _isInitialized = true;
    debugPrint('[DriveBackupManager] Initialized (manual)');
  }

  /// Auto-initialize via GoogleAuthService.
  /// Menampilkan dialog sign-in jika belum sign-in.
  /// Return false jika user membatalkan atau terjadi error.
  Future<bool> initializeWithSignIn() async {
    if (!GoogleAuthService.isPlatformSupported) {
      debugPrint('[DriveBackupManager] Backup tidak didukung di platform ini '
          '(${defaultTargetPlatform.name}). Hanya Android dan iOS.');
      return false;
    }

    if (!_auth.isConfigured) {
      debugPrint('[DriveBackupManager] Google Auth belum dikonfigurasi. '
          'Lihat komentar di google_auth_service.dart untuk setup.');
      return false;
    }

    try {
      var client = await _auth.signInSilently();
      client ??= await _auth.signIn();

      if (client == null) {
        debugPrint('[DriveBackupManager] Sign-in gagal atau dibatalkan');
        return false;
      }

      await initialize(client);
      return true;
    } catch (e) {
      debugPrint('[DriveBackupManager] initializeWithSignIn error: $e');
      return false;
    }
  }

  /// Pastikan sudah terinisialisasi — refresh auth jika perlu.
  /// Dipanggil di awal setiap operasi backup/restore/list.
  Future<bool> _ensureInitialized() async {
    // Selalu coba refresh client (token bisa expired)
    final freshClient = await _auth.getAuthClient();
    if (freshClient != null) {
      _driveApi = drive.DriveApi(freshClient);
      await _keyManager.initialize(freshClient);
      _isInitialized = true;
      return true;
    }

    // Tidak ada client valid — lakukan sign-in
    return initializeWithSignIn();
  }

  bool get isInitialized => _isInitialized;

  // ─────────────────────────── BACKUP ───────────────────────────

  /// Backup seluruh data yang diperlukan ke Google Drive
  /// Returns: nama file backup yang dibuat, atau null jika gagal
  Future<String?> backup() async {
    final ready = await _ensureInitialized();
    if (!ready || _driveApi == null) {
      debugPrint('[DriveBackupManager] Tidak bisa initialize — backup dibatalkan');
      return null;
    }

    try {
      // 1. Kumpulkan data
      final payload = await _collectBackupData();
      final payloadJson = jsonEncode(payload);
      final payloadBytes = utf8.encode(payloadJson);

      // 2. Ambil/buat encryption key dan initialize EncryptionService
      Uint8List encKey;
      final existingKey = await _keyManager.downloadKey();
      if (existingKey != null) {
        encKey = existingKey;
      } else {
        encKey = _keyManager.generateRandomKey();
        await _keyManager.uploadKey(encKey);
      }
      // Initialize EncryptionService dengan key tersebut
      await _encryption.initialize(encKey);

      // 3. Enkripsi bytes (encryptBytes hanya terima 1 arg, key dikelola internal)
      final encrypted = base64Decode(
        await _encryption.encryptBytes(Uint8List.fromList(payloadBytes)),
      );

      // 4. Upload ke Drive
      final timestamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
      final fileName = '$_backupPrefix$timestamp$_backupExtension';

      await _uploadToDrive(fileName, encrypted);

      // 5. Update lastBackupDate di preferences
      await _updateLastBackupDate(DateTime.now());

      debugPrint('[DriveBackupManager] Backup berhasil: $fileName');
      return fileName;
    } catch (e, stack) {
      debugPrint('[DriveBackupManager] Backup gagal: $e\n$stack');
      return null;
    }
  }

  /// Kumpulkan semua data yang harus di-backup
  Future<Map<String, dynamic>> _collectBackupData() async {
    final now = DateTime.now();
    final fourWeeksAgo = now.subtract(const Duration(days: 28));

    // Insights (semua, tidak ada batasan waktu)
    final insights = await _db.db.insights.where().findAll();

    // Weekly profiles (4 minggu terakhir)
    final weeklyProfiles = await _db.db.weeklyProfiles
        .filter()
        .weekStartGreaterThan(fourWeeksAgo)
        .findAll();

    // Baseline (single instance)
    final baselines = await _db.db.baselines.where().findAll();

    // Preferences
    final prefs = await _db.db.appPreferences.where().findAll();

    return {
      'version': 1,
      'exportedAt': now.toIso8601String(),
      'insights': insights.map(_insightToMap).toList(),
      'weeklyProfiles': weeklyProfiles.map(_weeklyProfileToMap).toList(),
      'baselines': baselines.map(_baselineToMap).toList(),
      'appPreferences': prefs.map(_prefsToMap).toList(),
    };
  }

  /// Upload bytes ke Drive appDataFolder
  Future<void> _uploadToDrive(String fileName, Uint8List data) async {
    final api = _driveApi!;

    final fileMetadata = drive.File()
      ..name = fileName
      ..parents = [_appDataFolder];

    final stream = Stream.fromIterable(
      [data.sublist(0)].expand((chunk) => [chunk]),
    );

    // googleapis v12: uploadMedia adalah named parameter, bukan positional
    await api.files.create(
      fileMetadata,
      uploadMedia: drive.Media(stream.cast<List<int>>(), data.length),
    );
  }

  // ─────────────────────────── RESTORE ───────────────────────────

  /// Restore dari file backup tertentu (by fileId)
  /// PERINGATAN: Ini MENGGANTI data yang ada, tidak bisa merge.
  Future<bool> restore(String fileId) async {
    final ready = await _ensureInitialized();
    if (!ready || _driveApi == null) {
      debugPrint('[DriveBackupManager] Tidak bisa initialize — restore dibatalkan');
      return false;
    }

    try {
      // 1. Download file dari Drive
      // googleapis v12: downloadOptions adalah named param, bukan positional ke-2
      final media = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final List<int> bytes = [];
      await for (final chunk in media.stream) {
        bytes.addAll(chunk);
      }

      // 2. Ambil encryption key dan initialize EncryptionService
      final encKey = await _keyManager.downloadKey();
      if (encKey == null) {
        debugPrint('[DriveBackupManager] Encryption key tidak ditemukan');
        return false;
      }
      await _encryption.initialize(encKey);

      // 3. Dekripsi (decryptBytes menerima base64 String, return Uint8List)
      final encryptedBase64 = base64Encode(bytes);
      final decrypted = await _encryption.decryptBytes(encryptedBase64);

      // 4. Parse JSON
      final jsonStr = utf8.decode(decrypted);
      final payload = jsonDecode(jsonStr) as Map<String, dynamic>;

      // 5. Restore ke database
      await _restoreFromPayload(payload);

      debugPrint('[DriveBackupManager] Restore berhasil dari file $fileId');
      return true;
    } catch (e, stack) {
      debugPrint('[DriveBackupManager] Restore gagal: $e\n$stack');
      return false;
    }
  }

  /// Restore semua data dari payload JSON ke Isar
  Future<void> _restoreFromPayload(Map<String, dynamic> payload) async {
    await _db.db.writeTxn(() async {
      // Clear data yang akan diganti
      await _db.db.insights.clear();
      await _db.db.weeklyProfiles.clear();
      await _db.db.baselines.clear();
      await _db.db.appPreferences.clear();

      // Restore insights
      final insightsList = (payload['insights'] as List?)
          ?.map((e) => _insightFromMap(e as Map<String, dynamic>))
          .toList() ?? [];
      if (insightsList.isNotEmpty) {
        await _db.db.insights.putAll(insightsList);
      }

      // Restore weekly profiles
      final profilesList = (payload['weeklyProfiles'] as List?)
          ?.map((e) => _weeklyProfileFromMap(e as Map<String, dynamic>))
          .toList() ?? [];
      if (profilesList.isNotEmpty) {
        await _db.db.weeklyProfiles.putAll(profilesList);
      }

      // Restore baselines
      final baselinesList = (payload['baselines'] as List?)
          ?.map((e) => _baselineFromMap(e as Map<String, dynamic>))
          .toList() ?? [];
      if (baselinesList.isNotEmpty) {
        await _db.db.baselines.putAll(baselinesList);
      }

      // Restore preferences
      final prefsList = (payload['appPreferences'] as List?)
          ?.map((e) => _prefsFromMap(e as Map<String, dynamic>))
          .toList() ?? [];
      if (prefsList.isNotEmpty) {
        await _db.db.appPreferences.putAll(prefsList);
      }
    });
  }

  // ─────────────────────────── LIST & DELETE ───────────────────────────

  /// List semua backup yang tersedia di Drive
  Future<List<BackupEntry>> listBackups() async {
    final ready = await _ensureInitialized();
    if (!ready || _driveApi == null) return [];

    try {
      final result = await _driveApi!.files.list(
        spaces: _appDataFolder,
        q: "name contains '$_backupPrefix'",
        // googleapis v12: gunakan $fields (dollar prefix) bukan fields:
        $fields: 'files(id,name,createdTime,size)',
        orderBy: 'createdTime desc',
      );

      return (result.files ?? []).map((f) {
        return BackupEntry(
          fileId: f.id ?? '',
          fileName: f.name ?? '',
          createdAt: f.createdTime ?? DateTime.now(),
          sizeBytes: int.tryParse(f.size ?? '0') ?? 0,
        );
      }).where((e) => e.fileId.isNotEmpty).toList();
    } catch (e) {
      debugPrint('[DriveBackupManager] listBackups gagal: $e');
      return [];
    }
  }

  /// Hapus satu backup dari Drive
  Future<bool> deleteBackup(String fileId) async {
    final ready = await _ensureInitialized();
    if (!ready || _driveApi == null) return false;
    try {
      await _driveApi!.files.delete(fileId);
      debugPrint('[DriveBackupManager] Deleted backup $fileId');
      return true;
    } catch (e) {
      debugPrint('[DriveBackupManager] deleteBackup gagal: $e');
      return false;
    }
  }

  /// Estimasi ukuran backup dalam bytes
  Future<int> estimateBackupSize() async {
    try {
      final payload = await _collectBackupData();
      final json = jsonEncode(payload);
      // Overhead enkripsi ~12% + IV 12 bytes + tag 16 bytes
      return (json.length * 1.15).round() + 28;
    } catch (_) {
      return 0;
    }
  }

  // ─────────────────────────── HELPERS ───────────────────────────

  Future<void> _updateLastBackupDate(DateTime date) async {
    await _db.db.writeTxn(() async {
      final prefs = await _db.db.appPreferences
          .filter()
          .keyEqualTo('app_settings')
          .findFirst();
      if (prefs != null) {
        prefs.lastBackupDate = date;
        prefs.lastUpdated = date;
        await _db.db.appPreferences.put(prefs);
      }
    });
  }

  // ── Serializers ──

  Map<String, dynamic> _insightToMap(Insight i) => {
    'createdAt': i.createdAt.toIso8601String(),
    'category': i.category,
    'templateId': i.templateId,
    'templateParamsJson': i.templateParamsJson,
    'renderedText': i.renderedText,
    'severity': i.severity.name, // string, bukan index — aman saat enum berubah urutan
    'isRead': i.isRead,
    'isDismissed': i.isDismissed,
    'expiresAt': i.expiresAt.toIso8601String(),
    'metadataJson': i.metadataJson,
  };

  Insight _insightFromMap(Map<String, dynamic> m) {
    // Parse severity dari string (backward compat: fallback ke index jika int)
    InsightSeverity parseSeverity(dynamic raw) {
      if (raw is String) {
        return InsightSeverity.values.firstWhere(
          (e) => e.name == raw,
          orElse: () => InsightSeverity.info,
        );
      }
      if (raw is int && raw < InsightSeverity.values.length) {
        return InsightSeverity.values[raw];
      }
      return InsightSeverity.info;
    }

    final insight = Insight()
      ..createdAt = DateTime.parse(m['createdAt'] as String)
      ..category = m['category'] as String
      ..templateId = m['templateId'] as String
      ..templateParamsJson = m['templateParamsJson'] as String?
      ..renderedText = m['renderedText'] as String
      ..severity = parseSeverity(m['severity'])
      ..isRead = m['isRead'] as bool? ?? false
      ..isDismissed = m['isDismissed'] as bool? ?? false
      ..expiresAt = DateTime.parse(m['expiresAt'] as String)
      ..metadataJson = m['metadataJson'] as String?;
    return insight;
  }

  Map<String, dynamic> _weeklyProfileToMap(WeeklyProfile w) => {
    'weekStart': w.weekStart.toIso8601String(),
    'totalScreenTimeSeconds': w.totalScreenTimeSeconds,
    'averageDailyScreenTimeSeconds': w.averageDailyScreenTimeSeconds,
    'averageFocusScore': w.averageFocusScore,
    'totalDistractions': w.totalDistractions,
    'topAppsJson': w.topAppsJson,
    'dayCount': w.dayCount,
    'peakActivityDay': w.peakActivityDay,
    'lowestActivityDay': w.lowestActivityDay,
    'dailyPatternsJson': w.dailyPatternsJson,
    'topDistractions': w.topDistractions,
    'createdAt': w.createdAt?.toIso8601String(),
    'expiresAt': w.expiresAt?.toIso8601String(),
  };

  WeeklyProfile _weeklyProfileFromMap(Map<String, dynamic> m) => WeeklyProfile(
    weekStart: DateTime.parse(m['weekStart'] as String),
    totalScreenTimeSeconds: m['totalScreenTimeSeconds'] as int,
    averageDailyScreenTimeSeconds: m['averageDailyScreenTimeSeconds'] as int,
    averageFocusScore: (m['averageFocusScore'] as num).toDouble(),
    totalDistractions: m['totalDistractions'] as int,
    dayCount: m['dayCount'] as int,
    peakActivityDay: m['peakActivityDay'] as String? ?? '',
    lowestActivityDay: m['lowestActivityDay'] as String? ?? '',
    topDistractions: List<String>.from(m['topDistractions'] as List? ?? []),
    createdAt: m['createdAt'] != null ? DateTime.parse(m['createdAt'] as String) : null,
    expiresAt: m['expiresAt'] != null ? DateTime.parse(m['expiresAt'] as String) : null,
  )..topAppsJson = m['topAppsJson'] as String?
   ..dailyPatternsJson = m['dailyPatternsJson'] as String?;

  Map<String, dynamic> _baselineToMap(Baseline b) => {
    'key': b.key,
    'avgDailyScreenTime': b.avgDailyScreenTime,
    'avgFocusScore': b.avgFocusScore,
    'avgDistractionScore': b.avgDistractionScore,
    'avgUnlockCount': b.avgUnlockCount,
    'hourlyActivityPatternJson': b.hourlyActivityPatternJson,
    'weekdayPatternsJson': b.weekdayPatternsJson,
    'categoryBaselinesJson': b.categoryBaselinesJson,
    'lastUpdated': b.lastUpdated.toIso8601String(),
    'dataPointsCount': b.dataPointsCount,
  };

  Baseline _baselineFromMap(Map<String, dynamic> m) {
    final b = Baseline()
      ..key = m['key'] as String? ?? 'global_baseline'
      ..avgDailyScreenTime = (m['avgDailyScreenTime'] as num).toDouble()
      ..avgFocusScore = (m['avgFocusScore'] as num).toDouble()
      ..avgDistractionScore = (m['avgDistractionScore'] as num).toDouble()
      ..avgUnlockCount = m['avgUnlockCount'] as int
      ..hourlyActivityPatternJson = m['hourlyActivityPatternJson'] as String?
      ..weekdayPatternsJson = m['weekdayPatternsJson'] as String?
      ..categoryBaselinesJson = m['categoryBaselinesJson'] as String?
      ..lastUpdated = DateTime.parse(m['lastUpdated'] as String)
      ..dataPointsCount = m['dataPointsCount'] as int;
    return b;
  }

  Map<String, dynamic> _prefsToMap(AppPreferences p) => {
    'key': p.key,
    'notificationsEnabled': p.notificationsEnabled,
    'dailySummaryEnabled': p.dailySummaryEnabled,
    'weeklyReportEnabled': p.weeklyReportEnabled,
    'dataCollectionEnabled': p.dataCollectionEnabled,
    'analyticsEnabled': p.analyticsEnabled,
    'languageCode': p.languageCode,
    'useDarkMode': p.useDarkMode,
    'onboardingCompleted': p.onboardingCompleted,
    'onboardingLastVersion': p.onboardingLastVersion,
    'backupEnabled': p.backupEnabled,
    'lastBackupDate': p.lastBackupDate?.toIso8601String(),
    'lastUpdated': p.lastUpdated.toIso8601String(),
  };

  AppPreferences _prefsFromMap(Map<String, dynamic> m) {
    final p = AppPreferences()
      ..key = m['key'] as String? ?? 'app_settings'
      ..notificationsEnabled = m['notificationsEnabled'] as bool? ?? true
      ..dailySummaryEnabled = m['dailySummaryEnabled'] as bool? ?? true
      ..weeklyReportEnabled = m['weeklyReportEnabled'] as bool? ?? true
      ..dataCollectionEnabled = m['dataCollectionEnabled'] as bool? ?? true
      ..analyticsEnabled = m['analyticsEnabled'] as bool? ?? false
      ..languageCode = m['languageCode'] as String? ?? 'id'
      ..useDarkMode = m['useDarkMode'] as bool? ?? true
      ..onboardingCompleted = m['onboardingCompleted'] as bool? ?? false
      ..onboardingLastVersion = m['onboardingLastVersion'] as int?
      ..backupEnabled = m['backupEnabled'] as bool? ?? false
      ..lastBackupDate = m['lastBackupDate'] != null
          ? DateTime.parse(m['lastBackupDate'] as String)
          : null
      ..lastUpdated = DateTime.parse(m['lastUpdated'] as String);
    return p;
  }
}
