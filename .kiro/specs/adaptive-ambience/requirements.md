# Requirements Document

## Introduction

Adaptive Ambience adalah sistem evolusi visual Luma yang membuat tampilan aplikasi berubah secara organik mengikuti ritme digital pengguna — bukan karena pilihan pengguna, melainkan karena pola perilaku pengguna itu sendiri yang berubah.

Fitur ini terdiri dari tiga lapisan evolusi yang saling terhubung:

1. **Waktu Biologis Personal** — Orb bergeser warna, glow, dan gerakannya sesuai zona waktu aktif personal pengguna (bukan jam literal), mencerminkan apakah pengguna adalah "orang pagi" atau "orang malam".
2. **Ritme Mingguan** — Stabilitas fokus dan pola switching selama 7–14 hari menentukan kejernihan vs keremangan, ketenangan vs gelombang visual.
3. **Memory Fading** — Usia data insight memengaruhi kontras, opacity, blur, dan tipografi secara progresif, meniru sifat alami ingatan manusia.

Filosofi inti: *"User should FEEL the shift before noticing the shift."* Perubahan harus terasa sebelum disadari — lambat, halus, tidak pernah mengejutkan.

---

## Glossary

- **AdaptiveAmbienceEngine**: Komponen domain baru yang menghitung `AmbienceProfile` dari data perilaku multi-hari.
- **AmbienceProfile**: Representasi lengkap kondisi visual Luma saat ini — mencakup `OrbVariant`, `BiologicalTimePhase`, `WeeklyRhythmState`, dan parameter visual turunannya.
- **OrbVariant**: Perluasan dari `OrbState` yang mencakup varian baru: `dusk` (senja), `recover` (pulih), `stellar` (bintang). Varian `mist` (kabut) sudah ada.
- **BiologicalTimePhase**: Fase waktu biologis personal pengguna — `personalMorning`, `personalMidday`, `personalEvening`, `personalNight` — dihitung dari pola aktivitas historis, bukan jam sistem.
- **WeeklyRhythmState**: Kondisi ritme mingguan — `clear` (jernih), `dim` (redup), `stable` (stabil), `undulating` (bergelombang) — dihitung dari tren 7–14 hari.
- **NostalgiaEffect**: Efek visual khusus untuk insight berusia >30 hari — glow hangat keemasan tipis dan animasi yang melambat.
- **BehaviorSnapshot**: Entitas yang sudah ada, merepresentasikan perilaku digital satu hari.
- **InsightMemory**: Sistem penyimpanan insight berbasis SharedPreferences yang sudah ada.
- **FadeGranularity**: Sistem peluruhan visual berdasarkan usia data yang sudah ada (`sharp`, `dim`, `blurry`, `silhouette`).
- **OrbStateEngine**: Engine yang sudah ada untuk menghitung `OrbState` (dawn/calm/wave/mist).
- **AmbientOrb**: Widget Flutter yang sudah ada dengan CustomPainter bezier organik.
- **LumaPalette**: ThemeExtension yang sudah ada untuk warna dark/light mode.
- **Tren 7–14 Hari**: Agregasi `BehaviorSnapshot` selama 7 hingga 14 hari terakhir yang digunakan sebagai basis keputusan transisi visual.
- **Anti-Overreactivity**: Aturan yang mencegah perubahan visual berdasarkan anomali satu hari — semua perubahan harus berbasis tren.

---

## Requirements

### Requirement 1: Profil Ambience Terpadu

**User Story:** Sebagai pengguna Luma, saya ingin tampilan aplikasi berubah secara organik mengikuti ritme digital saya, sehingga saya merasakan cerminan diri yang hidup tanpa harus mengonfigurasi apapun.

#### Acceptance Criteria

