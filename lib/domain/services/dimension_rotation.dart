library;

import 'package:luma/domain/entities/insight_id.dart';

/// DimensionRotation — Menentukan "fokus perhatian" Luma setiap minggu.
///
/// Luma tidak mengomentari semua hal setiap hari.
/// Setiap minggu, ia lebih memperhatikan satu dimensi tertentu.
///
/// Ini mirip cara manusia memperhatikan teman:
/// tidak semua hal dikomentari setiap hari.
class DimensionRotation {
  /// Dapatkan dimensi fokus untuk minggu tertentu.
  /// Siklus 4 minggu, berputar otomatis berdasarkan nomor minggu dalam tahun.
  static InsightDimension getDimension(DateTime date) {
    // Hitung nomor minggu sejak epoch (konsisten antar tahun)
    final weekNumber = _getWeekNumber(date);
    final index = weekNumber % InsightDimension.values.length;
    return InsightDimension.values[index];
  }

  /// Dapatkan InsightId yang diprioritaskan untuk minggu ini
  static List<InsightId> getPriorityIds(DateTime date) {
    final dimension = getDimension(date);
    return dimensionInsights[dimension] ?? [];
  }

  /// Hitung skor prioritas sebuah InsightId berdasarkan dimensi minggu ini.
  /// InsightId yang masuk dimensi aktif dapat bobot 2.0, yang lain 1.0.
  static double getPriorityWeight(InsightId id, DateTime date) {
    final dimension = getDimension(date);
    final priorityIds = dimensionInsights[dimension] ?? [];
    return priorityIds.contains(id) ? 2.0 : 1.0;
  }

  /// Nama dimensi dalam bahasa Indonesia (untuk debug/logging)
  static String getDimensionName(InsightDimension dimension) {
    return switch (dimension) {
      InsightDimension.morningRhythm => 'Ritme Pagi',
      InsightDimension.distractionFlow => 'Aliran Distraksi',
      InsightDimension.restPattern => 'Pola Istirahat',
      InsightDimension.energyRecovery => 'Pemulihan Energi',
    };
  }

  /// ISO week number (1-53)
  static int _getWeekNumber(DateTime date) {
    final dayOfYear = int.parse(
      date.difference(DateTime(date.year, 1, 1)).inDays.toString(),
    );
    // Tambahkan offset tahun agar tidak reset tiap tahun
    return date.year * 53 + (dayOfYear ~/ 7);
  }
}

/// ProgressiveDepth — Menentukan kedalaman observasi berdasarkan usia data
class ProgressiveDepth {
  /// Level kedalaman insight berdasarkan berapa hari data tersedia
  static DepthLevel getLevel(int daysOfData) {
    if (daysOfData >= 90) return DepthLevel.longitudinal;
    if (daysOfData >= 30) return DepthLevel.relationship;
    if (daysOfData >= 7) return DepthLevel.pattern;
    return DepthLevel.surface;
  }

  /// InsightId apa saja yang tersedia untuk depth level ini
  static List<InsightId> getAvailableIds(int daysOfData) {
    return InsightId.values.where((id) {
      final threshold = insightDataThreshold[id] ?? 0;
      return daysOfData >= threshold;
    }).toList();
  }
}

/// Level kedalaman insight — tumbuh seiring waktu
enum DepthLevel {
  /// 0–6 hari: "Pagi ini fokusmu tenang."
  surface,

  /// 7–29 hari: "Fokus paling stabilmu sering di pagi hari."
  pattern,

  /// 30–89 hari: "Hari dengan pagi tenang sering diikuti malam lebih pendek."
  relationship,

  /// 90+ hari: "Ritme pagimu berubah perlahan sejak beberapa bulan lalu."
  longitudinal,
}
