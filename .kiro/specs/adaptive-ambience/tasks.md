# Implementation Tasks: Adaptive Ambience

## Task Overview

Implementasi dibagi 4 fase berurutan. Setiap fase bisa di-deploy sendiri
dan tidak merusak fungsionalitas yang sudah ada.

**Estimasi total: ~3–4 sesi kerja**

---

## Phase 1: Domain Layer (Foundation)
*Tidak ada perubahan UI. Semua logika, semua tes.*

### Task 1.1 — Enum & Data Classes
**File baru:** `lib/domain/entities/ambience_profile.dart`

- [ ] Definisikan `OrbVariant` enum (dawn, calm, wave, mist, dusk, recover, stellar)
- [ ] Definisikan `BiologicalTimePhase` enum (personalMorning, personalMidday, personalEvening, personalNight)
- [ ] Definisikan `WeeklyRhythmState` enum (clear, dim, stable, undulating)
- [ ] Buat `AmbienceProfile` data class dengan semua field + `defaults()` factory
- [ ] Tambah `toJson()` / `fromJson()` untuk persistence ke SharedPreferences

**Acceptance:** `flutter analyze` bersih, tidak ada breaking change.

---

### Task 1.2 — BiologicalTimePhase Calculator
**File baru:** `lib/domain/services/biological_time_calculator.dart`

- [ ] Buat `BiologicalTimeCalculator.compute(List<ActivityTimeZone> history)` → `BiologicalTimePhase`
- [ ] Logic: ambil distribusi `peakTimeZone` dari 14 hari terakhir
- [ ] Threshold: butuh ≥10 dari 14 hari mendukung fase baru untuk berubah
- [ ] Default: `personalMidday` jika data kurang atau `distributed`
- [ ] Persist history ke `luma_ambience_bio_history` (JSON array, max 14 entries)

**Acceptance:** Unit test — 14 hari `earlyMorning` → `personalMorning`, 13 hari `lateNight` → tetap phase lama.

---

### Task 1.3 — WeeklyRhythmState Calculator
**File baru:** `lib/domain/services/weekly_rhythm_calculator.dart`

**Sumber data:** `DailySummary.focusScore` dari DB — tidak perlu schema migration.
`focusScore > 60` → focused, `focusScore < 35` → scattered, sisanya moderate.

- [ ] Buat `WeeklyRhythmCalculator.compute(List<DailySummary> last7Days)` → `WeeklyRhythmState`
- [ ] `clear`: hari dengan `focusScore > 60` ≥ 4 dari 7 hari (≥60%)
- [ ] `dim`: hari dengan `focusScore < 35` ≥ 4 dari 7 hari (≥60%)
- [ ] `stable`: variasi rendah — max 1 perubahan kategori (focused↔scattered) dalam 7 hari
- [ ] `undulating`: bergantian focused-scattered ≥3 kali dalam 7 hari
- [ ] Guard: jika `last7Days.length < 5`, return state sebelumnya dari SharedPrefs
- [ ] `last7Days` diambil dari `HomeNotifier.loadData()` yang sudah query DB — tidak ada query tambahan

**Acceptance:** 5 hari `focusScore=75` + 2 hari `focusScore=20` → `clear` (5/7 ≥ 60%).

---

### Task 1.4 — OrbVariant Resolver
**File baru:** `lib/domain/services/orb_variant_resolver.dart`

- [ ] Buat `OrbVariantResolver.resolve(OrbState base, BehaviorSnapshot snapshot, SharedPreferences prefs)` → `OrbVariant`
- [ ] `dusk`: `hasLateNightActivity == true` pada ≥5 dari 7 hari terakhir
- [ ] `recover`: state sebelumnya `mist` + recovery ≥3 hari berturut-turut
- [ ] `stellar`: `focused + belowBaseline` ≥3 hari berturut-turut setelah periode `scattered`
- [ ] Hierarki prioritas: `stellar > recover > dusk > base OrbState`
- [ ] Persist history `hasLateNightActivity` 7 hari terakhir

**Acceptance:** `stellar` tidak muncul tanpa periode `scattered` sebelumnya.

---

### Task 1.5 — AdaptiveAmbienceEngine
**File baru:** `lib/domain/services/adaptive_ambience_engine.dart`

