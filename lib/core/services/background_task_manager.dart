import 'package:flutter/widgets.dart';

import 'package:workmanager/workmanager.dart';
import '../../data/tracking/event_aggregator.dart';
import '../../data/tracking/usage_stats_service.dart';
import '../platform/screen_state_listener.dart';
import '../../data/db/database_service.dart';

/// Background task names
class BackgroundTasks {
  static const String aggregateEvents = 'com.luma.app.aggregate_events';
  static const String generateDailySummary = 'com.luma.app.daily_summary';
  static const String generateWeeklyProfile = 'com.luma.app.weekly_profile';
  static const String cleanupExpiredData = 'com.luma.app.cleanup_data';
  static const String weeklyBackup = 'com.luma.app.weekly_backup';
}

/// Callback dispatcher untuk WorkManager
/// HARUS top-level function, bukan method di class
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Background task executed: $task');
    
    // Pastikan WidgetsBinding terinisialisasi untuk background isolate
    WidgetsFlutterBinding.ensureInitialized();
    
    // Inisialisasi DatabaseService secara terpisah dalam isolate background ini
    final dbService = DatabaseService();
    await dbService.init();
    
    try {
      switch (task) {
        case BackgroundTasks.aggregateEvents:
          await _aggregateEventsTask(dbService);
          break;
        case BackgroundTasks.generateDailySummary:
          await _generateDailySummaryTask(dbService);
          break;
        case BackgroundTasks.generateWeeklyProfile:
          await _generateWeeklyProfileTask(dbService);
          break;
        case BackgroundTasks.cleanupExpiredData:
          await _cleanupExpiredDataTask(dbService);
          break;
        case BackgroundTasks.weeklyBackup:
          // Backup dieksekusi via DriveBackupManager di dalam app session
          // Background isolate hanya log — backup penuh butuh auth token aktif
          debugPrint('[BackgroundTask] Weekly backup triggered — waiting for foreground execution');
          break;
        default:
          debugPrint('Unknown task: $task');
      }
      return true;
    } catch (e, stackTrace) {
      debugPrint('Task $task failed: $e\n$stackTrace');
      return false;
    }
  });
}

/// Task 1: Aggregate raw events menjadi metrics
Future<void> _aggregateEventsTask(DatabaseService dbService) async {
  final aggregator = EventAggregator(
    db: dbService,
    usageStats: UsageStatsService(),
    screenListener: ScreenStateListener(),
  );
  
  // Get unaggregated events dari 1 jam terakhir
  final now = DateTime.now();
  final oneHourAgo = now.subtract(const Duration(hours: 1));
  
  final unaggregatedEvents = await dbService.getRawEventsBetween(
    oneHourAgo,
    now,
  );
  
  if (unaggregatedEvents.isEmpty) {
    debugPrint('No unaggregated events found');
    return;
  }
  
  // Aggregate by app
  final aggregated = await aggregator.aggregateByApp(unaggregatedEvents);
  
  // Save aggregated metrics
  for (final metric in aggregated) {
    await dbService.saveDailyMetric(metric);
  }
  
  debugPrint('Aggregated ${aggregated.length} app sessions');
}

/// Task 2: Generate daily summary
Future<void> _generateDailySummaryTask(DatabaseService dbService) async {
  final aggregator = EventAggregator(
    db: dbService,
    usageStats: UsageStatsService(),
    screenListener: ScreenStateListener(),
  );
  
  // Get yesterday's date
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final startOfYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
  
  // Check if summary already exists
  final existingSummary = await dbService.getDailySummaryByDate(startOfYesterday);
  if (existingSummary != null) {
    debugPrint('Daily summary already exists for ${startOfYesterday.toIso8601String()}');
    return;
  }
  
  // Generate and save daily summary menggunakan arsitektur terpusat EventAggregator
  final summary = await aggregator.aggregateDay(yesterday);
  
  if (summary != null) {
    debugPrint('Generated daily summary for ${startOfYesterday.toIso8601String()}');
  } else {
    debugPrint('No events found for yesterday to generate summary');
  }
}

/// Task 3: Generate weekly profile
Future<void> _generateWeeklyProfileTask(DatabaseService dbService) async {
  final aggregator = EventAggregator(
    db: dbService,
    usageStats: UsageStatsService(),
    screenListener: ScreenStateListener(),
  );
  
  // Get last 7 days
  final now = DateTime.now();
  final sevenDaysAgo = now.subtract(const Duration(days: 7));
  
  // Get daily summaries for last 7 days
  final summaries = await dbService.getDailySummariesBetween(sevenDaysAgo, now);
  
  if (summaries.length < 4) {
    debugPrint('Not enough daily summaries to generate weekly profile (${summaries.length}/4)');
    return;
  }
  
  // Generate weekly profile
  final profile = await aggregator.generateWeeklyProfile(summaries);
  
  // Save profile
  await dbService.saveWeeklyProfile(profile);
  
  debugPrint('Generated weekly profile ending ${now.toIso8601String()}');
}

