library;

import 'package:luma/core/utils/luma_language.dart';
import 'package:luma/domain/entities/behavior_snapshot.dart';
import 'package:luma/domain/entities/insight_id.dart';
import 'package:luma/domain/services/app_category_classifier.dart';
import 'package:luma/domain/services/dimension_rotation.dart';

/// InsightLanguageEngine — Jantung dari filosofi Luma.
///
/// Mengubah BehaviorSnapshot (data abstrak) menjadi frasa bahasa NVC.
///
/// ATURAN KERAS:
/// 1. Tidak ada angka absolut dalam output
/// 2. Tidak ada penilaian (baik/buruk/salah/benar)
/// 3. Tidak lebih dari 3 frasa per snapshot
/// 4. Frasa selalu deskriptif, bukan preskriptif
/// 5. Gunakan bahasa metafora organik (air, napas, cahaya, ritme)
///
/// Setiap kandidat insight di-tag dengan [InsightId] —
/// orchestrator memakai tag itu untuk cooldown & rotasi dimensi.
/// Engine sendiri tidak tahu siapa yang sudah pernah muncul.

/// Satu insight yang dihasilkan engine
class LumaInsight {
  /// Konsep observasional — yang ditrack cooldown-nya
  final InsightId id;

  /// Frasa utama yang ditampilkan ke user
  final String phrase;

  /// Konteks optional — kalimat kedua yang lebih dalam (bisa null)
  final String? subPhrase;

  /// Tipe visual untuk InsightCard (menentukan warna ambient)
  final InsightTone tone;

  /// Kedalaman observasi saat insight ini dibentuk
  final DepthLevel depth;

  const LumaInsight({
    required this.id,
    required this.phrase,
    this.subPhrase,
    this.tone = InsightTone.neutral,
    this.depth = DepthLevel.surface,
  });
}

/// Warna/nuansa emosional insight — bukan "severity"
enum InsightTone {
  /// Abu-abu — netral, observasi biasa
  neutral,

  /// Biru tenang — reflektif, introspektif
  reflective,

  /// Ungu lembut — momen bermakna, deep focus
  meaningful,

  /// Oranye hangat — pola menarik, berbeda dari biasanya
  different,

  /// Hijau tenang — ritme seimbang, pagi yang baik
  calm,
}

class InsightLanguageEngine {
  final LumaLanguage language;

  const InsightLanguageEngine({this.language = LumaLanguage.indonesian});

  /// Hasilkan semua kandidat insight yang relevan dari snapshot,
  /// tanpa filter cooldown / dimensi (itu tugas orchestrator).
  ///
  /// Setiap kandidat sudah ditag [InsightId] dan [DepthLevel].
  List<LumaInsight> generateCandidates(
    BehaviorSnapshot snapshot, {
    DepthLevel depth = DepthLevel.surface,
  }) {
    if (!snapshot.hasMeaningfulData) {
      return [_firstDayInsight()];
    }

    final candidates = <LumaInsight>[];

    final primary = _generatePrimaryInsight(snapshot, depth);
    if (primary != null) candidates.add(primary);

    final temporal = _generateTemporalInsight(snapshot, depth);
    if (temporal != null) candidates.add(temporal);

    final rhythm = _generateRhythmInsight(snapshot, depth);
    if (rhythm != null) candidates.add(rhythm);

    return candidates;
  }

  /// API lama — dipertahankan untuk kompatibilitas.
  /// Setara `generateCandidates` lalu fallback observation.
  List<LumaInsight> generate(BehaviorSnapshot snapshot) {
    final candidates = generateCandidates(snapshot);
    if (candidates.isEmpty) {
      return [_defaultObservation()];
    }
    return candidates.take(3).toList();
  }

  // ──────────────────────────────────────────────────────────────
  // LAYER 1: Primary — berdasarkan kategori dominan + screen level
  // ──────────────────────────────────────────────────────────────

