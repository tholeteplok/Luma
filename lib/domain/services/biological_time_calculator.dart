library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luma/domain/entities/ambience_profile.dart';
import 'package:luma/domain/entities/behavior_snapshot.dart';

/// BiologicalTimeCalculator — Menghitung fase waktu biologis personal.
///
/// Berbeda dari jam sistem: user yang aktif jam 11 malam punya
/// `personalNight`, bukan `personalMidday`.
///
/// Threshold: butuh ≥10 dari 14 hari mendukung fase baru untuk berubah.
/// Ini mencegah satu minggu anomali mengubah profil yang sudah terbentuk.
class BiologicalTimeCalculator {
  static const _historyKey = 'luma_ambience_bio_history';
  static const _phaseKey = 'luma_ambience_bio_phase';
  static const _maxHistory = 14;
  static const _minDaysForChange = 10; // dari 14 hari

  /// Hitung BiologicalTimePhase dari snapshot hari ini + history.
  ///
  /// [todayZone] — peakTimeZone dari BehaviorSnapshot hari ini
  /// [prefs] — SharedPreferences untuk persist history
  static Future<BiologicalTimePhase> compute(
    ActivityTimeZone todayZone,
    SharedPreferences prefs,
  ) async {
    // 1. Load history
    final history = _loadHistory(prefs);

    // 2. Tambah hari ini
    history.add(todayZone);
    if (history.length > _maxHistory) {
      history.removeAt(0); // FIFO — hapus yang paling lama
    }

    // 3. Persist history
    await _saveHistory(prefs, history);

    // 4. Hitung distribusi
    if (history.length < 7) {
      // Belum cukup data — pertahankan phase sebelumnya atau default
      return _loadCurrentPhase(prefs);
    }

    // 5. Hitung fase dominan dari history
    final phaseCounts = <BiologicalTimePhase, int>{};
    for (final zone in history) {
      final phase = timeZoneToPhase(zone);
      phaseCounts[phase] = (phaseCounts[phase] ?? 0) + 1;
    }

    // 6. Cari fase dengan count tertinggi
    final dominant = phaseCounts.entries
        .reduce((a, b) => a.value >= b.value ? a : b);

    // 7. Threshold: butuh ≥10/14 hari untuk berubah dari phase saat ini
    final currentPhase = _loadCurrentPhase(prefs);
    final dominantCount = dominant.value;
    final totalDays = history.length;

    // Jika fase dominan berbeda dari sekarang, butuh threshold
    if (dominant.key != currentPhase) {
      final ratio = dominantCount / totalDays;
      if (ratio < (_minDaysForChange / _maxHistory)) {
        // Belum cukup bukti — pertahankan phase saat ini
        return currentPhase;
      }
    }

    // 8. Update dan return
    final newPhase = dominant.key;
    await prefs.setString(_phaseKey, newPhase.name);
    return newPhase;
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  static BiologicalTimePhase _loadCurrentPhase(SharedPreferences prefs) {
    final raw = prefs.getString(_phaseKey);
    if (raw == null) return BiologicalTimePhase.personalMidday;
    return BiologicalTimePhase.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => BiologicalTimePhase.personalMidday,
    );
  }

  static List<ActivityTimeZone> _loadHistory(SharedPreferences prefs) {
    final raw = prefs.getString(_historyKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ActivityTimeZone.values.firstWhere(
                (z) => z.name == e,
                orElse: () => ActivityTimeZone.distributed,
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveHistory(
    SharedPreferences prefs,
    List<ActivityTimeZone> history,
  ) async {
    await prefs.setString(
      _historyKey,
      jsonEncode(history.map((z) => z.name).toList()),
    );
  }
}