1. WHEN data `BehaviorSnapshot` minimal 7 hari tersedia di `InsightMemory`, THE `AdaptiveAmbienceEngine` SHALL menghitung `AmbienceProfile` dari agregasi `BehaviorSnapshot` 7–14 hari terakhir tersebut.
2. WHEN `AdaptiveAmbienceEngine` menghitung `AmbienceProfile`, THE `AdaptiveAmbienceEngine` SHALL menghasilkan nilai untuk `OrbVariant`, `BiologicalTimePhase`, `WeeklyRhythmState`, dan semua parameter visual turunannya secara bersamaan.
3. THE `AmbienceProfile` SHALL menyertakan timestamp kalkulasi terakhir agar evaluasi ulang tidak terjadi lebih dari sekali per hari.
4. IF data `BehaviorSnapshot` kurang dari 7 hari tersedia, THEN THE `AdaptiveAmbienceEngine` SHALL menunggu hingga data yang cukup terkumpul dan mempertahankan `AmbienceProfile` default tanpa melakukan transisi apapun.
5. THE `AdaptiveAmbienceEngine` SHALL mempersistensikan `AmbienceProfile` terakhir ke `SharedPreferences` agar tidak hilang saat aplikasi ditutup.
6. WHEN `AmbienceProfile` berubah, THE `AdaptiveAmbienceEngine` SHALL mencatat log transisi dengan menyertakan nilai lama, nilai baru, dan alasan perubahan.

---

### Requirement 2: Waktu Biologis Personal

**User Story:** Sebagai pengguna Luma, saya ingin Orb mencerminkan ritme waktu aktif saya secara personal, sehingga pengguna yang aktif di malam hari mendapatkan ambience yang berbeda dari pengguna yang aktif di pagi hari.

#### Acceptance Criteria

1. THE `AdaptiveAmbienceEngine` SHALL menghitung `BiologicalTimePhase` dari distribusi `peakTimeZone` pada `BehaviorSnapshot` 14 hari terakhir, bukan dari jam sistem saat ini, dan nilai `BiologicalTimePhase` harus sesuai dengan distribusi zona waktu puncak tersebut.
2. WHEN `BiologicalTimePhase` adalah `personalMorning` (puncak aktivitas di `earlyMorning` atau `morning`), THE `AmbientOrb` SHALL menampilkan palet warna teal-biru dengan `breathDuration` antara 5000–6500 ms.
3. WHEN `BiologicalTimePhase` adalah `personalEvening` (puncak aktivitas di `evening`), THE `AmbientOrb` SHALL menampilkan palet warna oranye redup dengan pusat lingkaran bergeser ke bawah sebesar 8–12% dari ukuran Orb.
4. WHEN `BiologicalTimePhase` adalah `personalNight` (puncak aktivitas di `lateNight`), THE `AmbientOrb` SHALL menampilkan palet warna biru-ungu gelap dengan `waveIntensity` lebih rendah dari fase siang.
5. WHEN `BiologicalTimePhase` adalah `personalMidday` (puncak aktivitas di `midday` atau `afternoon`), THE `AmbientOrb` SHALL menampilkan palet warna hijau-teal netral dengan `breathDuration` antara 4500–5500 ms.
6. IF distribusi `peakTimeZone` tersebar merata (`distributed`) selama 14 hari terakhir, THEN THE `AdaptiveAmbienceEngine` SHALL menetapkan `BiologicalTimePhase` sebagai `personalMidday` sebagai nilai default.
7. THE `AdaptiveAmbienceEngine` SHALL membutuhkan minimal 10 dari 14 hari data yang mendukung fase baru untuk mengubah `BiologicalTimePhase` dari nilai sebelumnya, tanpa pengecualian manual.

---

### Requirement 3: Ritme Mingguan

**User Story:** Sebagai pengguna Luma, saya ingin kejernihan dan ketenangan visual Orb mencerminkan stabilitas fokus saya selama seminggu terakhir, sehingga minggu yang penuh distraksi terasa berbeda dari minggu yang tenang.

#### Acceptance Criteria

1. THE `AdaptiveAmbienceEngine` SHALL menghitung `WeeklyRhythmState` dari proporsi hari `SwitchFrequency.focused` vs `SwitchFrequency.scattered` dalam 7 hari terakhir.
2. WHEN proporsi hari `focused` ≥ 60% dalam 7 hari terakhir, THE `AdaptiveAmbienceEngine` SHALL menetapkan `WeeklyRhythmState` sebagai `clear`.
3. WHEN proporsi hari `scattered` ≥ 60% dalam 7 hari terakhir, THE `AdaptiveAmbienceEngine` SHALL menetapkan `WeeklyRhythmState` sebagai `dim`.
4. WHEN `WeeklyRhythmState` adalah `clear`, THE `AmbientOrb` SHALL menampilkan `waveIntensity` ≤ 0.035 dan `wavePoints` ≤ 8.
5. WHEN `WeeklyRhythmState` adalah `dim`, THE `AmbientOrb` SHALL menampilkan `waveIntensity` ≥ 0.060 dan `wavePoints` ≥ 10.
6. WHEN `WeeklyRhythmState` adalah `stable` (variasi `switchFrequency` rendah selama 7 hari), THE `AmbientOrb` SHALL mempertahankan `breathDuration` yang konsisten tanpa fluktuasi.
7. WHEN `WeeklyRhythmState` adalah `undulating` (variasi `switchFrequency` tinggi, bergantian focused-scattered), THE `AmbientOrb` SHALL menampilkan `breathDuration` yang bervariasi antara 3800–7000 ms secara gradual.
8. IF data 7 hari tidak lengkap (kurang dari 5 hari tersedia), THEN THE `AdaptiveAmbienceEngine` SHALL mempertahankan `WeeklyRhythmState` sebelumnya secara ketat tanpa perubahan apapun, termasuk mengabaikan semua pemicu transisi lainnya.

