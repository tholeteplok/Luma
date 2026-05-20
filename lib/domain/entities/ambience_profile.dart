library;

import 'dart:convert';
import 'package:luma/domain/entities/behavior_snapshot.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ENUMS
// ─────────────────────────────────────────────────────────────────────────────

/// Varian visual Orb — perluasan dari OrbState dengan 3 varian baru.
/// Hierarki prioritas: stellar > recover > dusk > dawn/calm/wave/mist
enum OrbVariant {
  // ── Dari OrbState yang sudah ada ──────────────────────────────────────────
  /// Fajar — 0–13 hari pertama, belum punya bentuk
  dawn,
  /// Tenang — fokus stabil, hijau sage
  calm,
  /// Gelombang — distraksi tinggi, ungu-teal gelisah
  wave,
  /// Kabut — burnout, hampir tidak bergerak
  mist,

  // ── Varian baru ───────────────────────────────────────────────────────────
  /// Senja — aktivitas malam tinggi ≥5/7 hari, oranye redup
  dusk,
  /// Pulih — setelah mist, recovery ≥3 hari, hijau sage muda
  recover,
  /// Bintang — anomali positif langka, krem-gold denyut pelan
  stellar,
}

/// Fase waktu biologis personal — dihitung dari pola aktivitas historis,
/// bukan jam sistem. User shift malam punya `personalMorning` di jam 10 malam.
enum BiologicalTimePhase {
  /// Puncak aktivitas di earlyMorning atau morning
  personalMorning,
  /// Puncak aktivitas di midday atau afternoon (default)
  personalMidday,
  /// Puncak aktivitas di evening
  personalEvening,
  /// Puncak aktivitas di lateNight
  personalNight,
}

/// Kondisi ritme mingguan — dihitung dari distribusi focusScore 7 hari.
enum WeeklyRhythmState {
  /// focusScore > 60 pada ≥4 dari 7 hari
  clear,
  /// focusScore < 35 pada ≥4 dari 7 hari
  dim,
  /// Variasi rendah — max 1 perubahan kategori dalam 7 hari
  stable,
  /// Bergantian focused-scattered ≥3 kali dalam 7 hari
  undulating,
}

// ─────────────────────────────────────────────────────────────────────────────
//  AMBIENCE PROFILE
// ─────────────────────────────────────────────────────────────────────────────

/// AmbienceProfile — Representasi lengkap kondisi visual Luma saat ini.
///
/// Dihitung oleh `AdaptiveAmbienceEngine` sekali per hari dan di-persist
/// ke SharedPreferences. Semua komponen visual (AmbientOrb, InsightCard)
/// membaca dari sini.
class AmbienceProfile {
  /// Varian orb yang aktif
  final OrbVariant orbVariant;

  /// Fase waktu biologis personal
  final BiologicalTimePhase timePhase;

  /// Kondisi ritme mingguan
  final WeeklyRhythmState rhythmState;

  /// True jika ada insight berusia >30 hari yang dibuka — aktifkan NostalgiaEffect
  final bool nostalgiaActive;

  /// Timestamp kalkulasi terakhir — untuk idempotency (1x/hari)
  final DateTime calculatedAt;

  const AmbienceProfile({
    required this.orbVariant,
    required this.timePhase,
    required this.rhythmState,
    required this.nostalgiaActive,
    required this.calculatedAt,
  });

  /// Profile default — dipakai saat data belum cukup atau engine gagal.
  /// Tidak ada transisi, tidak ada efek khusus.
  factory AmbienceProfile.defaults() => AmbienceProfile(
        orbVariant: OrbVariant.dawn,
        timePhase: BiologicalTimePhase.personalMidday,
        rhythmState: WeeklyRhythmState.stable,
        nostalgiaActive: false,
        calculatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

  /// Apakah profile ini masih valid untuk hari ini?
  bool get isValidForToday {
    final now = DateTime.now();
    return calculatedAt.year == now.year &&
        calculatedAt.month == now.month &&
        calculatedAt.day == now.day;
  }

  // ── Serialization ──────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'orbVariant': orbVariant.name,
        'timePhase': timePhase.name,
        'rhythmState': rhythmState.name,
        'nostalgiaActive': nostalgiaActive,
        'calculatedAt': calculatedAt.millisecondsSinceEpoch,
      };

  factory AmbienceProfile.fromJson(Map<String, dynamic> json) {
    return AmbienceProfile(
      orbVariant: OrbVariant.values.firstWhere(
        (e) => e.name == json['orbVariant'],
        orElse: () => OrbVariant.dawn,
      ),
      timePhase: BiologicalTimePhase.values.firstWhere(
        (e) => e.name == json['timePhase'],
        orElse: () => BiologicalTimePhase.personalMidday,
      ),
      rhythmState: WeeklyRhythmState.values.firstWhere(
        (e) => e.name == json['rhythmState'],
        orElse: () => WeeklyRhythmState.stable,
      ),
      nostalgiaActive: json['nostalgiaActive'] as bool? ?? false,
      calculatedAt: DateTime.fromMillisecondsSinceEpoch(
        json['calculatedAt'] as int? ?? 0,
      ),
    );
  }

  /// Serialize ke string untuk SharedPreferences
  String toPrefsString() => jsonEncode(toJson());

  /// Deserialize dari string SharedPreferences
  static AmbienceProfile? fromPrefsString(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return AmbienceProfile.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  AmbienceProfile copyWith({
    OrbVariant? orbVariant,
    BiologicalTimePhase? timePhase,
    WeeklyRhythmState? rhythmState,
    bool? nostalgiaActive,
    DateTime? calculatedAt,
  }) {
    return AmbienceProfile(
      orbVariant: orbVariant ?? this.orbVariant,
      timePhase: timePhase ?? this.timePhase,
      rhythmState: rhythmState ?? this.rhythmState,
      nostalgiaActive: nostalgiaActive ?? this.nostalgiaActive,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }

  @override
  String toString() =>
      'AmbienceProfile(variant=${orbVariant.name}, phase=${timePhase.name}, '
      'rhythm=${rhythmState.name}, nostalgia=$nostalgiaActive)';
}

// ─────────────────────────────────────────────────────────────────────────────
//  HELPER — OrbVariant ↔ ActivityTimeZone mapping
// ─────────────────────────────────────────────────────────────────────────────

/// Map ActivityTimeZone ke BiologicalTimePhase
BiologicalTimePhase timeZoneToPhase(ActivityTimeZone zone) {
  return switch (zone) {
    ActivityTimeZone.earlyMorning || ActivityTimeZone.morning => BiologicalTimePhase.personalMorning,
    ActivityTimeZone.midday || ActivityTimeZone.afternoon => BiologicalTimePhase.personalMidday,
    ActivityTimeZone.evening => BiologicalTimePhase.personalEvening,
    ActivityTimeZone.lateNight => BiologicalTimePhase.personalNight,
    ActivityTimeZone.distributed => BiologicalTimePhase.personalMidday,
  };
}
