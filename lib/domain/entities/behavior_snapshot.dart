library;

import 'package:luma/domain/services/app_category_classifier.dart';

/// BehaviorSnapshot — Representasi abstrak perilaku digital satu hari.
///
/// Ini adalah "bahasa tengah" antara data mentah (DailySummary)
/// dan bahasa manusia (InsightLanguageEngine).
///
/// Tidak ada angka absolut di sini. Hanya level relatif dan pola.

/// Seberapa sering user berpindah aplikasi dalam satu sesi
enum SwitchFrequency {
  /// Sedikit berpindah — terasa fokus, ada satu hal yang dikerjakan
  focused,

  /// Sedang — normal, beberapa tugas bergantian
  moderate,

  /// Sangat sering berpindah — terasa tersebar / gelisah
  scattered,
}

/// Tingkat penggunaan layar relatif terhadap baseline 7 hari
enum ScreenTimeLevel {
  /// Jauh di bawah rata-rata (< 60% baseline)
  belowBaseline,

  /// Sekitar rata-rata (60–130% baseline)
  nearBaseline,

  /// Di atas rata-rata (> 130% baseline)
  aboveBaseline,
}

/// Zona waktu aktivitas paling dominan
enum ActivityTimeZone {
  /// 05:00–09:00
  earlyMorning,

  /// 09:00–12:00
  morning,

  /// 12:00–14:00
  midday,

  /// 14:00–18:00
  afternoon,

  /// 18:00–22:00
  evening,

  /// 22:00–02:00
  lateNight,

  /// Tersebar merata sepanjang hari
  distributed,
}

class BehaviorSnapshot {
  /// Kategori aplikasi yang paling banyak digunakan (dalam durasi)
  final AppCategory dominantCategory;

  /// Kategori kedua terbesar (jika ada)
  final AppCategory? secondaryCategory;

  /// Frekuensi perpindahan antar aplikasi
  final SwitchFrequency switchFrequency;

  /// Zona waktu dengan aktivitas paling tinggi
  final ActivityTimeZone peakTimeZone;

  /// Level penggunaan layar vs 7-hari terakhir
  final ScreenTimeLevel screenTimeLevel;

  /// User aktif setelah jam 22:00
  final bool hasLateNightActivity;

  /// Ada sesi panjang (≥45 menit) di satu aplikasi tanpa beralih
  final bool hasLongSingleSession;

  /// Ada aktivitas di rentang pagi (06:00–08:00)
  final bool hasMorningRoutine;

  /// Jumlah kali membuka layar (dibandingkan ke threshold, bukan angka absolut)
  final ScreenOpenLevel screenOpenLevel;

  /// Berapa hari data tersedia untuk baseline (0 = hari pertama)
  final int baselineDaysAvailable;

  const BehaviorSnapshot({
    required this.dominantCategory,
    this.secondaryCategory,
    required this.switchFrequency,
    required this.peakTimeZone,
    required this.screenTimeLevel,
    required this.hasLateNightActivity,
    required this.hasLongSingleSession,
    required this.hasMorningRoutine,
    required this.screenOpenLevel,
    this.baselineDaysAvailable = 0,
  });

  /// Snapshot kosong — untuk hari pertama saat data belum cukup
  static const BehaviorSnapshot empty = BehaviorSnapshot(
    dominantCategory: AppCategory.unknown,
    switchFrequency: SwitchFrequency.moderate,
    peakTimeZone: ActivityTimeZone.distributed,
    screenTimeLevel: ScreenTimeLevel.nearBaseline,
    hasLateNightActivity: false,
    hasLongSingleSession: false,
    hasMorningRoutine: false,
    screenOpenLevel: ScreenOpenLevel.normal,
    baselineDaysAvailable: 0,
  );

  /// Apakah snapshot ini punya cukup data untuk menghasilkan insight bermakna?
  bool get hasMeaningfulData =>
      dominantCategory != AppCategory.unknown || baselineDaysAvailable > 0;
}

/// Level frekuensi membuka layar (relatif, bukan angka)
enum ScreenOpenLevel {
  /// Jarang membuka — terasa tenang / offline
  rare,

  /// Normal — tipikal hari biasa
  normal,

  /// Sangat sering — mungkin sedang menunggu notifikasi
  frequent,
}