---

### Requirement 4: Varian Orb Baru

**User Story:** Sebagai pengguna Luma, saya ingin Orb memiliki varian visual yang lebih kaya untuk mencerminkan kondisi spesifik seperti aktivitas malam tinggi, pemulihan dari kelelahan, dan momen positif yang langka.

#### Acceptance Criteria

1. THE `OrbVariant` SHALL mencakup varian `dusk` (senja) untuk kondisi aktivitas malam tinggi yang konsisten.
2. WHEN `hasLateNightActivity` bernilai `true` pada ≥ 5 dari 7 hari terakhir, THE `AdaptiveAmbienceEngine` SHALL menetapkan `OrbVariant` sebagai `dusk`, menggantikan `OrbVariant` default dari `OrbStateEngine`.
3. WHEN `OrbVariant` adalah `dusk`, THE `AmbientOrb` SHALL menampilkan palet oranye redup (`core` ≈ `#5A3010`, `mid` ≈ `#3A1E08`) dengan pusat lingkaran bergeser ke bawah 8–12% dan `breathDuration` antara 7000–9000 ms.
4. THE `OrbVariant` SHALL mencakup varian `recover` (pulih) untuk kondisi pemulihan setelah periode `mist`.
5. WHEN `OrbState` sebelumnya adalah `mist` dan kondisi pemulihan terpenuhi selama ≥ 3 hari berturut-turut, THE `AdaptiveAmbienceEngine` SHALL menetapkan `OrbVariant` sebagai `recover` sebelum bertransisi ke `calm`.
6. WHEN `OrbVariant` adalah `recover`, THE `AmbientOrb` SHALL menampilkan palet hijau sage (`core` ≈ `#2A5A3A`, `mid` ≈ `#1A3A26`) dengan animasi mengembang pelan (`waveIntensity` ≤ 0.025) dan `breathDuration` antara 7000–8500 ms.
7. THE `OrbVariant` SHALL mencakup varian `stellar` (bintang) untuk anomali positif yang langka.
8. WHEN `BehaviorSnapshot` menunjukkan `switchFrequency` `focused` dan `screenTimeLevel` `belowBaseline` secara bersamaan selama ≥ 3 hari berturut-turut setelah periode `scattered`, THE `AdaptiveAmbienceEngine` SHALL menetapkan `OrbVariant` sebagai `stellar`.
9. WHEN `OrbVariant` adalah `stellar`, THE `AmbientOrb` SHALL menampilkan satu lingkaran terang dengan denyut sangat pelan (`breathDuration` ≥ 10000 ms) dan `waveIntensity` ≤ 0.015.
10. WHEN beberapa kondisi varian aktif secara bersamaan, THE `AdaptiveAmbienceEngine` SHALL menerapkan hierarki prioritas berikut: `stellar` > `recover` > `dusk`, sehingga varian dengan prioritas tertinggi selalu menang.
11. IF tidak ada kondisi varian khusus terpenuhi, THEN THE `AdaptiveAmbienceEngine` SHALL menggunakan `OrbState` dari `OrbStateEngine` yang sudah ada sebagai `OrbVariant` default.

---

### Requirement 5: Transisi Visual yang Lambat dan Halus

**User Story:** Sebagai pengguna Luma, saya ingin perubahan visual terjadi sangat lambat dan halus, sehingga saya merasakan pergeseran sebelum menyadarinya secara sadar.

#### Acceptance Criteria

