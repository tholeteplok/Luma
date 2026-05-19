import 'dart:convert';
import 'package:isar/isar.dart';

part 'insight.g.dart';

enum InsightSeverity {
  info,    // Biru - observasional netral
  notice,  // Orange - perhatian ringan
  warning, // Merah - perlu kesadaran
  gentle,  // Hijau - positive reinforcement
}

@collection
class Insight {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime createdAt;

  @Index()
  late String category; // e.g., "focus", "distraction", "rhythm", "balance"

  late String templateId; // Referensi ke template (untuk i18n)

  // Parameter untuk template disimpan sebagai JSON string
  String? templateParamsJson;

  @ignore
  Map<String, String> get templateParams {
    if (templateParamsJson == null) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(templateParamsJson!) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (_) {
      return {};
    }
  }

  set templateParams(Map<String, String> val) {
    templateParamsJson = jsonEncode(val);
  }

  late String renderedText; // Text yang sudah di-render dalam bahasa user

  @enumerated
  late InsightSeverity severity;

  bool isRead = false;
  bool isDismissed = false;

  @Index()
  late DateTime expiresAt; // Insight tidak kadaluarsa (null = selamanya)

  // Metadata untuk debugging disimpan sebagai JSON string
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
}