  LumaInsight? _generatePrimaryInsight(BehaviorSnapshot s, DepthLevel depth) {
    final cat = s.dominantCategory;
    final level = s.screenTimeLevel;
    final hasLong = s.hasLongSingleSession;

    // Hari yang sangat tenang
    if (level == ScreenTimeLevel.belowBaseline &&
        s.screenOpenLevel == ScreenOpenLevel.rare) {
      return LumaInsight(
        id: InsightId.recoveringDay,
        depth: depth,
        phrase: _t(
          id: 'Hari ini tubuhmu lebih banyak beristirahat dari layar.',
          en: 'Today you spent less time on your screen than usual.',
        ),
        subPhrase: _t(
          id: 'Ada ketenangan yang berbeda dalam ritmu hari ini.',
          en: "There's a quietness to today's rhythm.",
        ),
        tone: InsightTone.calm,
      );
    }

    // Deep focus dalam satu aplikasi lama
    if (hasLong && s.switchFrequency == SwitchFrequency.focused) {
      final (InsightId id, String phrase, String? sub) = switch (cat) {
        AppCategory.productivity => (
            InsightId.productivityFocus,
            _t(
              id: 'Ada sesuatu yang sedang dikerjakan dengan serius hari ini.',
              en: 'Something is being worked on with serious attention today.',
            ),
            _t(
              id: 'Pikiran terasa tertuju pada satu arah.',
              en: 'The mind seems pointed in one direction.',
            ),
          ),
        AppCategory.entertainment => (
            InsightId.entertainmentMode,
            _t(
              id: 'Ada sesuatu yang menyerap perhatianmu hari ini.',
              en: 'Something absorbed your attention today.',
            ),
            _t(
              id: 'Tubuh memilih istirahat dalam cara yang berbeda.',
              en: 'The body chose rest in its own way.',
            ),
          ),
        AppCategory.browsing => (
            InsightId.curiosityDriven,
            _t(
              id: 'Ada rasa ingin tahu yang dalam hari ini.',
              en: 'Deep curiosity surfaced today.',
            ),
            null,
          ),
        _ => (
            InsightId.deepFocusSession,
            _t(
              id: 'Ada momen di mana perhatianmu tertuju lama pada satu hal.',
              en: 'There was a moment of sustained focus today.',
            ),
            null,
          ),
      };
      return LumaInsight(
        id: id,
        depth: depth,
        phrase: phrase,
        subPhrase: sub,
        tone: InsightTone.meaningful,
      );
    }

    // Pola sosial dominan
    if (cat == AppCategory.social) {
      return LumaInsight(
        id: InsightId.socialSpace,
        depth: depth,
        phrase: _t(
          id: 'Hari ini banyak waktu dihabiskan dalam ruang sosial digital.',
          en: 'Much of today unfolded in digital social spaces.',
        ),
        subPhrase: s.switchFrequency == SwitchFrequency.scattered
            ? _t(
                id: 'Pikiran terasa bergerak cepat dari satu hal ke hal lain.',
                en: 'The mind moved quickly from one thing to another.',
              )
            : null,
        tone: InsightTone.neutral,
      );
    }

    // Komunikasi dominan
    if (cat == AppCategory.communication) {
      return LumaInsight(
        id: InsightId.communicationDay,
        depth: depth,
        phrase: _t(
          id: 'Hari ini terasa banyak menjaga koneksi dengan orang lain.',
          en: 'Today felt like a day of maintaining connections.',
        ),
        tone: InsightTone.reflective,
      );
    }

    // Produktivitas dominan
    if (cat == AppCategory.productivity) {
      return LumaInsight(
        id: InsightId.productivityFocus,
        depth: depth,
        phrase: _t(
          id: 'Hari ini dimulai atau diisi dengan sesuatu yang bermakna.',
          en: 'Today was shaped by purposeful activity.',
        ),
        tone: InsightTone.meaningful,
      );
    }

    // Entertainment dominan dengan screen time tinggi
    if (cat == AppCategory.entertainment &&
        level == ScreenTimeLevel.aboveBaseline) {
      return LumaInsight(
        id: InsightId.entertainmentMode,
        depth: depth,
        phrase: _t(
          id: 'Hari ini pikiran lebih banyak menerima dari pada bergerak.',
          en: 'Today, the mind was more in receiving mode than in motion.',
        ),
        tone: InsightTone.reflective,
      );
    }

    // Browsing dominan
    if (cat == AppCategory.browsing) {
      return LumaInsight(
        id: InsightId.curiosityDriven,
        depth: depth,
        phrase: _t(
          id: 'Ada rasa ingin tahu yang mendorong hari ini.',
          en: 'Curiosity seemed to lead the way today.',
        ),
        tone: InsightTone.reflective,
      );
    }

    // Above baseline tanpa pola khusus
    if (level == ScreenTimeLevel.aboveBaseline) {
      return LumaInsight(
        id: InsightId.screenPresent,
        depth: depth,
        phrase: _t(
          id: 'Hari ini layar lebih banyak hadir dari biasanya.',
          en: 'The screen was more present than usual today.',
        ),
        tone: InsightTone.different,
      );
    }

    // Below baseline tanpa pola "rare" — masih layak diobservasi
    if (level == ScreenTimeLevel.belowBaseline) {
      return LumaInsight(
        id: InsightId.screenQuiet,
        depth: depth,
        phrase: _t(
          id: 'Layar terasa lebih sunyi dari biasanya hari ini.',
          en: 'The screen felt quieter than usual today.',
        ),
        tone: InsightTone.calm,
      );
    }

    return null;
  }

