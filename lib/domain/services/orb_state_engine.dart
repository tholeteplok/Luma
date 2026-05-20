library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luma/domain/entities/behavior_snapshot.dart';

/// OrbState — 4 state Fase 1 dari Adaptive Orb.
///
/// Urutan evolusi:
///   Dawn → Calm (data cukup, fokus stabil)
///         ↓ ↑
///        Wave (distraksi tinggi)
///         ↓
///        Mist (burnout accumulation)
///
/// State disimpan di SharedPreferences agar persisten antar sesi.
/// Transisi bertahap — user mungkin tidak sadar sampai suatu hari
/// menyadari "oh, Orb-nya berbeda."
enum OrbState {
  /// Fajar — default, 0–13 hari pertama.
  /// Luma masih belajar, belum punya bentuk.
  dawn,

  /// Tenang — pola stabil, fokus baik.
  /// 14+ hari data, fokus konsisten.
  calm,

  /// Gelombang — distraksi tinggi, switching pattern.
  /// Orb terlihat gelisah halus.
  wave,

  /// Kabut — burnout accumulation.
  /// Orb hampir tidak bergerak, hanya hadir.
  mist,
}

/// OrbStateEngine — Menghitung dan mempersistensikan OrbState.
///
/// Prinsip:
/// - State dihitung dari snapshot + history multi-hari
/// - Transisi tidak tiba-tiba: butuh beberapa hari konsisten
/// - State disimpan di SharedPrefs — tidak reset setiap buka app
/// - Engine tidak tahu tentang UI, hanya tentang data
class OrbStateEngine {
  static const _stateKey = 'luma_orb_state';
  static const _consecutiveDaysKey = 'luma_orb_consecutive_days';
  static const _lastEvalDateKey = 'luma_orb_last_eval_date';

  // ── Threshold transisi ──────────────────────────────────────────────────────

  /// Hari data minimum sebelum bisa keluar dari Dawn
  static const _dawnExitDays = 14;

  /// Berapa hari berturut-turut kondisi harus terpenuhi sebelum transisi
  static const _transitionDaysRequired = 3;

  /// Berapa hari berturut-turut kondisi harus terpenuhi untuk keluar Mist
  static const _mistExitDaysRequired = 5;

  // ── Threshold kondisi ───────────────────────────────────────────────────────

  /// SwitchFrequency.scattered berturut-turut → Wave
  static const _waveConsecutiveDays = 2;

  /// Berapa hari scattered sebelum masuk Mist
  static const _mistConsecutiveDays = 4;

  // ─── Public API ─────────────────────────────────────────────────────────────

  /// Evaluasi dan update OrbState berdasarkan snapshot hari ini.
  ///
  /// Dipanggil sekali per hari saat `loadData()`.
  /// Return state yang aktif (mungkin sama dengan sebelumnya).
  static Future<OrbState> evaluate(
    BehaviorSnapshot snapshot,
    SharedPreferences prefs,
  ) async {
    final today = DateTime.now();
    final lastEvalStr = prefs.getString(_lastEvalDateKey);
    final lastEvalDate = lastEvalStr != null
        ? DateTime.tryParse(lastEvalStr)
        : null;

    // Hanya evaluasi sekali per hari
    final alreadyEvaluatedToday = lastEvalDate != null &&
        _isSameDay(lastEvalDate, today);

    final currentState = _loadState(prefs);

    if (alreadyEvaluatedToday) {
      return currentState;
    }

    // Hitung state baru
    final newState = _computeNextState(
      current: currentState,
      snapshot: snapshot,
      prefs: prefs,
    );

    // Persist
    await prefs.setString(_stateKey, newState.name);
    await prefs.setString(_lastEvalDateKey, today.toIso8601String());

    if (newState != currentState) {
      debugPrint('[OrbStateEngine] Transisi: ${currentState.name} → ${newState.name}');
    }

    return newState;
  }

  /// Baca state saat ini tanpa evaluasi ulang.
  static OrbState current(SharedPreferences prefs) => _loadState(prefs);

  /// Reset ke Dawn (untuk testing / onboarding ulang).
  static Future<void> reset(SharedPreferences prefs) async {
    await prefs.setString(_stateKey, OrbState.dawn.name);
    await prefs.remove(_consecutiveDaysKey);
    await prefs.remove(_lastEvalDateKey);
  }

  // ─── Internal ───────────────────────────────────────────────────────────────

