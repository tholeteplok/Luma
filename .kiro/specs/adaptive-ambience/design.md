# Design Document: Adaptive Ambience

## Overview

Adaptive Ambience adalah lapisan evolusi visual di atas sistem yang sudah ada.
Ia tidak menggantikan `OrbStateEngine`, `FadeGranularity`, atau `InsightCard` —
ia memperluas dan mengkoordinasikan mereka melalui satu titik: `AdaptiveAmbienceEngine`.

Filosofi implementasi: **additive, not disruptive.**
Semua kode lama tetap berjalan. Fitur baru opt-in via `AmbienceProfile`.

---

## Architecture

```
BehaviorSnapshot (existing)
        │
        ▼
AdaptiveAmbienceEngine.evaluate()          ← NEW
        │
        ├─ OrbStateEngine.evaluate()       ← existing (input, not replaced)
        │
        ├─ BiologicalTimePhase.compute()   ← NEW (dari peakTimeZone 14 hari)
        │
        ├─ WeeklyRhythmState.compute()     ← NEW (dari switchFrequency 7 hari)
        │
        └─ OrbVariant.resolve()            ← NEW (dusk/recover/stellar override)
                │
                ▼
        AmbienceProfile                    ← NEW (data class, persisted)
                │
        ┌───────┴────────┐
        ▼                ▼
   AmbientOrb        InsightCard
  (OrbVariant +    (FadeGranularity +
   BiologicalTime)   isItalic + Nostalgia)
```

---

## Data Classes

### AmbienceProfile
```dart
class AmbienceProfile {
  final OrbVariant orbVariant;
  final BiologicalTimePhase timePhase;
  final WeeklyRhythmState rhythmState;
  final bool nostalgiaActive;       // insight >30 hari dibuka
  final DateTime calculatedAt;      // untuk idempotency (1x/hari)
}
```

### OrbVariant (extends OrbState)
```dart
enum OrbVariant {
  // Dari OrbState yang sudah ada:
  dawn, calm, wave, mist,
  // Baru:
  dusk,     // aktivitas malam tinggi ≥5/7 hari
  recover,  // setelah mist, recovery ≥3 hari
  stellar,  // anomali positif: focused + belowBaseline ≥3 hari setelah scattered
}
```

### BiologicalTimePhase
```dart
enum BiologicalTimePhase {
  personalMorning,  // puncak di earlyMorning/morning
  personalMidday,   // puncak di midday/afternoon (default)
  personalEvening,  // puncak di evening
  personalNight,    // puncak di lateNight
}
```

### WeeklyRhythmState
```dart
enum WeeklyRhythmState {
  clear,       // focused ≥60% dari 7 hari
  dim,         // scattered ≥60% dari 7 hari
  stable,      // variasi rendah
  undulating,  // bergantian focused-scattered
}
```

**Sumber data: `DailySummary.focusScore` (0–100) dari DB — sudah ada, tidak perlu schema migration.**

Mapping per hari: `focusScore > 60` → "focused", `focusScore < 35` → "scattered", sisanya "moderate".
`WeeklyRhythmCalculator` menerima `List<DailySummary>` dari `DatabaseService.getDailySummariesBetween()`
yang sudah dipanggil di `HomeNotifier.loadData()` — tidak ada query tambahan.

Ini lebih akurat dari consecutive days (hanya melihat streak) karena melihat distribusi penuh 7 hari.

---

## Palette Keputusan

### Orb per OrbVariant
| Variant | Core | Mid | Outer | Karakter |
|---------|------|-----|-------|----------|
| dawn | #1A5A4A | #0F3A2E | #081B1B | Teal gelap, belum terbentuk |
| calm | #5A8F76 | #203B37 | #0F2626 | Hijau sage, stabil |
| wave | #6B5A8A | #3A2A5A | #1A0F2E | Ungu-teal, gelisah |
| mist | #1E2E2A | #141E1C | #0A1412 | Abu kehijauan, hampir diam |
| dusk | #5A3010 | #3A1E08 | #1A0A04 | Oranye redup, malam |
| recover | #2A5A3A | #1A3A26 | #0C2018 | Hijau sage muda, mengembang |
| stellar | #EEE8B2 | #C18D52 | #3A2A10 | Krem-gold, denyut pelan |

