import 'package:usage_stats/usage_stats.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:luma/data/db/models/event_type.dart';
import 'package:luma/data/db/models/raw_event.dart';
import 'package:luma/core/platform/screen_state_listener.dart';
import 'package:logging/logging.dart';

/// Service untuk mengumpulkan data penggunaan aplikasi dari Android UsageStats API.
/// 
/// Memerlukan permission PACKAGE_USAGE_STATS yang harus di-grant manual oleh user
/// melalui Settings > Apps > Luma > App Usage Access.
class UsageStatsService {
  static final _log = Logger('UsageStatsService');

  /// Cek apakah permission usage stats sudah diberikan
  Future<bool> hasUsageStatsPermission() async {
    try {
      final status = await Permission.usageStats.status;
      return status.isGranted;
    } catch (e) {
      _log.warning('Error checking usage stats permission: $e');
      return false;
    }
  }

  /// Request permission usage stats
  /// Returns true jika granted, false jika denied/permanently denied
  Future<bool> requestUsageStatsPermission() async {
    try {
      final status = await Permission.usageStats.request();
      
      if (status.isGranted) {
        _log.info('Usage stats permission granted');
        return true;
      } else if (status.isDenied) {
        _log.warning('Usage stats permission denied - user needs to grant manually in settings');
        return false;
      } else if (status.isPermanentlyDenied) {
        _log.severe('Usage stats permission permanently denied - redirect to settings');
        return false;
      }
      
      return false;
    } catch (e) {
      _log.severe('Error requesting usage stats permission: $e');
      return false;
    }
  }

  /// Redirect user ke settings page untuk grant permission manual
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Ambil daftar aplikasi yang digunakan dalam rentang waktu tertentu
  /// 
  /// [duration] - Durasi ke belakang dari sekarang (default: 1 jam)
  /// Returns list of [RawEvent] dengan tipe EventType.app_usage
  Future<List<RawEvent>> getRecentAppUsage({Duration duration = const Duration(hours: 1)}) async {
    try {
      if (!await hasUsageStatsPermission()) {
        _log.warning('Cannot get app usage - permission not granted');
        return [];
      }

      final now = DateTime.now();
      final startTime = now.subtract(duration);
      
      // Query usage stats untuk periode tertentu
      final usageList = await UsageStats.queryUsage(
        startTime.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );

      if (usageList.isEmpty) {
        _log.fine('No app usage data found for the specified period');
        return [];
      }

      // Convert ke RawEvent
      final events = <RawEvent>[];
      for (final usage in usageList) {
        // Skip aplikasi sistem dan Luma sendiri
        if (_isSystemApp(usage.packageName) || usage.packageName == 'luma') {
          continue;
        }

        // Hitung total durasi penggunaan
        final totalDuration = usage.totalTimeInForeground;
        
        if (totalDuration > 0) {
          events.add(RawEvent(
            timestamp: now,
            type: EventType.app_usage,
            packageName: usage.packageName,
            appName: usage.appName ?? usage.packageName,
            durationSeconds: (totalDuration / 1000).round(), // Convert ms to seconds
            isForeground: true,
            metadata: {
              'last_time_used': usage.lastTimeUsed,
              'total_time_in_foreground': totalDuration,
            },
          ));
        }
      }

      _log.info('Retrieved ${events.length} app usage events');
      return events;
    } catch (e) {
      _log.severe('Error getting recent app usage: $e');
      return [];
    }
  }

  /// Ambil aplikasi yang sedang aktif saat ini (foreground)
  /// Returns [RawEvent] atau null jika tidak ada aplikasi foreground
  Future<RawEvent?> getCurrentForegroundApp() async {
    try {
      if (!await hasUsageStatsPermission()) {
        return null;
      }

      // Query untuk 5 detik terakhir untuk mendapatkan aplikasi paling baru
      final now = DateTime.now();
      final startTime = now.subtract(const Duration(seconds: 5));
      
      final usageList = await UsageStats.queryUsage(
        startTime.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );

      if (usageList.isEmpty) {
        return null;
      }

      // Ambil aplikasi dengan lastTimeUsed paling baru
      usageList.sort((a, b) => b.lastTimeUsed.compareTo(a.lastTimeUsed));
      final latestApp = usageList.first;

      // Skip sistem dan Luma
      if (_isSystemApp(latestApp.packageName) || latestApp.packageName == 'luma') {
        return null;
      }

      return RawEvent(
        timestamp: now,
        type: EventType.app_usage,
        packageName: latestApp.packageName,
        appName: latestApp.appName ?? latestApp.packageName,
        durationSeconds: 0, // Instant snapshot
        isForeground: true,
        metadata: {
          'snapshot': true,
        },
      );
    } catch (e) {
      _log.severe('Error getting current foreground app: $e');
      return null;
    }
  }

  /// Cek apakah package adalah aplikasi sistem
  bool _isSystemApp(String packageName) {
    // Daftar package sistem yang umum di-skip
    final systemPackages = [
      'android',
      'com.android.systemui',
      'com.google.android.gms',
      'com.google.android.gsf',
      'com.android.phone',
      'com.android.settings',
      'com.sec.android.app.launcher', // Samsung
      'com.oneplus.launcher', // OnePlus
      'com.miui.home', // Xiaomi
      'com.oplus.launcher', // Oppo
      'com.vivo.launcher', // Vivo
    ];

    return systemPackages.any((pkg) => packageName.startsWith(pkg));
  }

  /// Get top apps berdasarkan total waktu penggunaan
  /// Returns map dengan package name sebagai key dan total duration (seconds) sebagai value
  Future<Map<String, int>> getTopApps({Duration duration = const Duration(days: 1), int limit = 10}) async {
    try {
      if (!await hasUsageStatsPermission()) {
        return {};
      }

      final now = DateTime.now();
      final startTime = now.subtract(duration);
      
      final usageList = await UsageStats.queryUsage(
        startTime.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );

      // Filter dan aggregate
      final appDurations = <String, int>{};
      for (final usage in usageList) {
        if (_isSystemApp(usage.packageName) || usage.packageName == 'luma') {
          continue;
        }

        final totalSeconds = (usage.totalTimeInForeground / 1000).round();
        if (totalSeconds > 0) {
          appDurations[usage.packageName] = (appDurations[usage.packageName] ?? 0) + totalSeconds;
        }
      }

      // Sort by duration descending dan ambil top N
      final sorted = Map.fromEntries(
        appDurations.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value))
      );

      if (sorted.length <= limit) {
        return sorted;
      }

      return Map.fromEntries(sorted.entries.take(limit));
    } catch (e) {
      _log.severe('Error getting top apps: $e');
      return {};
    }
  }
}
