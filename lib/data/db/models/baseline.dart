import 'dart:convert';
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

  // Circadian patterns disimpan sebagai JSON string
  String? hourlyActivityPatternJson;

  @ignore
  Map<int, double> get hourlyActivityPattern {
    if (hourlyActivityPatternJson == null) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(hourlyActivityPatternJson!) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(int.parse(key), (value as num).toDouble()));
    } catch (_) {
      return {};
    }
  }

  set hourlyActivityPattern(Map<int, double> val) {
    hourlyActivityPatternJson = jsonEncode(val.map((key, value) => MapEntry(key.toString(), value)));
  }

  // Weekly patterns disimpan sebagai JSON string
  String? weekdayPatternsJson;

  @ignore
  Map<String, double> get weekdayPatterns {
    if (weekdayPatternsJson == null) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(weekdayPatternsJson!) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (_) {
      return {};
    }
  }

  set weekdayPatterns(Map<String, double> val) {
    weekdayPatternsJson = jsonEncode(val);
  }

  // App categories baseline disimpan sebagai JSON string
  String? categoryBaselinesJson;

  @ignore
  Map<String, double> get categoryBaselines {
    if (categoryBaselinesJson == null) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(categoryBaselinesJson!) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (_) {
      return {};
    }
  }

  set categoryBaselines(Map<String, double> val) {
    categoryBaselinesJson = jsonEncode(val);
  }

  @Index()
  late DateTime lastUpdated;

  @Index()
  late int dataPointsCount; // Number of days used for baseline
}
