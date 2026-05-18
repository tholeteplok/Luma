import 'package:isar/isar.dart';

part 'weekly_profile.g.dart';

@collection
class WeeklyProfile {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int weekNumber; // ISO week number

  late int year;

  late double avgFocusScore;
  late double avgDistractionScore;
  late int totalScreenTimeSeconds;
  late String peakActivityDay; // e.g., "Monday"
  late String lowestActivityDay;

  // Pattern recognition
  late Map<String, double> dailyPatterns; // dayName -> avgScore
  late List<String> topDistractions; // Top 3 distracting apps

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime expiresAt; // Untuk fade granularity (28 hari)
}
