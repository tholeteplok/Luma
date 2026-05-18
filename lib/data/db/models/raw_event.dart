import 'package:isar/isar.dart';
import 'event_type.dart';

part 'raw_event.g.dart';

@collection
class RawEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  @Index()
  late EventType type;

  @Index()
  late String packageName;

  String? appName;

  late int durationSeconds;

  bool isForeground = true;

  // Metadata tambahan (flexible JSON-like map)
  Map<String, dynamic>? metadata;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime expiresAt; // 7 hari dari createdAt untuk fade granularity

  /// Constructor dengan default values
  RawEvent({
    required this.timestamp,
    required this.type,
    required this.packageName,
    this.appName,
    required this.durationSeconds,
    required this.isForeground,
    this.metadata,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    // Default expiresAt: 7 hari dari createdAt (sesuai retention policy)
    this.expiresAt = expiresAt ?? this.createdAt.add(const Duration(days: 7));
  }
}
