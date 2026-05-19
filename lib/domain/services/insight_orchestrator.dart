library;

import 'dart:math';

import 'package:luma/core/utils/luma_language.dart';
import 'package:luma/domain/entities/behavior_snapshot.dart';
import 'package:luma/domain/entities/insight_id.dart';
import 'package:luma/domain/services/dimension_rotation.dart';
import 'package:luma/domain/services/insight_language_engine.dart';
import 'package:luma/domain/services/insight_memory.dart';

/// Hasil keputusan orchestrator untuk satu hari.
class OrchestratorDecision {
  /// Daftar insight yang akan ditampilkan (bisa kosong jika silent).
  final List<LumaInsight> insights;

  /// Apakah Luma memilih diam hari ini.
  final bool isSilent;

  /// Alasan diam — untuk debugging / UI hint, tidak ditampilkan kasar.
  final SilenceReason? silenceReason;

  /// Dimensi perhatian aktif minggu ini.
  final InsightDimension activeDimension;

  /// Kedalaman observasi aktif (berdasarkan jumlah hari data).
  final DepthLevel depth;

  const OrchestratorDecision({
    required this.insights,
    required this.isSilent,
    required this.activeDimension,
    required this.depth,
    this.silenceReason,
  });
}

/// Alasan kenapa Luma memilih diam hari ini.
enum SilenceReason {
  /// Tidak cukup perubahan dari hari sebelumnya
  noSignificantChange,

  /// Semua kandidat masih dalam cooldown
  allOnCooldown,

  /// Sudah dua hari berturut bicara — kasih ruang
  cadenceRest,

  /// Terlalu banyak insight dalam 7 hari — overload protection
  recentOverload,
}

/// InsightOrchestrator — Otak yang memutuskan
/// "hari ini Luma bicara apa, atau diam."
///
/// Mengkoordinasikan:
///   - InsightLanguageEngine (yang menghasilkan kandidat)
///   - InsightMemory (yang ingat siapa yang sudah lewat)
///   - DimensionRotation (yang memilih fokus minggu ini)
///   - ProgressiveDepth (yang mendalamkan observasi seiring waktu)
///   - SilenceDecision (yang berani diam)
///
/// Engine TIDAK tahu cooldown / dimensi.
/// Memory TIDAK tahu cara bicara.
/// Orchestrator yang menjembatani semuanya.
class InsightOrchestrator {
  final InsightMemory _memory;
  final InsightLanguageEngine? _defaultEngine;
  final Random _random;

  /// Target probabilitas diam saat tidak ada alasan kuat: 0.0–1.0
  /// Default 0.45 → ~45% hari diam, sisanya bicara.
  final double silenceProbability;

  /// Maksimum insight per hari
  final int maxInsightsPerDay;

  InsightOrchestrator({
    required InsightMemory memory,
    InsightLanguageEngine? engine,
    Random? random,
    this.silenceProbability = 0.45,
    this.maxInsightsPerDay = 2,
  })  : _defaultEngine = engine,
        _memory = memory,
        _random = random ?? Random();

  /// Engine untuk bahasa tertentu — gunakan injected default jika cocok,
  /// kalau tidak buat baru (tetap stateless & murah).
  InsightLanguageEngine _engineFor(LumaLanguage language) {
    final base = _defaultEngine;
    if (base != null && base.language == language) return base;
    return InsightLanguageEngine(language: language);
  }

