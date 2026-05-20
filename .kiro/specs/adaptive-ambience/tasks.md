# Implementation Plan: Adaptive Ambience

## Overview

Implementasi Adaptive Ambience dalam 4 fase berurutan. Setiap fase bisa di-deploy sendiri dan tidak merusak fungsionalitas yang sudah ada. Filosofi: additive, not disruptive.

## Tasks

- [ ] 1. Buat `AmbienceProfile` data class dengan enum `OrbVariant`, `BiologicalTimePhase`, `WeeklyRhythmState`, factory `defaults()`, dan `toJson()`/`fromJson()` untuk SharedPreferences persistence
- [ ] 2. Buat `BiologicalTimeCalculator.compute(List<ActivityTimeZone> history, SharedPreferences prefs)` — hitung fase dari distribusi peakTimeZone 14 hari, threshold ≥10/14 hari untuk berubah, persist history ke `luma_ambience_bio_history`
- [ ] 3. Buat `WeeklyRhythmCalculator.compute(List<DailySummary> last7Days, SharedPreferences prefs)` — hitung state dari focusScore (>60=focused, <35=scattered), guard jika <5 hari data
- [ ] 4. Buat `OrbVariantResolver.resolve(OrbState base, BehaviorSnapshot snapshot, SharedPreferences prefs)` — resolve dusk/recover/stellar dengan hierarki prioritas stellar>recover>dusk>base, persist history lateNight 7 hari
- [ ] 5. Buat `AdaptiveAmbienceEngine.evaluate(BehaviorSnapshot, List<DailySummary>, SharedPreferences)` — koordinasikan semua calculator, idempotency 1x/hari, guard <7 hari data, fallback ke defaults() jika gagal
- [ ] 6. Extend `AmbientOrb` dengan palette baru untuk dusk (oranye redup), recover (hijau sage), stellar (krem-gold denyut pelan), wave tetap ungu-teal
- [ ] 7. Tambah parameter `AmbienceProfile? profile` dan `bool nostalgiaActive` ke `AmbientOrb` — terapkan modifikasi BiologicalTimePhase dan WeeklyRhythmState, transisi 3000ms, aura gold saat nostalgia
- [ ] 8. Tambah `FadeGranularity.isItalic(int daysOld)` — true hanya jika daysOld > 28, tanpa mengubah interface yang ada
- [ ] 9. Update `InsightCard` — terapkan italic dari `FadeGranularity.isItalic()`, tambah parameter `nostalgiaActive` dengan boxShadow gold opacity 0.08
- [ ] 10. Update `HomeState` dan `HomeNotifier` — tambah `AmbienceProfile? ambienceProfile`, panggil `AdaptiveAmbienceEngine.evaluate()` di `loadData()`, deteksi `nostalgiaActive` dari history >30 hari
- [ ] 11. Update `HomePage` dan `RhythmPage` — pass `ambienceProfile` dan `nostalgiaActive` ke `AmbientOrb` dan `InsightCard`
- [ ] 12. Update subtitle slide 1 onboarding — tambah kalimat tentang jam biologis personal

## Task Dependency Graph

```
1 (AmbienceProfile)
├── 2 (BiologicalTimeCalculator)
├── 3 (WeeklyRhythmCalculator)
├── 4 (OrbVariantResolver)
└── 5 (AdaptiveAmbienceEngine) ← depends on 1,2,3,4
    └── 10 (HomeNotifier) ← depends on 5
        └── 11 (HomePage) ← depends on 10

6 (Palette baru) ← independent
└── 7 (AmbientOrb integration) ← depends on 1,6
    └── 11 (HomePage) ← depends on 7

8 (FadeGranularity) ← independent
└── 9 (InsightCard) ← depends on 8
    └── 11 (HomePage) ← depends on 9

12 (Onboarding) ← independent
```

## Notes

- Tasks 1–5: Phase 1 domain layer, tidak ada perubahan UI
- Tasks 6–7: Phase 2 AmbientOrb visual
- Tasks 8–9: Phase 3 InsightCard memory fading
- Tasks 10–12: Phase 4 wiring ke pipeline yang ada
- Urutan eksekusi: 1→2,3,4 (paralel)→5→6→8→7→9→10→11→12
- `DailySummary.focusScore` sudah ada di DB — tidak perlu schema migration
- Wave orb tetap ungu-teal (#6B5A8A) karena paling tepat merepresentasikan "gelisah"