/// Factory untuk membuat BehaviorSnapshot dari data mentah
class BehaviorSnapshotFactory {
  /// Buat snapshot dari aggregated data.
  ///
  /// [categoryUsage] — Map of AppCategory to durationSeconds
  /// [switchCount] — jumlah total perpindahan app hari ini
  /// [totalScreenSeconds] — total waktu layar hari ini
  /// [baselineScreenSeconds] — rata-rata 7 hari terakhir (0 jika belum ada)
  /// [screenOpenCount] — berapa kali membuka layar
  /// [appUsageByHour] — Map of hour(0-23) to durationSeconds
  /// [baselineDays] — berapa hari baseline tersedia
  static BehaviorSnapshot create({
    required Map<AppCategory, int> categoryUsage,
    required int switchCount,
    required int totalScreenSeconds,
    required int baselineScreenSeconds,
    required int screenOpenCount,
    required Map<int, int> appUsageByHour,
    int baselineDays = 0,
  }) {
    final dominant = AppCategoryClassifier.dominantCategory(categoryUsage);

    // Secondary category — terbesar kedua, berbeda dari dominant
    AppCategory? secondary;
    final sorted = categoryUsage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (sorted.length >= 2 && sorted[1].key != dominant) {
      secondary = sorted[1].key;
    }

    // Switch frequency
    final screentimeHours = totalScreenSeconds / 3600;
    final switchesPerHour = screentimeHours > 0 ? switchCount / screentimeHours : 0;
    final switchFreq = switchesPerHour < 8
        ? SwitchFrequency.focused
        : switchesPerHour < 20
            ? SwitchFrequency.moderate
            : SwitchFrequency.scattered;

    // Screen time level vs baseline
    ScreenTimeLevel screenLevel;
    if (baselineScreenSeconds == 0) {
      screenLevel = ScreenTimeLevel.nearBaseline; // default hari pertama
    } else {
      final ratio = totalScreenSeconds / baselineScreenSeconds;
      screenLevel = ratio < 0.6
          ? ScreenTimeLevel.belowBaseline
          : ratio > 1.3
              ? ScreenTimeLevel.aboveBaseline
              : ScreenTimeLevel.nearBaseline;
    }

    // Screen open level (threshold: rare < 10, normal 10-50, frequent > 50)
    final screenOpenLevel = screenOpenCount < 10
        ? ScreenOpenLevel.rare
        : screenOpenCount > 50
            ? ScreenOpenLevel.frequent
            : ScreenOpenLevel.normal;

    // Late night activity: ada usage jam 22-24 atau 0-2
    final lateNightSeconds = (appUsageByHour[22] ?? 0) +
        (appUsageByHour[23] ?? 0) +
        (appUsageByHour[0] ?? 0) +
        (appUsageByHour[1] ?? 0);
    final hasLateNight = lateNightSeconds > 300; // > 5 menit

    // Morning routine: ada usage jam 6-8
    final morningSeconds = (appUsageByHour[6] ?? 0) + (appUsageByHour[7] ?? 0);
    final hasMorning = morningSeconds > 120; // > 2 menit

    // Long single session — heuristik: jika switch frequency rendah
    // dan total waktu layar signifikan
    final hasLongSession = switchFreq == SwitchFrequency.focused &&
        totalScreenSeconds > 2700; // > 45 menit total

    // Peak time zone
    final peak = _findPeakTimeZone(appUsageByHour);

    return BehaviorSnapshot(
      dominantCategory: dominant,
      secondaryCategory: secondary,
      switchFrequency: switchFreq,
      peakTimeZone: peak,
      screenTimeLevel: screenLevel,
      hasLateNightActivity: hasLateNight,
      hasLongSingleSession: hasLongSession,
      hasMorningRoutine: hasMorning,
      screenOpenLevel: screenOpenLevel,
      baselineDaysAvailable: baselineDays,
    );
  }

  static ActivityTimeZone _findPeakTimeZone(Map<int, int> byHour) {
    if (byHour.isEmpty) return ActivityTimeZone.distributed;

    // Group ke zona waktu
    final zones = <ActivityTimeZone, int>{
      ActivityTimeZone.earlyMorning: _sumHours(byHour, [5, 6, 7, 8]),
      ActivityTimeZone.morning: _sumHours(byHour, [9, 10, 11]),
      ActivityTimeZone.midday: _sumHours(byHour, [12, 13]),
      ActivityTimeZone.afternoon: _sumHours(byHour, [14, 15, 16, 17]),
      ActivityTimeZone.evening: _sumHours(byHour, [18, 19, 20, 21]),
      ActivityTimeZone.lateNight: _sumHours(byHour, [22, 23, 0, 1]),
    };

    final maxZone = zones.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final total = zones.values.fold(0, (a, b) => a + b);

    // Jika zona paling dominan < 30% total → distributed
    if (total == 0 || maxZone.value / total < 0.3) {
      return ActivityTimeZone.distributed;
    }

    return maxZone.key;
  }

  static int _sumHours(Map<int, int> byHour, List<int> hours) {
    return hours.fold(0, (sum, h) => sum + (byHour[h] ?? 0));
  }
}
