import 'package:isar/isar.dart';

part 'daily_app_metric.g.dart';

/// Metric agregat untuk penggunaan aplikasi per hari
/// Dibuat oleh EventAggregator setiap jam saat charging
@collection
class DailyAppMetric {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date; // Normalized to start of day

  @Index()
  late String packageName;

  late int totalDurationSeconds;
  late int sessionCount;
  late int firstUseHour; // Jam pertama digunakan (0-23)
  late int lastUseHour; // Jam terakhir digunakan (0-23)
  
  // Derived metrics
  late double averageSessionDuration; // seconds
  late bool isMorningApp; // Digunakan sebelum jam 12
  late bool isNightApp; // Digunakan setelah jam 21
  
  @Index()
  DateTime? createdAt;

  DailyAppMetric({
    required this.date,
    required this.packageName,
    required this.totalDurationSeconds,
    required this.sessionCount,
    required this.firstUseHour,
    required this.lastUseHour,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    averageSessionDuration = sessionCount > 0 
        ? totalDurationSeconds / sessionCount 
        : 0.0;
    isMorningApp = firstUseHour < 12;
    isNightApp = lastUseHour >= 21;
  }
}
