import 'package:flutter/foundation.dart';

// Fade Granularity util for memory visualization (days-based decays)

enum DataFadeState {
  sharp,
  dim,
  blurry,
  silhouette,
}

class FadeGranularity {
  static DataFadeState getState(int daysOld) {
    if (daysOld <= 7) return DataFadeState.sharp;
    if (daysOld <= 14) return DataFadeState.dim;
    if (daysOld <= 28) return DataFadeState.blurry;
    return DataFadeState.silhouette;
  }

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

  static String getTimeLabel(int daysOld, dynamic language) {
    // Expect language to be of type LumaLanguage; fallback to Indonesian if unknown
    final isIndonesian = language != null && language.toString().contains('indonesian');

    if (daysOld <= 7) {
      return isIndonesian ? 'Hari ini' : 'Today';
    }
    if (daysOld <= 14) {
      return isIndonesian ? 'Minggu lalu' : 'Last week';
    }
    if (daysOld <= 28) {
      return isIndonesian ? 'Pertengahan bulan' : 'Mid month';
    }
    return isIndonesian ? 'Bulan lalu' : 'Last month';
  }

  static String getHintText(dynamic language) {
    final isIndonesian = language != null && language.toString().contains('indonesian');
    return isIndonesian
        ? 'Data ini akan dirangkum dalam beberapa hari. Pola tetap tersimpan.'
        : 'This data will be summarized in a few days. Patterns remain.';
  }
}
