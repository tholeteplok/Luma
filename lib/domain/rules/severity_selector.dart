library;

import 'package:luma/domain/entities/behavior_snapshot.dart';
import 'package:luma/domain/services/insight_language_engine.dart';

/// InsightSeverity — Level emosional sebuah insight.
///
/// Bukan "seberapa parah masalahnya" — tapi "seberapa perlu
/// Luma menarik perhatian user saat ini."
///
/// Urutan dari paling tenang ke paling perlu perhatian:
/// gentle → info → notice → warning
///
/// Spec rule: default ke yang lebih rendah saat ragu.
enum InsightSeverity {
  /// Observasi tenang, ritme normal, tidak ada yang perlu diperhatikan khusus.
  /// Warna: hijau redup. Dipakai untuk pola positif atau hari biasa.
  gentle,

  /// Informasi netral — ada sesuatu yang menarik tapi tidak mendesak.
  /// Warna: biru tenang. Default untuk sebagian besar insight.
  info,

  /// Perhatian lembut — ada perubahan pola yang layak diperhatikan.
  /// Warna: oranye hangat. Maks 2x per minggu.
  notice,

  /// Perubahan signifikan — pola berbeda jauh dari baseline.
  /// Warna: merah redup. Maks 1x per minggu, tidak di 7 hari pertama.
  warning,
}

/// SeveritySelector — Memilih level severity yang tepat untuk sebuah insight.
///
/// Implementasi flowchart dari LUMA_UI_CLARIFICATIONS.md Section 3.
///
/// Prinsip utama:
/// - Default ke yang lebih rendah saat ragu
/// - Tidak ada warning di 7 hari pertama
/// - Maks 1 warning per minggu
/// - Maks 2 notice per minggu
/// - InsightTone dari engine → severity mapping (bukan sebaliknya)
class SeveritySelector {
  SeveritySelector._();

  /// Pilih severity berdasarkan konteks lengkap.
  ///
  /// [tone] — tone dari InsightLanguageEngine (sumber kebenaran utama)
  /// [daysOfData] — berapa hari data tersedia (0 = hari pertama)
  /// [warningsThisWeek] — berapa kali warning sudah muncul minggu ini
  /// [noticesThisWeek] — berapa kali notice sudah muncul minggu ini
  /// [isSignificantChange] — apakah ada perubahan signifikan dari baseline
  static InsightSeverity select({
    required InsightTone tone,
    required int daysOfData,
    int warningsThisWeek = 0,
    int noticesThisWeek = 0,
    bool isSignificantChange = false,
  }) {
    // ── Step 1: Terjemahkan tone ke severity kandidat ────────────────────────
    final candidate = _toneToSeverity(tone, isSignificantChange);

    // ── Step 2: Terapkan guardrails ──────────────────────────────────────────

    // Guardrail A: Tidak ada warning di 7 hari pertama
    if (candidate == InsightSeverity.warning && daysOfData < 7) {
      return InsightSeverity.notice;
    }

    // Guardrail B: Maks 1 warning per minggu
    if (candidate == InsightSeverity.warning && warningsThisWeek >= 1) {
      return InsightSeverity.notice;
    }

    // Guardrail C: Maks 2 notice per minggu
    if (candidate == InsightSeverity.notice && noticesThisWeek >= 2) {
      return InsightSeverity.info;
    }

    // Guardrail D: Hari pertama (0–2 hari data) → selalu gentle atau info
    if (daysOfData < 3) {
      if (candidate == InsightSeverity.warning ||
          candidate == InsightSeverity.notice) {
        return InsightSeverity.info;
      }
    }

    return candidate;
  }

  /// Terjemahkan InsightTone ke severity kandidat (sebelum guardrails).
  static InsightSeverity _toneToSeverity(
    InsightTone tone,
    bool isSignificantChange,
  ) {
    return switch (tone) {
      InsightTone.calm => InsightSeverity.gentle,
      InsightTone.meaningful => InsightSeverity.gentle,
      InsightTone.neutral => InsightSeverity.info,
      InsightTone.reflective => InsightSeverity.info,
      InsightTone.different =>
        isSignificantChange ? InsightSeverity.warning : InsightSeverity.notice,
    };
  }

  /// Konversi InsightSeverity ke string yang dikenal InsightCard / orb.
  static String toCardSeverity(InsightSeverity severity) {
    return switch (severity) {
      InsightSeverity.gentle => 'gentle',
      InsightSeverity.info => 'info',
      InsightSeverity.notice => 'notice',
      InsightSeverity.warning => 'warning',
    };
  }

  /// Apakah perubahan dari snapshot ke snapshot sebelumnya signifikan?
  /// Dipakai untuk menentukan apakah `different` tone → warning atau notice.
  static bool isSignificantChange(
    BehaviorSnapshot current,
    BehaviorSnapshot? previous,
  ) {
    if (previous == null) return false;

    int changeScore = 0;

    // Perubahan kategori dominan
    if (current.dominantCategory != previous.dominantCategory) changeScore++;

    // Perubahan screen time level (bukan hanya sedikit)
    if (current.screenTimeLevel != previous.screenTimeLevel) changeScore++;

    // Perubahan switch frequency
    if (current.switchFrequency != previous.switchFrequency) changeScore++;

    // Late night baru muncul
    if (current.hasLateNightActivity && !previous.hasLateNightActivity) {
      changeScore++;
    }

    // Signifikan jika 2+ dimensi berubah sekaligus
    return changeScore >= 2;
  }
}

/// Konteks severity untuk satu sesi generate insight.
/// Dipakai oleh HomeNotifier untuk tracking budget mingguan.
class SeverityContext {
  final int warningsThisWeek;
  final int noticesThisWeek;
  final int daysOfData;

  const SeverityContext({
    this.warningsThisWeek = 0,
    this.noticesThisWeek = 0,
    required this.daysOfData,
  });

  SeverityContext incrementWarning() => SeverityContext(
        warningsThisWeek: warningsThisWeek + 1,
        noticesThisWeek: noticesThisWeek,
        daysOfData: daysOfData,
      );

  SeverityContext incrementNotice() => SeverityContext(
        warningsThisWeek: warningsThisWeek,
        noticesThisWeek: noticesThisWeek + 1,
        daysOfData: daysOfData,
      );
}
