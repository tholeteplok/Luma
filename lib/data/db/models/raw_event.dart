import 'package:isar/isar.dart';

part 'raw_event.g.dart';

@collection
class RawEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  @Index()
  late String packageName;

  String? activityName;

  late int durationSeconds;

  bool isForeground = true;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime expiresAt; // 7 hari dari createdAt untuk fade granularity
}
