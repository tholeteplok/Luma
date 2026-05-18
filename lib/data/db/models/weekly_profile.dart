import 'package:isar/isar.dart';

part 'weekly_profile.g.dart';

@collection
class WeeklyProfile {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime weekStart; // Start of week (Monday)

  late int totalScreenTimeSeconds;
  late int averageDailyScreenTimeSeconds;
  late double averageFocusScore;
  late int totalDistractions;
  
  // Top apps untuk minggu ini
  late List<Map<String, dynamic>> topApps;
  
  // Number of days with data
  late int dayCount;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime expiresAt; // Untuk fade granularity (112 hari / 4 minggu)

  WeeklyProfile({
    required this.weekStart,
    required this.totalScreenTimeSeconds,
    required this.averageDailyScreenTimeSeconds,
    required this.averageFocusScore,
    required this.totalDistractions,
    required this.topApps,
    required this.dayCount,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.expiresAt = expiresAt ?? weekStart.add(const Duration(days: 112));
  }
}
