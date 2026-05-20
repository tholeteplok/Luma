library;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:luma/data/db/models/daily_summary_model.dart';
import 'package:luma/domain/entities/ambience_profile.dart';

/// WeeklyRhythmCalculator — Menghitung kondisi ritme mingguan.
///
/// Sumber data: DailySummary.focusScore (0–100) dari 7 hari terakhir.
/// Tidak perlu schema migration — focusScore sudah ada di DB.
///
/// Mapping per hari:
///   focusScore > 60 → "focused"
///   focusScore < 35 → "scattered"
///   35–60           → "moderate"
class WeeklyRhythmCalculator {
  static const _stateKey = 'luma_ambience_rhythm_state';
  static const _minDaysRequired = 5; // dari 7 hari

  static const _focusedThreshold  = 60.0;
  static const _scatteredThreshold = 35.0;
  static const _clearRatio  = 0.571; // ≥4/7
  static const _dimRatio    = 0.571;

  /// Hitung WeeklyRhythmState dari 7 hari terakhir.
  ///
  /// [last7Days] — DailySummary 7 hari terakhir (sudah ada di HomeNotifier)
  /// [prefs] — untuk persist state dan fallback
  static Future<WeeklyRhythmState> compute(
    List<DailySummary> last7Days,
    SharedPreferences prefs,
  ) async {
    // Guard: data tidak cukup → pertahankan state sebelumnya
    if (last7Days.length < _minDaysRequired) {
      return _loadCurrentState(prefs);
    }

    // Klasifikasikan setiap hari
    final categories = last7Days.map(_classifyDay).toList();
    final total = categories.length;

    final focusedCount  = categories.where((c) => c == _DayCategory.focused).length;
    final scatteredCount = categories.where((c) => c == _DayCategory.scattered).length;

    // Hitung variasi (perubahan kategori berturut-turut)
    int transitions = 0;
    for (int i = 1; i < categories.length; i++) {
      if (categories[i] != categories[i - 1] &&
          categories[i] != _DayCategory.moderate &&
          categories[i - 1] != _DayCategory.moderate) {
        transitions++;
      }
    }

    // Tentukan state
    WeeklyRhythmState newState;

    if (focusedCount / total >= _clearRatio) {
      newState = WeeklyRhythmState.clear;
    } else if (scatteredCount / total >= _dimRatio) {
      newState = WeeklyRhythmState.dim;
    } else if (transitions >= 3) {
      // Bergantian focused-scattered ≥3 kali
      newState = WeeklyRhythmState.undulating;
    } else if (transitions <= 1) {
      // Hampir tidak ada perubahan
      newState = WeeklyRhythmState.stable;
    } else {
      // Default: pertahankan state sebelumnya
      newState = _loadCurrentState(prefs);
    }

    await prefs.setString(_stateKey, newState.name);
    return newState;
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  static _DayCategory _classifyDay(DailySummary day) {
    if (day.focusScore > _focusedThreshold) return _DayCategory.focused;
    if (day.focusScore < _scatteredThreshold) return _DayCategory.scattered;
    return _DayCategory.moderate;
  }

  static WeeklyRhythmState _loadCurrentState(SharedPreferences prefs) {
    final raw = prefs.getString(_stateKey);
    if (raw == null) return WeeklyRhythmState.stable;
    return WeeklyRhythmState.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => WeeklyRhythmState.stable,
    );
  }
}

enum _DayCategory { focused, moderate, scattered }
