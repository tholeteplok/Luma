import 'luma_language.dart';

/// Fade Granularity — Memory Decay System
///
/// Luma tidak menggunakan DELETE, PURGE, atau ARCHIVE.
/// Luma menggunakan FADE (pengaburan progresif).
/// Detail memudar, pola menetap.
/// Ini meniru sifat alami ingatan manusia.

enum DataFadeState {
  sharp,      // 0-7 hari: opacity 1.0, no blur
  dim,        // 8-14 hari: opacity 0.85, no blur
  blurry,     // 15-28 hari: opacity 0.65, blur σ=1.5
  silhouette, // 28+ hari: opacity 0.45, blur σ=2.5
}

class FadeGranularity {
  /// Return fade state berdasarkan usia data (hari)
  static DataFadeState getState(int daysOld) {
    if (daysOld <= 7) return DataFadeState.sharp;
    if (daysOld <= 14) return DataFadeState.dim;
    if (daysOld <= 28) return DataFadeState.blurry;
    return DataFadeState.silhouette;
  }

  /// Opacity untuk UI rendering
  static double getOpacity(int daysOld) {
    switch (getState(daysOld)) {
      case DataFadeState.sharp:
        return 1.0;
      case DataFadeState.dim:
        return 0.85;
      case DataFadeState.blurry:
        return 0.65;
      case DataFadeState.silhouette:
        return 0.45;
    }
  }

  /// Blur sigma untuk CustomPainter / ImageFilter
  static double getBlurSigma(int daysOld) {
    switch (getState(daysOld)) {
      case DataFadeState.sharp:
        return 0.0;
      case DataFadeState.dim:
        return 0.0;
      case DataFadeState.blurry:
        return 1.5;
      case DataFadeState.silhouette:
        return 2.5;
    }
  }

  /// Label waktu untuk UI (locale-aware, type-safe)
  static String getTimeLabel(int daysOld, LumaLanguage language) {
    final isId = language == LumaLanguage.indonesian;

    if (daysOld <= 7) return isId ? 'Hari ini' : 'Today';
    if (daysOld <= 14) return isId ? 'Minggu lalu' : 'Last week';
    if (daysOld <= 28) return isId ? 'Pertengahan bulan' : 'Mid month';
    return isId ? 'Bulan lalu' : 'Last month';
  }

  /// Tooltip hint pasif (tidak mendesak, locale-aware)
  static String getHintText(LumaLanguage language) {
    return language == LumaLanguage.indonesian
        ? 'Data ini akan dirangkum dalam beberapa hari. Pola tetap tersimpan.'
        : 'This data will be summarized in a few days. Patterns remain.';
  }

  /// Apakah teks insight harus ditampilkan italic?
  /// True hanya untuk state silhouette (28+ hari) — sesuai spec Memory Fading.
  static bool isItalic(int daysOld) => daysOld > 28;
}
