library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luma/data/db/models/daily_summary_model.dart';
import 'package:luma/domain/entities/ambience_profile.dart';
import 'package:luma/domain/entities/behavior_snapshot.dart';
import 'package:luma/domain/services/biological_time_calculator.dart';
import 'package:luma/domain/services/orb_state_engine.dart';
import 'package:luma/domain/services/orb_variant_resolver.dart';
import 'package:luma/domain/services/weekly_rhythm_calculator.dart';

/// AdaptiveAmbienceEngine — Koordinator semua komponen Adaptive Ambience.
///
/// Menghasilkan [AmbienceProfile] dari:
/// - OrbStateEngine (sudah ada) → base OrbState
/// - BiologicalTimeCalculator → BiologicalTimePhase dari peakTimeZone 14 hari
/// - WeeklyRhythmCalculator → WeeklyRhythmState dari focusScore 7 hari
/// - OrbVariantResolver → OrbVariant final (dengan override dusk/recover/stellar)
///
/// Prinsip:
/// - Idempotent: evaluasi hanya 1x per hari
/// - Guard: jika data <7 hari, return AmbienceProfile.defaults()
/// - Fallback: jika engine gagal, return defaults() tanpa crash
/// - Tidak ada query DB tambahan — semua data diteruskan dari HomeNotifier
class AdaptiveAmbienceEngine {
  static const _profileKey      = 'luma_ambience_profile_json';
  static const _lastEvalDateKey = 'luma_ambience_last_eval_date';
  static const _minDaysRequired = 7;

  /// Evaluasi dan return AmbienceProfile untuk hari ini.
  ///
  /// [snapshot] — BehaviorSnapshot hari ini
  /// [last7Days] — DailySummary 7 hari terakhir (dari HomeNotifier, tidak ada query tambahan)
  /// [prefs] — SharedPreferences untuk persist dan idempotency
  static Future<AmbienceProfile> evaluate(
    BehaviorSnapshot snapshot,
    List<DailySummary> last7Days,
    SharedPreferences prefs,
  ) async {
    // 1. Idempotency — hanya evaluasi sekali per hari
    if (_alreadyEvaluatedToday(prefs)) {
      return _loadCachedProfile(prefs) ?? AmbienceProfile.defaults();
    }

    // 2. Guard — data belum cukup
    if (snapshot.baselineDaysAvailable < _minDaysRequired) {
      debugPrint('[AdaptiveAmbienceEngine] Data belum cukup '
          '(${snapshot.baselineDaysAvailable}/$_minDaysRequired hari)');
      return AmbienceProfile.defaults();
    }

    try {
      // 3. Hitung semua komponen
      final orbState = await OrbStateEngine.evaluate(snapshot, prefs);

      final timePhase = await BiologicalTimeCalculator.compute(
        snapshot.peakTimeZone,
        prefs,
      );

      final rhythmState = await WeeklyRhythmCalculator.compute(
        last7Days,
        prefs,
      );

      final orbVariant = await OrbVariantResolver.resolve(
        orbState,
        snapshot,
        prefs,
      );

      // 4. Buat profile baru
      final newProfile = AmbienceProfile(
        orbVariant: orbVariant,
        timePhase: timePhase,
        rhythmState: rhythmState,
        nostalgiaActive: false, // diset oleh HomeNotifier berdasarkan history
        calculatedAt: DateTime.now(),
      );

      // 5. Log transisi jika variant berubah
      final oldProfile = _loadCachedProfile(prefs);
      if (oldProfile != null && oldProfile.orbVariant != newProfile.orbVariant) {
        debugPrint('[AdaptiveAmbienceEngine] Transisi variant: '
            '${oldProfile.orbVariant.name} → ${newProfile.orbVariant.name}');
      }

      // 6. Persist
      await _saveProfile(prefs, newProfile);
      await prefs.setString(
        _lastEvalDateKey,
        DateTime.now().toIso8601String(),
      );

      debugPrint('[AdaptiveAmbienceEngine] Profile: $newProfile');
      return newProfile;
    } catch (e, stack) {
      // 7. Fallback — jangan crash UI
      debugPrint('[AdaptiveAmbienceEngine] Error: $e\n$stack');
      return _loadCachedProfile(prefs) ?? AmbienceProfile.defaults();
    }
  }

  /// Baca profile terakhir tanpa evaluasi ulang.
  static AmbienceProfile? current(SharedPreferences prefs) {
    return _loadCachedProfile(prefs);
  }

  /// Reset semua state (untuk testing / onboarding ulang).
  static Future<void> reset(SharedPreferences prefs) async {
    final keysToRemove = prefs
        .getKeys()
        .where((k) => k.startsWith('luma_ambience_'))
        .toList();
    for (final key in keysToRemove) {
      await prefs.remove(key);
    }
    debugPrint('[AdaptiveAmbienceEngine] Reset complete');
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  static bool _alreadyEvaluatedToday(SharedPreferences prefs) {
    final raw = prefs.getString(_lastEvalDateKey);
    if (raw == null) return false;
    final lastEval = DateTime.tryParse(raw);
    if (lastEval == null) return false;
    final now = DateTime.now();
    return lastEval.year == now.year &&
        lastEval.month == now.month &&
        lastEval.day == now.day;
  }

  static AmbienceProfile? _loadCachedProfile(SharedPreferences prefs) {
    final raw = prefs.getString(_profileKey);
    return AmbienceProfile.fromPrefsString(raw);
  }

  static Future<void> _saveProfile(
    SharedPreferences prefs,
    AmbienceProfile profile,
  ) async {
    await prefs.setString(_profileKey, profile.toPrefsString());
  }
}