  static OrbState _loadState(SharedPreferences prefs) {
    final raw = prefs.getString(_stateKey);
    if (raw == null) return OrbState.dawn;
    return OrbState.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => OrbState.dawn,
    );
  }

  static OrbState _computeNextState({
    required OrbState current,
    required BehaviorSnapshot snapshot,
    required SharedPreferences prefs,
  }) {
    final days = snapshot.baselineDaysAvailable;
    final isScattered = snapshot.switchFrequency == SwitchFrequency.scattered;
    final isFocused = snapshot.switchFrequency == SwitchFrequency.focused;
    final isScreenHigh = snapshot.screenTimeLevel == ScreenTimeLevel.aboveBaseline;
    final isScreenLow = snapshot.screenTimeLevel == ScreenTimeLevel.belowBaseline;

    // Hitung consecutive days untuk kondisi saat ini
    final consecutiveDays = _updateConsecutiveDays(
      prefs: prefs,
      isScattered: isScattered,
      isFocused: isFocused,
    );

    return switch (current) {
      // ── Dawn: keluar setelah 14 hari + kondisi stabil ──────────────────────
      OrbState.dawn => _evaluateDawn(
          days: days,
          isScattered: isScattered,
          consecutiveDays: consecutiveDays,
        ),

      // ── Calm: bisa ke Wave (distraksi) atau tetap ──────────────────────────
      OrbState.calm => _evaluateCalm(
          isScattered: isScattered,
          isScreenHigh: isScreenHigh,
          consecutiveDays: consecutiveDays,
        ),

      // ── Wave: bisa ke Calm (pulih) atau Mist (burnout) ─────────────────────
      OrbState.wave => _evaluateWave(
          isFocused: isFocused,
          isScattered: isScattered,
          consecutiveDays: consecutiveDays,
        ),

      // ── Mist: keluar lebih lambat, butuh recovery yang konsisten ───────────
      OrbState.mist => _evaluateMist(
          isFocused: isFocused,
          isScreenLow: isScreenLow,
          consecutiveDays: consecutiveDays,
        ),
    };
  }

  static OrbState _evaluateDawn({
    required int days,
    required bool isScattered,
    required int consecutiveDays,
  }) {
    if (days < _dawnExitDays) return OrbState.dawn;

    // Cukup data — tapi kalau sudah scattered, langsung ke Wave
    if (isScattered && consecutiveDays >= _waveConsecutiveDays) {
      return OrbState.wave;
    }

    // Data cukup dan tidak scattered → Calm
    return OrbState.calm;
  }

  static OrbState _evaluateCalm({
    required bool isScattered,
    required bool isScreenHigh,
    required int consecutiveDays,
  }) {
    // Scattered + screen tinggi berturut-turut → Wave
    if (isScattered && consecutiveDays >= _waveConsecutiveDays) {
      return OrbState.wave;
    }
    return OrbState.calm;
  }

  static OrbState _evaluateWave({
    required bool isFocused,
    required bool isScattered,
    required int consecutiveDays,
  }) {
    // Scattered terlalu lama → Mist
    if (isScattered && consecutiveDays >= _mistConsecutiveDays) {
      return OrbState.mist;
    }

    // Fokus kembali berturut-turut → Calm
    if (isFocused && consecutiveDays >= _transitionDaysRequired) {
      return OrbState.calm;
    }

    return OrbState.wave;
  }

  static OrbState _evaluateMist({
    required bool isFocused,
    required bool isScreenLow,
    required int consecutiveDays,
  }) {
    // Recovery: fokus kembali + layar lebih tenang, konsisten beberapa hari
    final isRecovering = isFocused || isScreenLow;
    if (isRecovering && consecutiveDays >= _mistExitDaysRequired) {
      return OrbState.calm;
    }
    return OrbState.mist;
  }

  /// Update dan baca consecutive days counter.
  ///
  /// Counter naik jika kondisi hari ini sama dengan kemarin,
  /// reset ke 1 jika berbeda.
  ///
  /// "Kondisi" disederhanakan ke: scattered vs tidak-scattered.
  static int _updateConsecutiveDays({
    required SharedPreferences prefs,
    required bool isScattered,
    required bool isFocused,
  }) {
    final conditionKey = 'luma_orb_last_condition';
    final lastCondition = prefs.getString(conditionKey);
    final currentCondition = isScattered
        ? 'scattered'
        : isFocused
            ? 'focused'
            : 'moderate';

    int consecutive;
    if (lastCondition == currentCondition) {
      consecutive = (prefs.getInt(_consecutiveDaysKey) ?? 1) + 1;
    } else {
      consecutive = 1;
    }

    // Fire-and-forget — tidak perlu await di sini
    prefs.setInt(_consecutiveDaysKey, consecutive);
    prefs.setString(conditionKey, currentCondition);

    return consecutive;
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