  /// Hitung dimensi & depth untuk snapshot tertentu — exposed untuk UI.
  ({InsightDimension dimension, DepthLevel depth}) getContext(
    BehaviorSnapshot snapshot, {
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    return (
      dimension: DimensionRotation.getDimension(today),
      depth: ProgressiveDepth.getLevel(snapshot.baselineDaysAvailable),
    );
  }

  /// Putuskan apa yang akan Luma sampaikan hari ini.
  ///
  /// [snapshot] — data perilaku hari ini
  /// [language] — bahasa output (engine baru dibuat tiap call agar bisa berubah)
  /// [now] — waktu saat ini (default: real now, override untuk testing)
  /// [previousSnapshot] — opsional, untuk deteksi delta (silenceReason)
  Future<OrchestratorDecision> decide(
    BehaviorSnapshot snapshot, {
    LumaLanguage language = LumaLanguage.indonesian,
    DateTime? now,
    BehaviorSnapshot? previousSnapshot,
  }) async {
    final today = now ?? DateTime.now();
    final dimension = DimensionRotation.getDimension(today);
    final depth = ProgressiveDepth.getLevel(snapshot.baselineDaysAvailable);

    // Hari pertama — selalu sapa, jangan diam
    if (!snapshot.hasMeaningfulData) {
      final engine = _engineFor(language);
      final firstDay = engine.generate(snapshot);
      await _persistInsights(firstDay);
      return OrchestratorDecision(
        insights: firstDay,
        isSilent: false,
        activeDimension: dimension,
        depth: depth,
      );
    }

    // 1) Generate kandidat dengan depth aware
    final engine = _engineFor(language);
    final allCandidates = engine.generateCandidates(snapshot, depth: depth);

    // 2) Filter: ID harus tersedia (cooldown habis + threshold data terpenuhi)
    final candidateIds = allCandidates.map((c) => c.id).toList();
    final availableIds = _memory.filterAvailable(
      candidateIds,
      snapshot.baselineDaysAvailable,
    );
    final available = allCandidates
        .where((c) => availableIds.contains(c.id))
        .toList();

    // 3) Cek apakah harus diam
    final silence = _shouldBeSilent(
      snapshot: snapshot,
      previous: previousSnapshot,
      hasAvailable: available.isNotEmpty,
      now: today,
    );
    if (silence != null) {
      return OrchestratorDecision(
        insights: const [],
        isSilent: true,
        silenceReason: silence,
        activeDimension: dimension,
        depth: depth,
      );
    }

    // 4) Skor & pilih (sortir berdasar bobot dimensi, ambil maksimum N)
    final scored = available
        .map((c) => _ScoredInsight(
              insight: c,
              score: DimensionRotation.getPriorityWeight(c.id, today),
            ))
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    final selected = scored.take(maxInsightsPerDay).map((e) => e.insight).toList();

    if (selected.isEmpty) {
      // Tidak ada yang lolos — hari yang tenang, biarkan diam.
      return OrchestratorDecision(
        insights: const [],
        isSilent: true,
        silenceReason: SilenceReason.allOnCooldown,
        activeDimension: dimension,
        depth: depth,
      );
    }

    // 5) Catat ke memory + history
    await _persistInsights(selected);

    return OrchestratorDecision(
      insights: selected,
      isSilent: false,
      activeDimension: dimension,
      depth: depth,
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Silence Decision
  // ──────────────────────────────────────────────────────────────

  /// Putuskan apakah Luma harus diam — dan kenapa.
  /// Return null artinya boleh bicara.
  SilenceReason? _shouldBeSilent({
    required BehaviorSnapshot snapshot,
    required BehaviorSnapshot? previous,
    required bool hasAvailable,
    required DateTime now,
  }) {
    if (!hasAvailable) return SilenceReason.allOnCooldown;

    // Overload protection: terlalu banyak insight 7 hari terakhir
    final recent7 = _memory
        .getHistory()
        .where((r) => now.difference(r.shownAt).inDays < 7)
        .length;
    if (recent7 >= 5) {
      return SilenceReason.recentOverload;
    }

    // Cadence rest: kemarin & 2 hari lalu sudah bicara
    final history = _memory.getHistory();
    final spokeYesterday = history.any(
      (r) => _isSameDay(r.shownAt, now.subtract(const Duration(days: 1))),
    );
    final spokeTwoDaysAgo = history.any(
      (r) => _isSameDay(r.shownAt, now.subtract(const Duration(days: 2))),
    );
    if (spokeYesterday && spokeTwoDaysAgo) {
      // 70% kemungkinan diam setelah 2 hari berturut bicara
      if (_random.nextDouble() < 0.7) return SilenceReason.cadenceRest;
    }

    // No significant change — jika snapshot mirip kemarin, lebih hening
    if (previous != null && _snapshotsAreSimilar(snapshot, previous)) {
      if (_random.nextDouble() < 0.6) {
        return SilenceReason.noSignificantChange;
      }
    }

    // Probabilistic silence — Luma kadang memilih hadir tanpa berkata.
    if (_random.nextDouble() < silenceProbability) {
      return SilenceReason.cadenceRest;
    }

    return null;
  }

  bool _snapshotsAreSimilar(BehaviorSnapshot a, BehaviorSnapshot b) {
    return a.dominantCategory == b.dominantCategory &&
        a.screenTimeLevel == b.screenTimeLevel &&
        a.switchFrequency == b.switchFrequency &&
        a.peakTimeZone == b.peakTimeZone &&
        a.hasLateNightActivity == b.hasLateNightActivity;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _persistInsights(List<LumaInsight> selected) async {
    if (selected.isEmpty) return;
    final ids = selected.map((i) => i.id).toList();
    await _memory.recordAll(ids);
    final now = DateTime.now();
    for (final insight in selected) {
      await _memory.saveToHistory(LumaInsightRecord(
        insightId: insight.id,
        phrase: insight.phrase,
        subPhrase: insight.subPhrase,
        shownAt: now,
        tone: insight.tone.name,
      ));
    }
  }
}

class _ScoredInsight {
  final LumaInsight insight;
  final double score;
  const _ScoredInsight({required this.insight, required this.score});
}