- [ ] Buat `AdaptiveAmbienceEngine` class dengan `evaluate(BehaviorSnapshot snapshot, List<DailySummary> last7Days, SharedPreferences prefs)` → `AmbienceProfile`
- [ ] `last7Days` diteruskan dari `HomeNotifier` yang sudah punya data ini — tidak ada query DB tambahan
- [ ] Idempotency: cek `luma_ambience_last_eval_date`, skip jika sudah hari ini
- [ ] Guard: jika `snapshot.baselineDaysAvailable < 7`, return `AmbienceProfile.defaults()`
- [ ] Koordinasikan: `OrbStateEngine` + `BiologicalTimeCalculator` + `WeeklyRhythmCalculator(last7Days)` + `OrbVariantResolver`
- [ ] Persist `AmbienceProfile` ke `luma_ambience_profile_json`
- [ ] Log transisi jika `OrbVariant` berubah
- [ ] Fallback: jika engine gagal (exception), return `AmbienceProfile.defaults()` tanpa crash

**Acceptance:** Dipanggil 10x dalam satu hari → hanya evaluasi 1x, return cached result.

---

## Phase 2: Visual Layer — AmbientOrb
*Extend AmbientOrb untuk menerima AmbienceProfile.*

### Task 2.1 — Palette Baru (dusk, recover, stellar)
**File dimodifikasi:** `lib/presentation/widgets/ambient_orb.dart`

- [ ] Tambah palette untuk `OrbVariant.dusk` (oranye redup: core `#5A3010`, mid `#3A1E08`)
- [ ] Tambah palette untuk `OrbVariant.recover` (hijau sage: core `#2A5A3A`, mid `#1A3A26`)
- [ ] Tambah palette untuk `OrbVariant.stellar` (krem-gold: core `#EEE8B2`, mid `#C18D52`, waveIntensity ≤0.015, breathDuration ≥10000ms)
- [ ] Wave tetap ungu-teal: core `#6B5A8A`, mid `#3A2A5A` (ungu valid untuk varian orb)

**Acceptance:** Semua 7 varian render tanpa error, `flutter analyze` bersih.

---

### Task 2.2 — AmbienceProfile Integration
**File dimodifikasi:** `lib/presentation/widgets/ambient_orb.dart`

- [ ] Tambah parameter opsional `AmbienceProfile? profile` ke `AmbientOrb`
- [ ] Jika `profile != null`: gunakan `profile.orbVariant` sebagai key palette
- [ ] Jika `profile == null`: fallback ke `OrbState` (backward compat terjaga)
- [ ] Terapkan modifikasi `BiologicalTimePhase`:
  - `personalEvening`: `centerOffset` y +8% dari orbSize
  - `personalMorning`: `breathDuration` ×1.2
  - `personalNight`: `breathDuration` ×1.3, `waveIntensity` ×0.8
- [ ] Terapkan modifikasi `WeeklyRhythmState`:
  - `clear`: `wavePoints` min(current, 8), `waveIntensity` min(current, 0.035)
  - `dim`: `wavePoints` max(current, 10), `waveIntensity` max(current, 0.060)
- [ ] Transisi antar variant: `AnimatedSwitcher` durasi 3000ms (bukan 1600ms)

**Acceptance:** Ganti `OrbState.calm` → `OrbVariant.recover` → orb berubah perlahan dalam 3 detik.

---

### Task 2.3 — NostalgiaEffect
**File dimodifikasi:** `lib/presentation/widgets/ambient_orb.dart`

- [ ] Tambah parameter `bool nostalgiaActive = false` ke `AmbientOrb`
- [ ] Jika `nostalgiaActive`: tambah layer aura gold `#C18D52` opacity ≤0.15 di `_paintAura()`
- [ ] Jika `nostalgiaActive`: `breathDuration` ×1.25 dari nilai normal

**Acceptance:** `nostalgiaActive: true` → aura gold tipis terlihat, napas lebih lambat.

---

## Phase 3: Visual Layer — InsightCard & FadeGranularity
*Memory fading yang lebih kaya.*

### Task 3.1 — FadeGranularity isItalic
**File dimodifikasi:** `lib/core/utils/fade_granularity.dart`

- [ ] Tambah getter `static bool isItalic(int daysOld)` → `true` hanya jika `daysOld > 28`
- [ ] Tidak mengubah interface yang sudah ada (`getState`, `getOpacity`, `getBlurSigma`, `getTimeLabel`, `getHintText`)