/// Task 4: Cleanup expired data based on fade granularity
Future<void> _cleanupExpiredDataTask(DatabaseService dbService) async {
  final now = DateTime.now();
  final sevenDaysAgo = now.subtract(const Duration(days: 7));
  final twentyEightDaysAgo = now.subtract(const Duration(days: 28));
  
  // Delete raw events older than 7 days
  final deletedRawEvents = await dbService.deleteRawEventsOlderThan(sevenDaysAgo);
  debugPrint('Deleted $deletedRawEvents raw events older than 7 days');
  
  // Delete daily summaries older than 28 days
  final deletedDailySummaries = await dbService.deleteDailySummariesOlderThan(twentyEightDaysAgo);
  debugPrint('Deleted $deletedDailySummaries daily summaries older than 28 days');
  
  // Delete weekly profiles older than 4 weeks (112 days)
  final oneHundredTwelveDaysAgo = now.subtract(const Duration(days: 112));
  final deletedWeeklyProfiles = await dbService.deleteWeeklyProfilesOlderThan(oneHundredTwelveDaysAgo);
  debugPrint('Deleted $deletedWeeklyProfiles weekly profiles older than 112 days');
}

/// Initialize background tasks
class BackgroundTaskInitializer {
  /// Initialize WorkManager dengan periodic tasks
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
    );
    
    // Register periodic tasks
    await registerPeriodicTasks();
    
    debugPrint('Background tasks initialized');
  }
  
  /// Register semua periodic tasks
  static Future<void> registerPeriodicTasks() async {
    // Cancel all existing tasks first
    await Workmanager().cancelAll();
    
    // Task 1: Aggregate events setiap jam (hanya saat charging)
    await Workmanager().registerPeriodicTask(
      BackgroundTasks.aggregateEvents,
      BackgroundTasks.aggregateEvents,
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
        requiresCharging: true,
        requiresDeviceIdle: true,
      ),
    );
    
    // Task 2: Generate daily summary setiap hari jam 23:00
    await Workmanager().registerPeriodicTask(
      BackgroundTasks.generateDailySummary,
      BackgroundTasks.generateDailySummary,
      frequency: const Duration(days: 1),
      initialDelay: const Duration(hours: 23),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
        requiresCharging: false,
      ),
    );
    
    // Task 3: Generate weekly profile setiap Senin 00:00
    await Workmanager().registerPeriodicTask(
      BackgroundTasks.generateWeeklyProfile,
      BackgroundTasks.generateWeeklyProfile,
      frequency: const Duration(days: 7),
      initialDelay: const Duration(hours: 1), // Start shortly after midnight
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
        requiresCharging: false,
      ),
    );
    
    // Task 4: Cleanup expired data setiap hari jam 03:00
    await Workmanager().registerPeriodicTask(
      BackgroundTasks.cleanupExpiredData,
      BackgroundTasks.cleanupExpiredData,
      frequency: const Duration(days: 1),
      initialDelay: const Duration(hours: 3),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
      ),
    );
  }
  
  /// Daftarkan weekly backup task (setiap Minggu, charging + WiFi)
  static Future<void> registerWeeklyBackupTask() async {
    await Workmanager().registerPeriodicTask(
      BackgroundTasks.weeklyBackup,
      BackgroundTasks.weeklyBackup,
      frequency: const Duration(days: 7),
      initialDelay: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
        requiresCharging: true,
      ),
    );
    debugPrint('[BackgroundTaskInitializer] Weekly backup task registered');
  }

  /// Batalkan weekly backup task
  static Future<void> cancelWeeklyBackupTask() async {
    await Workmanager().cancelByUniqueName(BackgroundTasks.weeklyBackup);
    debugPrint('[BackgroundTaskInitializer] Weekly backup task cancelled');
  }

  /// Cancel semua background tasks
  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
    debugPrint('All background tasks cancelled');
  }

  /// Trigger manual run untuk testing
  static Future<void> triggerManualTask(String taskName) async {
    await Workmanager().registerOneOffTask(
      'manual_$taskName',
      taskName,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );
    debugPrint('Manual task triggered: $taskName');
  }
}

// ──────────────────────────────────────────────────────────────
// Static permission helpers (untuk PermissionGatewayPage)
// ──────────────────────────────────────────────────────────────

/// Proxy statis agar UI tidak perlu inject UsageStatsService secara penuh.
class BackgroundTaskManager {
  static final _usageStats = UsageStatsService();

  /// Cek apakah PACKAGE_USAGE_STATS sudah diberikan
  static Future<bool> hasUsageStatsPermission() =>
      _usageStats.hasUsageStatsPermission();

  /// Buka halaman Usage Access Settings di Android
  static Future<void> openUsageAccessSettings() =>
      _usageStats.openAppSettings();
}

