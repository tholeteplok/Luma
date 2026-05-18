import 'package:isar/isar.dart';

part 'baseline.g.dart';

@collection
class Baseline {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String key = 'global_baseline'; // Single instance

  // Long-term averages (updated continuously)
  late double avgDailyScreenTime;
  late double avgFocusScore;
  late double avgDistractionScore;
  late int avgUnlockCount;

  // Circadian patterns
  late Map<int, double> hourlyActivityPattern; // hour (0-23) -> activityLevel

  // Weekly patterns
  late Map<String, double> weekdayPatterns; // dayName -> avgScore

  // App categories baseline
  late Map<String, double> categoryBaselines; // category -> % of screen time

  @Index()
  late DateTime lastUpdated;

  @Index()
  late int dataPointsCount; // Number of days used for baseline
}
