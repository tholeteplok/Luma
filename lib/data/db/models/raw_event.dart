import 'dart:convert';
import 'package:isar/isar.dart';
import 'event_type.dart';

part 'raw_event.g.dart';

@collection
class RawEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  @Index()
  @enumerated
  late EventType type;

  @Index()
  late String packageName;

  String? appName;

  late int durationSeconds;

  bool isForeground = true;

  // Metadata tambahan (flexible JSON-like map) disimpan sebagai JSON string
  String? metadataJson;

  @ignore
  Map<String, dynamic>? get metadata {
    if (metadataJson == null) return null;
    try {
      return jsonDecode(metadataJson!) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  set metadata(Map<String, dynamic>? val) {
    if (val == null) {
      metadataJson = null;
    } else {
      metadataJson = jsonEncode(val);
    }
  }

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
    Map<String, dynamic>? metadata,
    DateTime? createdTime,
    DateTime? expiresTime,
  }) {
    this.metadata = metadata;
    createdAt = createdTime ?? DateTime.now();
    // Default expiresAt: 7 hari dari createdAt (sesuai retention policy)
    expiresAt = expiresTime ?? createdAt.add(const Duration(days: 7));
  }
}