1. THE `AmbientOrb` SHALL menggunakan durasi transisi minimal 3000 ms saat berpindah antar `OrbVariant`.
2. WHEN `OrbVariant` berubah, THE `AmbientOrb` SHALL menginterpolasi semua parameter warna (`core`, `mid`, `outer`) secara linear selama durasi transisi.
3. WHEN `BiologicalTimePhase` berubah, THE `AmbientOrb` SHALL menginterpolasi pergeseran posisi pusat lingkaran secara gradual selama minimal 2000 ms, kecuali `reduceMotion` bernilai `true` yang menonaktifkan interpolasi ini.
4. THE `AdaptiveAmbienceEngine` SHALL tidak mengizinkan lebih dari satu perubahan `OrbVariant` dalam satu hari kalender, dan setelah batas ini tercapai SHALL menolak semua perubahan berikutnya pada hari yang sama.
5. THE `AdaptiveAmbienceEngine` SHALL tidak mengizinkan perubahan `BiologicalTimePhase` kecuali data 10 dari 14 hari terakhir mendukung fase baru tersebut, tanpa pengecualian apapun.
6. THE `AdaptiveAmbienceEngine` SHALL tidak mengizinkan perubahan `WeeklyRhythmState` berdasarkan data kurang dari 5 hari.
7. IF `AmbientOrb` menerima `reduceMotion` bernilai `true`, THEN THE `AmbientOrb` SHALL menonaktifkan semua animasi transisi termasuk interpolasi posisi dan menampilkan state statis, sementara state internal interpolasi tetap aktif.

---

### Requirement 6: Anti-Overreactivity

**User Story:** Sebagai pengguna Luma, saya ingin ambience tidak bereaksi terhadap anomali satu hari, sehingga satu hari yang tidak biasa tidak mengubah tampilan yang sudah terbentuk selama berminggu-minggu.

#### Acceptance Criteria

1. THE `AdaptiveAmbienceEngine` SHALL hanya mempertimbangkan tren berbasis minimal 7 hari data untuk setiap keputusan transisi visual.
2. IF satu hari `BehaviorSnapshot` menunjukkan kondisi yang berbeda dari tren 7 hari sebelumnya, THEN THE `AdaptiveAmbienceEngine` SHALL mengabaikan anomali tersebut dan mempertahankan `AmbienceProfile` saat ini.
3. THE `AdaptiveAmbienceEngine` SHALL tidak pernah menggunakan warna merah (nilai hue 0°–15° atau 345°–360°) dalam palet `OrbVariant` manapun.
4. THE `AdaptiveAmbienceEngine` SHALL tidak pernah menggunakan warna kuning cerah (nilai hue 45°–65° dengan saturation > 70%) dalam palet `OrbVariant` manapun.
5. THE `AmbientOrb` SHALL tidak pernah menampilkan animasi dengan `breathDuration` kurang dari 3500 ms dalam kondisi apapun.
6. THE `AmbientOrb` SHALL tidak pernah menampilkan animasi berkedip atau perubahan opacity yang tiba-tiba (delta opacity > 0.3 dalam satu frame).
7. WHEN `AdaptiveAmbienceEngine` mendeteksi data yang tidak konsisten atau korup, THE `AdaptiveAmbienceEngine` SHALL mempertahankan `AmbienceProfile` terakhir yang valid tanpa melakukan transisi.

---

### Requirement 7: Memory Fading Visual

**User Story:** Sebagai pengguna Luma, saya ingin tampilan insight lama memudar secara visual seiring waktu, sehingga data yang lebih baru terasa lebih hidup dan data lama terasa seperti kenangan yang memudar.

#### Acceptance Criteria

1. THE `FadeGranularity` SHALL menentukan opacity, blur sigma, dan gaya tipografi untuk setiap insight berdasarkan usia data dalam hari.
2. WHEN usia data insight adalah 0–7 hari, THE sistem SHALL menampilkan insight dengan opacity 100%, blur sigma 0, dan tipografi reguler.
3. WHEN usia data insight adalah 8–14 hari, THE sistem SHALL menampilkan insight dengan opacity 85%, blur sigma 0, dan tipografi reguler.
4. WHEN usia data insight adalah 15–28 hari, THE sistem SHALL menampilkan insight dengan opacity 65%, blur sigma σ=1.5, dan tipografi reguler.
5. WHEN usia data insight adalah lebih dari 28 hari, THE sistem SHALL menampilkan insight dengan opacity 45%, blur sigma σ=2.5, dan tipografi italic.
6. WHEN usia data insight melebihi 30 hari dan usia tersebut konsisten dengan indikator visual lainnya, THE `AmbientOrb` SHALL menampilkan `NostalgiaEffect` berupa glow hangat keemasan tipis (warna ≈ `#C8A050` dengan opacity ≤ 0.15) di sekitar Orb.
7. WHEN `NostalgiaEffect` aktif, THE `AmbientOrb` SHALL memperlambat `breathDuration` sebesar 20–30% dari nilai normal varian saat ini.
8. THE `FadeGranularity` SHALL mengekspos properti `isItalic` bertipe `bool` yang bernilai `true` hanya untuk state `silhouette` (28+ hari), dan sistem SHALL mencegah penerapan tipografi italic pada insight yang berusia kurang dari 28 hari.