  // ──────────────────────────────────────────────────────────────
  // LAYER 2: Temporal — pagi / malam
  // ──────────────────────────────────────────────────────────────

  LumaInsight? _generateTemporalInsight(BehaviorSnapshot s, DepthLevel depth) {
    // Malam larut
    if (s.hasLateNightActivity) {
      final isReceiving = s.dominantCategory == AppCategory.entertainment ||
          s.dominantCategory == AppCategory.social;
      return LumaInsight(
        id: InsightId.lateNightActivity,
        depth: depth,
        phrase: _t(
          id: 'Malam ini berbeda dari biasanya — layar masih menyala lebih lama.',
          en: 'Tonight felt different — the screen stayed on longer than usual.',
        ),
        subPhrase: isReceiving
            ? _t(
                id: 'Malam mengalir lebih panjang dari yang direncanakan.',
                en: 'The night stretched longer than planned.',
              )
            : null,
        tone: InsightTone.different,
      );
    }

    // Pagi hari yang aktif
    if (s.hasMorningRoutine &&
        s.peakTimeZone == ActivityTimeZone.earlyMorning) {
      return LumaInsight(
        id: InsightId.morningStart,
        depth: depth,
        phrase: _t(
          id: 'Hari ini dimulai lebih awal dari biasanya.',
          en: 'The day began earlier than usual.',
        ),
        tone: InsightTone.calm,
      );
    }

    // Puncak malam (tapi bukan larut)
    if (s.peakTimeZone == ActivityTimeZone.evening) {
      return LumaInsight(
        id: InsightId.eveningFlow,
        depth: depth,
        phrase: _t(
          id: "Aktivitas hari ini terasa mengalir di malam hari.",
          en: "Today's energy seemed to flow toward the evening.",
        ),
        tone: InsightTone.reflective,
      );
    }

    return null;
  }

  // ──────────────────────────────────────────────────────────────
  // LAYER 3: Rhythm — pola perpindahan & frekuensi buka layar
  // ──────────────────────────────────────────────────────────────

  LumaInsight? _generateRhythmInsight(BehaviorSnapshot s, DepthLevel depth) {
    // Layar sering dibuka — mungkin menunggu notifikasi
    if (s.screenOpenLevel == ScreenOpenLevel.frequent &&
        s.switchFrequency == SwitchFrequency.scattered) {
      return LumaInsight(
        id: InsightId.waitingBehavior,
        depth: depth,
        phrase: _t(
          id: 'Layar dibuka berkali-kali hari ini — mungkin sedang menunggu sesuatu.',
          en: 'The screen was unlocked many times today — perhaps waiting for something.',
        ),
        tone: InsightTone.different,
      );
    }

    // Sangat tersebar — pikiran berpindah-pindah
    if (s.switchFrequency == SwitchFrequency.scattered) {
      return LumaInsight(
        id: InsightId.scatteredAttention,
        depth: depth,
        phrase: _t(
          id: 'Pikiran hari ini terasa seperti air yang mencari arah.',
          en: 'The mind today felt like water searching for direction.',
        ),
        tone: InsightTone.reflective,
      );
    }

    // Sangat fokus
    if (s.switchFrequency == SwitchFrequency.focused &&
        s.screenOpenLevel != ScreenOpenLevel.frequent) {
      return LumaInsight(
        id: InsightId.deepFocusSession,
        depth: depth,
        phrase: _t(
          id: 'Ada ketenangan dalam ritme hari ini — sedikit berpindah-pindah.',
          en: "A quietness lived in today's rhythm — few transitions.",
        ),
        tone: InsightTone.calm,
      );
    }

    return null;
  }

  // ──────────────────────────────────────────────────────────────
  // Fallbacks & specials
  // ──────────────────────────────────────────────────────────────

  LumaInsight _firstDayInsight() {
    return LumaInsight(
      id: InsightId.screenQuiet,
      depth: DepthLevel.surface,
      phrase: _t(
        id: 'Luma baru mulai mengenal ritmu.',
        en: 'Luma is just beginning to know your rhythm.',
      ),
      subPhrase: _t(
        id: 'Dalam beberapa hari ke depan, cerminan pertama akan muncul.',
        en: 'In the coming days, the first reflection will appear.',
      ),
      tone: InsightTone.calm,
    );
  }

  LumaInsight _defaultObservation() {
    return LumaInsight(
      id: InsightId.screenQuiet,
      depth: DepthLevel.surface,
      phrase: _t(
        id: 'Hari ini berjalan dengan ritmenya sendiri.',
        en: 'Today moved at its own rhythm.',
      ),
      tone: InsightTone.neutral,
    );
  }

  /// Helper bilingual: pilih teks sesuai bahasa aktif
  String _t({required String id, required String en}) {
    return language == LumaLanguage.indonesian ? id : en;
  }
}
