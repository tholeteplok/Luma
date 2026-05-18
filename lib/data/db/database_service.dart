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
