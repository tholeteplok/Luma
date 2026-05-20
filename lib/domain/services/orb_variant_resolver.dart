library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luma/domain/entities/ambience_profile.dart';
import 'package:luma/domain/entities/behavior_snapshot.dart';
import 'package:luma/domain/services/orb_state_engine.dart';

/// OrbVariantResolver — Menentukan OrbVariant dari OrbState + kondisi khusus.
///
/// Hierarki prioritas: stellar > recover > dusk > base OrbState
///
/// Varian khusus:
/// - dusk: aktivitas malam tinggi ≥5/7 hari
/// - recover: setelah mist, recovery ≥3 hari berturut-turut
/// - stellar: focused + belowBaseline ≥3 hari setelah periode scattered
class OrbVariantResolver {
  static const _lateNightHistoryKey = 'luma_ambience_late_night_history';
  static const _prevVariantKey      = 'luma_ambience_prev_variant';
  static const _recoverDaysKey      = 'luma_ambience_recover_days';
  static const _stellarDaysKey      = 'luma_ambience_stellar_days';
  static const _hadScatteredKey     = 'luma_ambience_had_scattered';

  static const _maxLateNightHistory = 7;
  static const _duskThreshold       = 5; // dari 7 hari
  static const _recoverThreshold    = 3; // hari berturut-turut
  static const _stellarThreshold    = 3; // hari berturut-turut

  /// Resolve OrbVariant dari base OrbState + snapshot hari ini.
  static Future<OrbVariant> resolve(
    OrbState base,
    BehaviorSnapshot snapshot,
    SharedPreferences prefs,
  ) async {
    // 1. Update histories
    await _updateLateNightHistory(snapshot.hasLateNightActivity, prefs);
    await _updateStellarTracking(snapshot, prefs);
    await _updateRecoverTracking(base, snapshot, prefs);

    // 2. Cek kondisi varian khusus (hierarki: stellar > recover > dusk)
    if (_checkStellar(prefs)) {
      debugPrint('[OrbVariantResolver] → stellar');
      return OrbVariant.stellar;
    }

    if (_checkRecover(base, prefs)) {
      debugPrint('[OrbVariantResolver] → recover');
      return OrbVariant.recover;
    }

    if (_checkDusk(prefs)) {
      debugPrint('[OrbVariantResolver] → dusk');
      return OrbVariant.dusk;
    }

    // 3. Fallback ke base OrbState
    final variant = _orbStateToVariant(base);
    await prefs.setString(_prevVariantKey, variant.name);
    return variant;
  }

  // ── Dusk ──────────────────────────────────────────────────────────────────

  static Future<void> _updateLateNightHistory(
    bool hasLateNight,
    SharedPreferences prefs,
  ) async {
    final history = _loadBoolHistory(prefs, _lateNightHistoryKey);
    history.add(hasLateNight);
    if (history.length > _maxLateNightHistory) history.removeAt(0);
    await _saveBoolHistory(prefs, _lateNightHistoryKey, history);
  }

  static bool _checkDusk(SharedPreferences prefs) {
    final history = _loadBoolHistory(prefs, _lateNightHistoryKey);
    if (history.length < _maxLateNightHistory) return false;
    final lateNightCount = history.where((v) => v).length;
    return lateNightCount >= _duskThreshold;
  }

  // ── Recover ───────────────────────────────────────────────────────────────

  static Future<void> _updateRecoverTracking(
    OrbState base,
    BehaviorSnapshot snapshot,
    SharedPreferences prefs,
  ) async {
    final prevVariantRaw = prefs.getString(_prevVariantKey);
    final wasMist = prevVariantRaw == OrbVariant.mist.name ||
        base == OrbState.mist;

    final isRecovering = snapshot.switchFrequency == SwitchFrequency.focused ||
        snapshot.screenTimeLevel == ScreenTimeLevel.belowBaseline;

    if (wasMist && isRecovering) {
      final days = (prefs.getInt(_recoverDaysKey) ?? 0) + 1;
      await prefs.setInt(_recoverDaysKey, days);
    } else if (!wasMist) {
      // Reset jika tidak lagi dari mist
      await prefs.setInt(_recoverDaysKey, 0);
    }
  }

  static bool _checkRecover(OrbState base, SharedPreferences prefs) {
    final prevVariantRaw = prefs.getString(_prevVariantKey);
    final wasMist = prevVariantRaw == OrbVariant.mist.name ||
        base == OrbState.mist;
    if (!wasMist) return false;

    final recoverDays = prefs.getInt(_recoverDaysKey) ?? 0;
    return recoverDays >= _recoverThreshold;
  }

  // ── Stellar ───────────────────────────────────────────────────────────────

  static Future<void> _updateStellarTracking(
    BehaviorSnapshot snapshot,
    SharedPreferences prefs,
  ) async {
    final isScattered = snapshot.switchFrequency == SwitchFrequency.scattered;
    final isStellarCondition =
        snapshot.switchFrequency == SwitchFrequency.focused &&
        snapshot.screenTimeLevel == ScreenTimeLevel.belowBaseline;

    if (isScattered) {
      // Tandai bahwa ada periode scattered
      await prefs.setBool(_hadScatteredKey, true);
      await prefs.setInt(_stellarDaysKey, 0); // reset stellar counter
    } else if (isStellarCondition && (prefs.getBool(_hadScatteredKey) ?? false)) {
      // Kondisi stellar terpenuhi setelah periode scattered
      final days = (prefs.getInt(_stellarDaysKey) ?? 0) + 1;
      await prefs.setInt(_stellarDaysKey, days);
    } else if (!isStellarCondition) {
      // Reset jika kondisi tidak terpenuhi
      await prefs.setInt(_stellarDaysKey, 0);
    }
  }

  static bool _checkStellar(SharedPreferences prefs) {
    final hadScattered = prefs.getBool(_hadScatteredKey) ?? false;
    if (!hadScattered) return false;
    final stellarDays = prefs.getInt(_stellarDaysKey) ?? 0;
    return stellarDays >= _stellarThreshold;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static OrbVariant _orbStateToVariant(OrbState state) {
    return switch (state) {
      OrbState.dawn => OrbVariant.dawn,
      OrbState.calm => OrbVariant.calm,
      OrbState.wave => OrbVariant.wave,
      OrbState.mist => OrbVariant.mist,
    };
  }

  static List<bool> _loadBoolHistory(SharedPreferences prefs, String key) {
    final raw = prefs.getString(key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>).cast<bool>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveBoolHistory(
    SharedPreferences prefs,
    String key,
    List<bool> history,
  ) async {
    await prefs.setString(key, jsonEncode(history));
  }
}
