import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Isar? _db;

  Future<void> init() async {
    if (_db != null) return;

    final dir = await getApplicationDocumentsDirectory();
    
    _db = await Isar.open(
      [
        RawEventSchema,
        DailySummarySchema,
        DailyAppMetricSchema,
        WeeklyProfileSchema,
        BaselineSchema,
        InsightSchema,
        AppPreferencesSchema,
      ],
      directory: dir.path,
    );

    debugPrint('Database initialized at ${dir.path}');
  }

  Isar get db {
    if (_db == null) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _db!;
  }

  // ==================== RAW EVENTS ====================

  /// Save raw event ke database
  Future<void> saveRawEvent(RawEvent event) async {
    await db.writeTxn(() async {
      await db.rawEvents.put(event);
    });
  }

  /// Save multiple raw events
  Future<void> saveRawEvents(List<RawEvent> events) async {
    await db.writeTxn(() async {
      await db.rawEvents.putAll(events);
    });
  }

  /// Get raw events dalam rentang waktu tertentu
  Future<List<RawEvent>> getRawEvents({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    return await db.rawEvents
        .filter()
        .timestampBetween(startTime, endTime)
        .findAll();
  }

  /// Get raw events between two dates (alias for getRawEvents)
  Future<List<RawEvent>> getRawEventsBetween(DateTime start, DateTime end) async {
    return await getRawEvents(startTime: start, endTime: end);
  }

  /// Get raw events untuk package tertentu dalam rentang waktu
  Future<List<RawEvent>> getRawEventsByPackage({
    required String packageName,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    return await db.rawEvents
        .filter()
        .packageNameEqualTo(packageName)
        .and()
        .timestampBetween(startTime, endTime)
        .findAll();
  }

  /// Delete raw event by id
  Future<void> deleteRawEvent(Id id) async {
    await db.rawEvents.delete(id);
  }

  // ==================== DAILY SUMMARIES ====================

  /// Save daily summary
  Future<void> saveDailySummary(DailySummary summary) async {
    await db.writeTxn(() async {
      // Check if already exists for this date
      final existing = await db.dailySummarys
          .filter()
          .dateEqualTo(summary.date)
          .findFirst();
      
      if (existing != null) {
        // Update existing
        summary.id = existing.id;
      }
      
      await db.dailySummarys.put(summary);
    });
  }

  /// Get daily summary untuk tanggal tertentu
  Future<DailySummary?> getDailySummary(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return await db.dailySummarys
        .filter()
        .dateEqualTo(normalizedDate)
        .findFirst();
  }

  /// Get daily summaries dalam rentang waktu
  Future<List<DailySummary>> getDailySummaries({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    return await db.dailySummarys
        .filter()
        .dateBetween(startTime, endTime)
        .findAll();
  }

  /// Get daily summary by date (alias for getDailySummary)
  Future<DailySummary?> getDailySummaryByDate(DateTime date) async {
    return await getDailySummary(date);
  }

  /// Get daily summaries between two dates (alias for getDailySummaries)
  Future<List<DailySummary>> getDailySummariesBetween(DateTime start, DateTime end) async {
    return await getDailySummaries(startTime: start, endTime: end);
  }

  // ==================== WEEKLY PROFILES ====================

  /// Save weekly profile
  Future<void> saveWeeklyProfile(WeeklyProfile profile) async {
    await db.writeTxn(() async {
      await db.weeklyProfiles.put(profile);
    });
  }

  /// Get weekly profile for specific week start date
  Future<WeeklyProfile?> getWeeklyProfile(DateTime weekStart) async {
    final normalizedDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    return await db.weeklyProfiles
        .filter()
        .weekStartEqualTo(normalizedDate)
        .findFirst();
  }

  /// Get weekly profiles in date range
  Future<List<WeeklyProfile>> getWeeklyProfilesBetween(DateTime start, DateTime end) async {
    return await db.weeklyProfiles
        .filter()
        .weekStartBetween(start, end)
        .findAll();
  }

  // ==================== DAILY METRICS (AGGREGATED) ====================

  /// Save daily metric (aggregated app usage)
  Future<void> saveDailyMetric(DailyAppMetric metric) async {
    await db.writeTxn(() async {
      await db.dailyAppMetrics.put(metric);
    });
  }

  /// Get daily metrics for a specific date
  Future<List<DailyAppMetric>> getDailyMetricsForDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return await db.dailyAppMetrics
        .filter()
        .dateEqualTo(normalizedDate)
        .findAll();
  }

  // ==================== CLEANUP ====================

  /// Delete raw events older than specified date
  Future<int> deleteRawEventsOlderThan(DateTime date) async {
    final expiredEvents = await db.rawEvents
        .filter()
        .timestampLessThan(date)
        .findAll();
    
    if (expiredEvents.isNotEmpty) {
      await db.rawEvents.deleteAll(expiredEvents.map((e) => e.id).toList());
      return expiredEvents.length;
    }
    return 0;
  }

  /// Delete daily summaries older than specified date
  Future<int> deleteDailySummariesOlderThan(DateTime date) async {
    final expiredSummaries = await db.dailySummarys
        .filter()
        .dateLessThan(date)
        .findAll();
    
    if (expiredSummaries.isNotEmpty) {
      await db.dailySummarys.deleteAll(expiredSummaries.map((e) => e.id).toList());
      return expiredSummaries.length;
    }
    return 0;
  }

  /// Delete weekly profiles older than specified date
  Future<int> deleteWeeklyProfilesOlderThan(DateTime date) async {
    final expiredProfiles = await db.weeklyProfiles
        .filter()
        .weekStartLessThan(date)
        .findAll();
    
    if (expiredProfiles.isNotEmpty) {
      await db.weeklyProfiles.deleteAll(expiredProfiles.map((e) => e.id).toList());
      return expiredProfiles.length;
    }
    return 0;
  }

  // Helper methods untuk cleanup berdasarkan fade granularity
  Future<void> cleanupExpiredData() async {
    final now = DateTime.now();
    
    await db.writeTxn(() async {
      // Hapus raw_event yang sudah expired (>7 hari)
      final expiredRawEvents = await db.rawEvents
          .filter()
          .expiresAtLessThan(now)
          .findAll();
      
      if (expiredRawEvents.isNotEmpty) {
        await db.rawEvents.deleteAll(expiredRawEvents.map((e) => e.id).toList());
        debugPrint('Deleted ${expiredRawEvents.length} expired raw events');
      }

      // Hapus daily_summary yang sudah expired (>28 hari)
      final expiredDailySummaries = await db.dailySummarys
          .filter()
          .expiresAtLessThan(now)
          .findAll();
      
      if (expiredDailySummaries.isNotEmpty) {
        await db.dailySummarys.deleteAll(expiredDailySummaries.map((e) => e.id).toList());
        debugPrint('Deleted ${expiredDailySummaries.length} expired daily summaries');
      }

      // Hapus weekly_profile yang sudah expired (>4 minggu)
      final expiredWeeklyProfiles = await db.weeklyProfiles
          .filter()
          .expiresAtLessThan(now)
          .findAll();
      
      if (expiredWeeklyProfiles.isNotEmpty) {
        await db.weeklyProfiles.deleteAll(expiredWeeklyProfiles.map((e) => e.id).toList());
        debugPrint('Deleted ${expiredWeeklyProfiles.length} expired weekly profiles');
      }
    });
  }

  // Get collection stats untuk debugging
  Map<String, int> getCollectionStats() {
    return {
      'raw_events': db.rawEvents.countSync(),
      'daily_summaries': db.dailySummarys.countSync(),
      'weekly_profiles': db.weeklyProfiles.countSync(),
      'baselines': db.baselines.countSync(),
      'insights': db.insights.countSync(),
      'app_preferences': db.appPreferences.countSync(),
    };
  }
}
