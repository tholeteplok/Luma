import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

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
        WeeklyProfileSchema,
        BaselineSchema,
        InsightSchema,
        AppPreferencesSchema,
      ],
      directory: dir.path,
    );

    print('Database initialized at ${dir.path}');
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
      final existing = await db.dailySummaries
          .filter()
          .dateEqualTo(summary.date)
          .findFirst();
      
      if (existing != null) {
        // Update existing
        summary.id = existing.id;
      }
      
      await db.dailySummaries.put(summary);
    });
  }

  /// Get daily summary untuk tanggal tertentu
  Future<DailySummary?> getDailySummary(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return await db.dailySummaries
        .filter()
        .dateEqualTo(normalizedDate)
        .findFirst();
  }

  /// Get daily summaries dalam rentang waktu
  Future<List<DailySummary>> getDailySummaries({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    return await db.dailySummaries
        .filter()
        .dateBetween(startTime, endTime)
        .findAll();
  }

  // ==================== CLEANUP ====================

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
        await db.rawEvents.deleteAll(expiredRawEvents.map((e) => e.id));
        print('Deleted ${expiredRawEvents.length} expired raw events');
      }

      // Hapus daily_summary yang sudah expired (>28 hari)
      final expiredDailySummaries = await db.dailySummaries
          .filter()
          .expiresAtLessThan(now)
          .findAll();
      
      if (expiredDailySummaries.isNotEmpty) {
        await db.dailySummaries.deleteAll(expiredDailySummaries.map((e) => e.id));
        print('Deleted ${expiredDailySummaries.length} expired daily summaries');
      }

      // Hapus weekly_profile yang sudah expired (>4 minggu)
      final expiredWeeklyProfiles = await db.weeklyProfiles
          .filter()
          .expiresAtLessThan(now)
          .findAll();
      
      if (expiredWeeklyProfiles.isNotEmpty) {
        await db.weeklyProfiles.deleteAll(expiredWeeklyProfiles.map((e) => e.id));
        print('Deleted ${expiredWeeklyProfiles.length} expired weekly profiles');
      }
    });
  }

  // Get collection stats untuk debugging
  Map<String, int> getCollectionStats() {
    return {
      'raw_events': db.rawEvents.countSync(),
      'daily_summaries': db.dailySummaries.countSync(),
      'weekly_profiles': db.weeklyProfiles.countSync(),
      'baselines': db.baselines.countSync(),
      'insights': db.insights.countSync(),
      'app_preferences': db.appPreferences.countSync(),
    };
  }
}
