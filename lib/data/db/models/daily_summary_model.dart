import 'dart:convert';
import 'package:isar/isar.dart';

part 'daily_summary_model.g.dart';

@collection
class DailySummary {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late int totalScreenTimeSeconds;
  
  // App usage breakdown (packageName -> minutes) disimpan sebagai JSON string
  String? appUsageMinutesJson;

  @ignore
  Map<String, int> get appUsageMinutes {
    if (appUsageMinutesJson == null) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(appUsageMinutesJson!) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as int));
    } catch (_) {
      return {};
    }
  }

  set appUsageMinutes(Map<String, int> val) {
    appUsageMinutesJson = jsonEncode(val);
  }
  
  // Top 5 apps dengan duration tertinggi disimpan sebagai JSON string
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
  
  /// Generative constructor kosong untuk Isar
  DailySummary();

  /// Factory constructor dengan default values
  factory DailySummary.create({
    required DateTime date,
    required int totalScreenTimeSeconds,
    required Map<String, int> appUsageMinutes,
    required List<Map<String, dynamic>> topApps,
    required int screenOnCount,
    required int screenOffCount,
    required double focusScore,
    required int distractionCount,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    final summary = DailySummary()
      ..date = date
      ..totalScreenTimeSeconds = totalScreenTimeSeconds
      ..appUsageMinutes = appUsageMinutes
      ..topApps = topApps
      ..screenOnCount = screenOnCount
      ..screenOffCount = screenOffCount
      ..focusScore = focusScore
      ..distractionCount = distractionCount;
    summary.createdAt = createdAt ?? DateTime.now();
    // Default expiresAt: 28 hari dari date (sesuai retention policy)
    summary.expiresAt = expiresAt ?? date.add(const Duration(days: 28));
    return summary;
  }
}
