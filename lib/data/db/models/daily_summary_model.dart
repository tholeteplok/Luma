import 'package:isar/isar.dart';

part 'daily_summary.g.dart';

@collection
class DailySummary {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late int totalScreenTimeSeconds;
  late int foregroundAppSwitches;
  late double focusScore;
  late double distractionScore;
  late int unlockCount;
  late Map<String, int> topPackages; // packageName -> durationSeconds

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime expiresAt; // Untuk fade granularity
}
