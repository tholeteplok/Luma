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

  late Map<String, String> templateParams; // Parameter untuk template

  late String renderedText; // Text yang sudah di-render dalam bahasa user

  late InsightSeverity severity;

  bool isRead = false;
  bool isDismissed = false;

  @Index()
  late DateTime expiresAt; // Insight tidak kadaluarsa (null = selamanya)

  // Metadata untuk debugging
  Map<String, dynamic>? metadata; // Data mentah yang trigger insight ini
}