**Catatan wave:** Ungu dipertahankan untuk wave karena secara visual paling
tepat merepresentasikan "gelisah" — berbeda dari emerald yang tenang.
Ini konsisten dengan filosofi: warna mencerminkan kondisi, bukan brand.

### BiologicalTimePhase → modifikasi palette
| Phase | Modifikasi |
|-------|-----------|
| personalMorning | breathDuration +20%, waveIntensity -10% |
| personalMidday | default (tidak ada modifikasi) |
| personalEvening | core shift +10% ke arah #C18D52 (gold), centerOffset y+8% |
| personalNight | breathDuration +30%, waveIntensity -20% |

### WeeklyRhythmState → modifikasi wavePoints & waveIntensity
| State | wavePoints | waveIntensity |
|-------|-----------|---------------|
| clear | ≤8 | ≤0.035 |
| dim | ≥10 | ≥0.060 |
| stable | default | default |
| undulating | default | lerp 0.030–0.075 per sesi |

---

## Storage Strategy

Semua state disimpan di `SharedPreferences` dengan prefix `luma_ambience_`
untuk menghindari konflik dengan `luma_orb_` yang sudah ada.

```
luma_ambience_profile_json    → AmbienceProfile serialized
luma_ambience_last_eval_date  → ISO8601 (idempotency)
luma_ambience_bio_phase       → BiologicalTimePhase.name
luma_ambience_rhythm_state    → WeeklyRhythmState.name
luma_ambience_variant         → OrbVariant.name
luma_ambience_bio_history     → JSON array peakTimeZone 14 hari
luma_ambience_rhythm_history  → JSON array switchFrequency 7 hari
```

---

## Integration Points

### AmbientOrb
- Tambah parameter opsional `AmbienceProfile? profile`
- Jika `profile != null` → gunakan `profile.orbVariant` + modifikasi dari `timePhase` dan `rhythmState`
- Jika `profile == null` → fallback ke `OrbState` seperti sebelumnya (backward compat)

### InsightCard
- `FadeGranularity` ditambah `isItalic` getter
- Jika `isItalic == true` → `fontStyle: FontStyle.italic` pada title dan message
- `NostalgiaEffect` → glow `#C18D52` opacity ≤0.15 di sekitar card, breathDuration +25%

### HomeNotifier
- Panggil `AdaptiveAmbienceEngine.evaluate()` setelah `OrbStateEngine.evaluate()`
- Expose `AmbienceProfile` di `HomeState`
- Pass ke `AmbientOrb` dan `InsightCard`

---

## Anti-Overreactivity Guards

Semua guard diimplementasikan di `AdaptiveAmbienceEngine`, bukan di UI:

1. **1x per hari** — cek `luma_ambience_last_eval_date`
2. **Min 7 hari data** — jika kurang, return `AmbienceProfile.defaults()`
3. **Min 10/14 hari** untuk `BiologicalTimePhase` berubah
4. **Min 5/7 hari** untuk `WeeklyRhythmState` berubah
5. **Anomali 1 hari diabaikan** — semua keputusan berbasis tren, bukan snapshot tunggal
6. **Fallback chain**: `AdaptiveAmbienceEngine` gagal → `OrbStateEngine` → `OrbState.dawn`

---

## Performance

- `AdaptiveAmbienceEngine.evaluate()` berjalan di `compute()` jika >16ms
- Semua kalkulasi berat (agregasi 14 hari) dilakukan sekali per hari, hasilnya di-cache
- `AmbientOrb` tidak melakukan kalkulasi di `paint()` — semua parameter sudah dihitung sebelum render
- `RepaintBoundary` sudah ada di `AmbientOrb`