**Acceptance:** `FadeGranularity.isItalic(27)` → `false`, `FadeGranularity.isItalic(29)` → `true`.

---

### Task 3.2 — InsightCard italic & nostalgia
**File dimodifikasi:** `lib/presentation/widgets/insight_card.dart`

- [ ] Baca `FadeGranularity.isItalic(daysOld)` di `build()`
- [ ] Jika `isItalic`: terapkan `fontStyle: FontStyle.italic` pada title dan message
- [ ] Tambah parameter opsional `bool nostalgiaActive = false`
- [ ] Jika `nostalgiaActive`: tambah `BoxDecoration` dengan `boxShadow` gold `#C18D52` opacity 0.08, blur 12px

**Acceptance:** Insight 29 hari → teks italic. Insight 31 hari + `nostalgiaActive` → glow gold tipis.

---

## Phase 4: Integration — HomeNotifier & HomePage
*Sambungkan semua ke pipeline yang sudah ada.*

### Task 4.1 — HomeState & HomeNotifier
**File dimodifikasi:** `lib/presentation/bloc/home_bloc.dart`

- [ ] Tambah `AmbienceProfile? ambienceProfile` ke `HomeState`
- [ ] Di `loadData()`: panggil `AdaptiveAmbienceEngine.evaluate(snapshot, prefs)` setelah `OrbStateEngine.evaluate()`
- [ ] Simpan result ke `_state.ambienceProfile`
- [ ] Expose getter `ambienceProfile` di `HomeNotifier`
- [ ] Deteksi `nostalgiaActive`: cek apakah ada insight dalam `history` yang berusia >30 hari

**Acceptance:** `homeNotifier.ambienceProfile` tidak null setelah `loadData()`.

---

### Task 4.2 — HomePage & RhythmPage
**File dimodifikasi:** `lib/presentation/pages/home_page.dart`, `rhythm_page.dart`

- [ ] Pass `ambienceProfile` ke `AmbientOrb` di `_buildOrbSection()`
- [ ] Pass `nostalgiaActive` ke `AmbientOrb` berdasarkan deteksi dari `HomeNotifier`
- [ ] Pass `nostalgiaActive` ke `InsightCard` untuk insight berusia >30 hari

**Acceptance:** Build sukses, tidak ada regression di UI yang sudah ada.

---

### Task 4.3 — Onboarding Update
**File dimodifikasi:** `lib/presentation/pages/onboarding_page.dart`

- [ ] Tambah slide atau kalimat di slide 1: *"Luma belajar kapan pagimu dimulai. Tema mengikuti jam biologismu, bukan jam dinding."*
- [ ] Tidak perlu slide baru — cukup update subtitle slide 1

**Acceptance:** Kalimat muncul di slide pertama onboarding.

---

## Urutan Eksekusi yang Direkomendasikan

```
Phase 1 (domain) → Phase 2.1 (palette) → Phase 3.1 (isItalic) →
Phase 2.2 (integration) → Phase 3.2 (card) → Phase 4 (wiring)
```

Alasan: Phase 1 dan 2.1 bisa dikerjakan paralel karena tidak saling bergantung.
Phase 4 harus terakhir karena bergantung pada semua phase sebelumnya.

---

## File Summary

| File | Status | Aksi |
|------|--------|------|
| `lib/domain/entities/ambience_profile.dart` | Baru | Buat |
| `lib/domain/services/biological_time_calculator.dart` | Baru | Buat |
| `lib/domain/services/weekly_rhythm_calculator.dart` | Baru | Buat |
| `lib/domain/services/orb_variant_resolver.dart` | Baru | Buat |
| `lib/domain/services/adaptive_ambience_engine.dart` | Baru | Buat |
| `lib/presentation/widgets/ambient_orb.dart` | Ada | Extend |
| `lib/core/utils/fade_granularity.dart` | Ada | Extend |
| `lib/presentation/widgets/insight_card.dart` | Ada | Extend |
| `lib/presentation/bloc/home_bloc.dart` | Ada | Extend |
| `lib/presentation/pages/home_page.dart` | Ada | Extend |
| `lib/presentation/pages/rhythm_page.dart` | Ada | Extend |
| `lib/presentation/pages/onboarding_page.dart` | Ada | Update teks |

**Total file baru: 5 | File dimodifikasi: 7**