---

### Requirement 8: Integrasi dengan Sistem yang Sudah Ada

**User Story:** Sebagai developer Luma, saya ingin fitur Adaptive Ambience terintegrasi mulus dengan `OrbStateEngine`, `InsightMemory`, dan `FadeGranularity` yang sudah ada, sehingga tidak ada duplikasi logika dan arsitektur tetap kohesif.

#### Acceptance Criteria

1. THE `AdaptiveAmbienceEngine` SHALL membaca `OrbState` dari `OrbStateEngine` yang sudah ada sebagai salah satu input kalkulasi, bukan menggantikannya.
2. THE `AdaptiveAmbienceEngine` SHALL membaca data historis `BehaviorSnapshot` dari `InsightMemory` yang sudah ada tanpa mengubah antarmuka `InsightMemory`.
3. THE `AmbientOrb` widget SHALL menerima `AmbienceProfile` sebagai parameter opsional — WHEN `AmbienceProfile` diberikan, THE `AmbientOrb` SHALL menggunakannya; IF tidak diberikan, THEN THE `AmbientOrb` SHALL menggunakan `OrbState` seperti sebelumnya untuk kompatibilitas mundur.
4. THE `FadeGranularity` SHALL diperluas dengan properti `isItalic` tanpa mengubah antarmuka yang sudah ada (`getState`, `getOpacity`, `getBlurSigma`, `getTimeLabel`, `getHintText`).
5. THE `LumaPalette` SHALL diperluas dengan token warna baru untuk varian Orb baru (`orbDusk`, `orbRecover`, `orbStellar`) tanpa mengubah token yang sudah ada.
6. WHEN `AdaptiveAmbienceEngine` tidak tersedia atau gagal menginisialisasi, THE `AmbientOrb` SHALL fallback ke perilaku `OrbState` lama tanpa error yang terlihat oleh pengguna; IF mekanisme fallback juga gagal, THEN THE `AmbientOrb` SHALL menampilkan `OrbState.dawn` sebagai perilaku default hardcoded.
7. THE `AdaptiveAmbienceEngine` SHALL menggunakan `SharedPreferences` yang sama dengan `OrbStateEngine` dengan namespace key yang berbeda (prefix `luma_ambience_`) untuk menghindari konflik.

---

### Requirement 9: Performa dan Aksesibilitas

**User Story:** Sebagai pengguna Luma, saya ingin animasi Adaptive Ambience tidak menguras baterai atau menyebabkan lag, dan saya ingin dapat menonaktifkan animasi jika diperlukan.

#### Acceptance Criteria

1. THE `AmbientOrb` SHALL menggunakan `RepaintBoundary` untuk mengisolasi area repaint dari widget lain di halaman yang sama.
2. THE `AmbientOrb` SHALL tidak melakukan kalkulasi berat (sorting, agregasi data) di dalam metode `paint` pada `CustomPainter`.
3. WHEN `reduceMotion` bernilai `true`, THE `AmbientOrb` SHALL menghentikan `AnimationController` dan menampilkan frame statis; selama transisi ke mode statis, `setState` boleh dipanggil beberapa kali sebelum animasi benar-benar berhenti.
4. WHEN durasi kalkulasi `AmbienceProfile` melebihi 16 ms, THE `AdaptiveAmbienceEngine` SHALL menjalankan kalkulasi tersebut di luar main thread menggunakan `compute()` atau `Isolate`.
5. THE `AmbientOrb` SHALL mendukung properti `semanticLabel` bertipe `String?` yang diteruskan ke `Semantics` widget untuk aksesibilitas pembaca layar.
6. WHEN `semanticLabel` tidak diberikan, THE `AmbientOrb` SHALL menggunakan label default berdasarkan `OrbVariant` aktif dalam bahasa yang sesuai dengan `LumaLanguage` aktif.
