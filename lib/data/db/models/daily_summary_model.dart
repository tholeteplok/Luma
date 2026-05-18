import 'package:isar/isar.dart';

part 'daily_summary.g.dart';

@collection
class DailySummary {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late int totalScreenTimeSeconds;
  
  // App usage breakdown (packageName -> minutes)
  late Map<String, int> appUsageMinutes;
  
  // Top 5 apps dengan duration tertinggi
  late List<Map<String, dynamic>> topApps;
  
  // Screen state counts
  late int screenOnCount;
  late int screenOffCount;
  
  // Metrics
  late double focusScore; // 0-100
  late int distractionCount;
  
  @Index()
  late DateTime createdAt;
  
  @Index()
  late DateTime expiresAt; // Untuk fade granularity
  
  /// Constructor dengan default values
  DailySummary({
    required this.date,
    required this.totalScreenTimeSeconds,
    required this.appUsageMinutes,
    required this.topApps,
    required this.screenOnCount,
    required this.screenOffCount,
    required this.focusScore,
    required this.distractionCount,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    // Default expiresAt: 28 hari dari date (sesuai retention policy)
    this.expiresAt = expiresAt ?? date.add(const Duration(days: 28));
  }
}
