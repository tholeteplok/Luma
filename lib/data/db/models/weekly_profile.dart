import 'dart:convert';
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
  
  // Top apps untuk minggu ini disimpan sebagai JSON string
  String? topAppsJson;

  @ignore
  List<Map<String, dynamic>> get topApps {
    if (topAppsJson == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(topAppsJson!) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  set topApps(List<Map<String, dynamic>> val) {
    topAppsJson = jsonEncode(val);
  }
  
  // Number of days with data
  late int dayCount;

  String peakActivityDay; // e.g., "Monday"
  String lowestActivityDay;

  // Pattern recognition disimpan sebagai JSON string
  String? dailyPatternsJson;

  @ignore
  Map<String, double> get dailyPatterns {
    if (dailyPatternsJson == null) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(dailyPatternsJson!) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (_) {
      return {};
    }
  }

  set dailyPatterns(Map<String, double> val) {
    dailyPatternsJson = jsonEncode(val);
  }
  
  List<String> topDistractions; // Top 3 distracting apps

  @Index()
  DateTime? createdAt;

  @Index()
  DateTime? expiresAt; // Untuk fade granularity (112 hari / 4 minggu)

  WeeklyProfile({
    required this.weekStart,
    required this.totalScreenTimeSeconds,
    required this.averageDailyScreenTimeSeconds,
    required this.averageFocusScore,
    required this.totalDistractions,
    required this.dayCount,
    this.peakActivityDay = '',
    this.lowestActivityDay = '',
    this.topDistractions = const [],
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.expiresAt = expiresAt ?? weekStart.add(const Duration(days: 112));
  }
}
