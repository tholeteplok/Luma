import 'package:workmanager/workmanager.dart';
import '../tracking/event_aggregator.dart';
import '../db/database_service.dart';
import 'package:flutter/foundation.dart';

/// Background task names
class BackgroundTasks {
  static const String aggregateEvents = 'com.luma.app.aggregate_events';
  static const String generateDailySummary = 'com.luma.app.daily_summary';
  static const String generateWeeklyProfile = 'com.luma.app.weekly_profile';
  static const String cleanupExpiredData = 'com.luma.app.cleanup_data';
}

/// Callback dispatcher untuk WorkManager
/// HARUS top-level function, bukan method di class
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Background task executed: $task');
    
    try {
      switch (task) {
        case BackgroundTasks.aggregateEvents:
          await _aggregateEventsTask();
          break;
        case BackgroundTasks.generateDailySummary:
          await _generateDailySummaryTask();
          break;
        case BackgroundTasks.generateWeeklyProfile:
          await _generateWeeklyProfileTask();
          break;
        case BackgroundTasks.cleanupExpiredData:
          await _cleanupExpiredDataTask();
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
Future<void> _aggregateEventsTask() async {
  final aggregator = EventAggregator();
  final dbService = DatabaseService.instance;
  
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
Future<void> _generateDailySummaryTask() async {
  final aggregator = EventAggregator();
  final dbService = DatabaseService.instance;
  
  // Get yesterday's date range
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final startOfYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
  final endOfYesterday = startOfYesterday.add(const Duration(days: 1));
  
  // Check if summary already exists
  final existingSummary = await dbService.getDailySummaryByDate(startOfYesterday);
  if (existingSummary != null) {
    debugPrint('Daily summary already exists for ${startOfYesterday.toIso8601String()}');
    return;
  }
  
  // Get all events from yesterday
  final events = await dbService.getRawEventsBetween(startOfYesterday, endOfYesterday);
  
  if (events.isEmpty) {
    debugPrint('No events found for yesterday');
    return;
  }
  
  // Generate summary
  final summary = await aggregator.generateDailySummary(events);
  
  // Save summary
  await dbService.saveDailySummary(summary);
  
  debugPrint('Generated daily summary for ${startOfYesterday.toIso8601String()}');
}

/// Task 3: Generate weekly profile
Future<void> _generateWeeklyProfileTask() async {
  final aggregator = EventAggregator();
  final dbService = DatabaseService.instance;
  
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
Future<void> _cleanupExpiredDataTask() async {
  final dbService = DatabaseService.instance;
  
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
      isInDebugMode: kDebugMode,
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
      constraints: Workmanager.Constraints(
        networkType: NetworkType.not_required,
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
      constraints: Workmanager.Constraints(
        networkType: NetworkType.not_required,
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
      constraints: Workmanager.Constraints(
        networkType: NetworkType.not_required,
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
      constraints: Workmanager.Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
      ),
    );
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
      constraints: const Workmanager.Constraints(
        networkType: NetworkType.not_required,
      ),
    );
    debugPrint('Manual task triggered: $taskName');
  }
}
