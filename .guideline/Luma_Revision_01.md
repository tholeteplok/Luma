# UPDATE 1: LUMA_TECHNICAL_FOUNDATION.md

## Perubahan yang Dilakukan

1. **Section 2.3** → Progressive Summarization diganti dengan **Fade Granularity**
2. **Section 5** → Insight Generation Engine (sudah di-update dengan semantic intent dari obrolan sebelumnya, sekarang ditambahkan NVC Validator locale-aware)
3. **Section 10** → Backup & Restore (dari full DB export → hanya insight + agregat)
4. **Hapus semua referensi ke Supabase** (karena pure offline)

---

### Revised Section 2.3: Fade Granularity (Memory as Architecture)

```dart
// lib/core/utils/fade_granularity.dart

/// Fade Granularity — Memory Decay System
/// 
/// Luma tidak menggunakan DELETE, PURGE, atau ARCHIVE.
/// Luma menggunakan FADE (pengaburan progresif).
/// Detail memudar, pola menetap.
/// Ini meniru sifat alami ingatan manusia.

enum DataFadeState {
  sharp,      // 0-7 hari: opacity 1.0, no blur
  dim,        // 8-14 hari: opacity 0.85, no blur
  blurry,     // 15-28 hari: opacity 0.65, blur σ=1.5
  silhouette, // 28+ hari: opacity 0.45, blur σ=2.5
}

class FadeGranularity {
  /// Return fade state berdasarkan usia data (hari)
  static DataFadeState getState(int daysOld) {
    if (daysOld <= 7) return DataFadeState.sharp;
    if (daysOld <= 14) return DataFadeState.dim;
    if (daysOld <= 28) return DataFadeState.blurry;
    return DataFadeState.silhouette;
  }
  
  /// Opacity untuk UI rendering
  static double getOpacity(int daysOld) {
    switch (getState(daysOld)) {
      case DataFadeState.sharp: return 1.0;
      case DataFadeState.dim: return 0.85;
      case DataFadeState.blurry: return 0.65;
      case DataFadeState.silhouette: return 0.45;
    }
  }
  
  /// Blur sigma untuk CustomPainter
  static double getBlurSigma(int daysOld) {
    switch (getState(daysOld)) {
      case DataFadeState.sharp: return 0.0;
      case DataFadeState.dim: return 0.0;
      case DataFadeState.blurry: return 1.5;
      case DataFadeState.silhouette: return 2.5;
    }
  }
  
  /// Label untuk UI (locale-aware)
  static String getTimeLabel(int daysOld, LumaLanguage language) {
    final isId = language == LumaLanguage.indonesian;
    
    if (daysOld <= 7) {
      return isId ? "Hari ini" : "Today";
    }
    if (daysOld <= 14) {
      return isId ? "Minggu lalu" : "Last week";
    }
    if (daysOld <= 28) {
      return isId ? "Pertengahan bulan" : "Mid month";
    }
    return isId ? "Bulan lalu" : "Last month";
  }
  
  /// Tooltip hint (pasif, tidak mendesak)
  static String getHintText(LumaLanguage language) {
    return language == LumaLanguage.indonesian
        ? "Data ini akan dirangkum dalam beberapa hari. Pola tetap tersimpan."
        : "This data will be summarized in a few days. Patterns remain.";
  }
}
```

**Data Retention Policy (Updated):**

| Fase | Usia Data | Data yang Ditahan | Opacity | Blur |
|------|-----------|-------------------|---------|------|
| Tajam | 0-7 hari | raw_event + daily_summary | 1.0 | 0 |
| Redup | 8-14 hari | daily_summary saja | 0.85 | 0 |
| Samar | 15-28 hari | daily_summary (agregat) | 0.65 | 1.5 |
| Siluet | 28+ hari | weekly_profile + baseline | 0.45 | 2.5 |

**Rule:** Tidak ada countdown, tidak ada warning icon, tidak ada progress bar mendesak. Fading adalah state, bukan event.

---

### Revised Section 5: Insight Generation Engine (Semantic Intent + NVC Locale-Aware)

Sudah di-update di obrolan sebelumnya. Tambahan:

```dart
// lib/core/utils/nvc_validator.dart

/// NVC Validator — Locale-Aware
/// Berjalan setelah rendering, memeriksa output, bukan template.

class NVCValidator {
  static bool validate(String text, LumaLanguage language, InsightTone tone) {
    switch (language) {
      case LumaLanguage.indonesian:
        return _validateIndonesian(text, tone);
      case LumaLanguage.english:
        return _validateEnglish(text, tone);
      // Future: japanese, german
    }
  }
  
  static bool _validateIndonesian(String text, InsightTone tone) {
    // Kata yang dihindari
    final forbidden = [
      'harus', 'jangan', 'selalu', 'tidak pernah', 
      'terlalu', 'kurang', 'seharusnya', 'baiknya'
    ];
    
    if (forbidden.any((word) => text.toLowerCase().contains(word))) {
      return false;
    }
    
    // Self-compassion tone: wajib ada frasa compassion
    if (tone == InsightTone.self_compassion) {
      final compassionPhrases = ['tidak apa-apa', 'wajar', 'istirahat', 'oke'];
      if (!compassionPhrases.any((p) => text.toLowerCase().contains(p))) {
        return false;
      }
    }
    
    // Maks 2 kalimat
    final sentenceCount = text.split(RegExp(r'[.!?]')).length - 1;
    if (sentenceCount > 2) return false;
    
    return true;
  }
  
  static bool _validateEnglish(String text, InsightTone tone) {
    final forbidden = [
      'should', 'must', 'always', 'never', 
      'too', 'need to', 'fix', 'better', 'worse'
    ];
    
    if (forbidden.any((word) => text.toLowerCase().contains(word))) {
      return false;
    }
    
    if (tone == InsightTone.self_compassion) {
      final compassionPhrases = ['it\'s okay', 'rest', 'normal', 'alright'];
      if (!compassionPhrases.any((p) => text.toLowerCase().contains(p))) {
        return false;
      }
    }
    
    final sentenceCount = text.split(RegExp(r'[.!?]')).length - 1;
    if (sentenceCount > 2) return false;
    
    return true;
  }
  
  static String getFallbackMessage(LumaLanguage language) {
    return language == LumaLanguage.indonesian
        ? "Luma mengamati ritmemu."
        : "Luma is observing your rhythm.";
  }
}
```

---

### Revised Section 10: Backup & Restore (Pure Offline + Drive)

```dart
// lib/data/backup/drive_backup_manager.dart

/// Backup Pragmatis — Hanya Insight + Agregat
/// 
/// Filosofi:
/// Backup bukan fitur teknis. Backup adalah pilihan emosional.
/// User memilih: membiarkan detail memudar alami, 
/// atau menjaga detail hidup lebih lama.
///
/// Target backup: insight, weekly_profile, baseline, user_preferences
/// Ukuran: ~1 MB/bulan
/// Sumber: Google Drive appDataFolder (ADR-001)
/// Enkripsi: AES-256-GCM (lokal) → ciphertext di-upload

class DriveBackupManager {
  static const String _backupFolder = 'luma_backups';
  
  final GoogleSignIn _googleSignIn;
  final EncryptionService _encryptionService;
  final IsarService _isarService;
  
  DriveBackupManager({
    required GoogleSignIn googleSignIn,
    required EncryptionService encryptionService,
    required IsarService isarService,
  });
  
  /// Backup hanya data penting (bukan raw events)
  Future<void> backup() async {
    final isar = await _isarService.openDb();
    final userId = _googleSignIn.currentUser?.id;
    if (userId == null) throw Exception('Not signed in');
    
    // Kumpulkan data yang akan dibackup
    final backupData = <String, dynamic>{
      'version': '1.1',
      'exportedAt': DateTime.now().toIso8601String(),
      'userId': userId,
      'insights': await isar.insights.where().findAll(),
      'weeklyProfiles': await isar.weeklyProfiles.where().findAll(),
      'baseline': await isar.baselines.where().findFirst(),
      'preferences': await isar.userPreferences.where().findFirst(),
    };
    
    // Serialize, compress, encrypt
    final jsonString = jsonEncode(backupData);
    final compressed = gzip.encode(utf8.encode(jsonString));
    final encrypted = await _encryptionService.encryptBytes(compressed);
    
    // Upload ke Google Drive
    final fileName = 'backup_${DateTime.now().toIso8601String()}.enc';
    await _uploadToDrive(fileName, encrypted);
    
    // Catat metadata backup
    await _recordBackupMetadata(fileName, backupData);
  }
  
  /// Restore dari file backup
  Future<void> restore(String fileName) async {
    // Download, decrypt, decompress, deserialize
    final encrypted = await _downloadFromDrive(fileName);
    final compressed = await _encryptionService.decryptBytes(encrypted);
    final jsonString = utf8.decode(gzip.decode(compressed));
    final backupData = jsonDecode(jsonString) as Map<String, dynamic>;
    
    // Restore ke Isar
    final isar = await _isarService.openDb();
    await isar.writeTxn(() async {
      await isar.insights.putAll(backupData['insights']);
      await isar.weeklyProfiles.putAll(backupData['weeklyProfiles']);
      if (backupData['baseline'] != null) {
        await isar.baselines.put(backupData['baseline']);
      }
      if (backupData['preferences'] != null) {
        await isar.userPreferences.put(backupData['preferences']);
      }
    });
  }
  
  /// Ukuran backup ~1 MB/bulan
  Future<int> estimateBackupSize() async {
    final isar = await _isarService.openDb();
    final insights = await isar.insights.where().findAll();
    final weeklyProfiles = await isar.weeklyProfiles.where().findAll();
    
    // Estimasi kasar
    return (insights.length * 500) + (weeklyProfiles.length * 200);
  }
}
```

**Threat Model (Pragmatic):**

| Ancaman | Status | Mekanisme |
|---------|--------|-----------|
| Server Luma baca data | ✅ Tidak bisa | Server tidak ada (pure offline) |
| APK reverse engineering | ✅ Tidak berbahaya | Key random, tidak ada secret hardcoded |
| Attacker punya APK + userId | ✅ Tidak cukup | Butuh akses Google Drive user |
| User kehilangan Google account | ❌ Data tidak bisa dipulihkan | By design, dikomunikasikan eksplisit |
| Forensic/device seizure | ⚠️ Data lokal terenkripsi | Fokus pada proteksi casual |

---

# UPDATE 2: LUMA_DESIGN.md

## Perubahan yang Dilakukan

1. **Section 8.4** → Insight Card: tone grounded, observasional
2. **Section 8.5** → Timeline: fading visual berdasarkan usia data
3. **Section 8.9** → Settings: backup copywriting baru (emosional tapi fungsional)
4. **Section 5.2** → Severity Colors: tetap, tapi ditambahkan aturan fading

---

### Revised Section 8.4: Insight Card (Grounded Tone)

**Perubahan Utama:**
- Insight card tidak puitis berlebihan
- Tone: grounded, observasional, NVC-aligned
- Angka tidak pernah muncul di insight card
- Maks 2 kalimat

**Copywriting Examples (Indonesia):**

| Intent | Copy |
|--------|------|
| focus_session_detected | "Pagi ini fokusmu stabil." |
| focus_session_long | "Sesi fokus terlama hari ini: 2 jam 15 menit." |
| late_night_first_time | "Malam tadi berbeda dari biasanya." |
| late_night_consecutive | "3 malam terakhir, layar tetap menyala lebih lama." |
| burnout_accumulation_moderate | "Tiga hari terakhir, ritmemu lebih padat. Bukan kegagalan, hanya ritme yang berubah." |
| weekly_balanced | "Minggu yang seimbang. Fokusmu paling stabil di hari Selasa." |

**Copywriting Examples (English):**

| Intent | Copy |
|--------|------|
| focus_session_detected | "Your focus is steady this morning." |
| focus_session_long | "Your longest focus session today: 2 hours 15 minutes." |
| late_night_first_time | "Last night had a different rhythm." |
| late_night_consecutive | "The last 3 nights, your screen stayed on longer." |
| burnout_accumulation_moderate | "Your rhythm has been heavier for three days. Not a failure — just a shift." |
| weekly_balanced | "A balanced week. Your focus was most steady on Tuesday." |

---

### Revised Section 8.5: Timeline with Fading Visual

```dart
// lib/presentation/widgets/timeline/tiny_timeline.dart

class TinyTimeline extends StatelessWidget {
  final List<DailySummary> summaries;
  final LumaLanguage language;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 72,
          child: CustomPaint(
            painter: FadingTimelinePainter(
              summaries: summaries,
              language: language,
              today: DateTime.now(),
            ),
          ),
        ),
        SizedBox(height: 6),
        // Hint text pasif (tidak mendesak)
        Text(
          FadeGranularity.getHintText(language),
          style: LumaTypography.labelMedium.copyWith(
            color: LumaColors.textSubtle,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// lib/presentation/painters/fading_timeline_painter.dart

class FadingTimelinePainter extends CustomPainter {
  final List<DailySummary> summaries;
  final LumaLanguage language;
  final DateTime today;
  
  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / summaries.length;
    
    for (int i = 0; i < summaries.length; i++) {
      final summary = summaries[i];
      final daysOld = today.difference(summary.date).inDays;
      
      // Fade effect berdasarkan usia data
      final opacity = FadeGranularity.getOpacity(daysOld);
      final blurSigma = FadeGranularity.getBlurSigma(daysOld);
      
      // Warna berdasarkan focus quality (tanpa angka)
      final baseColor = summary.focusQuality > 0.7
          ? LumaColors.encodeFocus
          : summary.focusQuality > 0.4
              ? LumaColors.accentMuted
              : LumaColors.encodeDistraction;
      
      final paint = Paint()
        ..color = baseColor.withOpacity(opacity)
        ..maskFilter = blurSigma > 0
            ? MaskFilter.blur(BlurStyle.normal, blurSigma)
            : null;
      
      final barRect = Rect.fromLTWH(
        i * barWidth,
        size.height - (summary.focusQuality * size.height).clamp(8, size.height),
        barWidth - 2,
        (summary.focusQuality * size.height).clamp(8, size.height),
      );
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(barRect, Radius.circular(3)),
        paint,
      );
    }
  }
}
```

**Fading State Visual:**

| Fase | Opacity | Blur | Tooltip |
|------|---------|------|---------|
| Tajam (0-7 hari) | 1.0 | 0 | "Hari ini" |
| Redup (8-14 hari) | 0.85 | 0 | "Minggu lalu" |
| Samar (15-28 hari) | 0.65 | 1.5 | "Pertengahan bulan" |
| Siluet (28+ hari) | 0.45 | 2.5 | "Bulan lalu — pola tetap tersimpan" |

**Rule:** Tidak ada countdown, tidak ada warning icon, tidak ada progress bar.

---

### Revised Section 8.9: Settings Screen — Backup Section

**Copywriting Baru (Indonesia):**

```
┌─────────────────────────────────────────────────┐
│  ─────────── CADANGAN ────────────────────────  │
│                                                 │
│  "Jika ingin menjaga detail lebih lama,        │
│   simpan salinan ke Google Drive.              │
│                                                 │
│   Jika tidak, Luma akan merangkumnya           │
│   seperti ingatan biasa."                      │
│                                                 │
│  [🔄 Cadangkan Sekarang]                        │
│                                                 │
│  Cadangan terakhir: 16 Mei 2026                │
│  Ukuran: 1.2 MB                                │
│                                                 │
│  ─────────────────────────────────────────────  │
│  [Daftar backup tersedia]                      │
│  • 16 Mei 2026 (1.2 MB)                        │
│  • 9 Mei 2026 (1.1 MB)                         │
│  • 2 Mei 2026 (1.0 MB)                         │
│                                                 │
│  [⚙️ Backup otomatis setiap Minggu] (toggle)   │
│    → Default: ON                               │
│    → Hanya saat charging + WiFi                │
└─────────────────────────────────────────────────┘
```

**Copywriting Baru (English):**

```
┌─────────────────────────────────────────────────┐
│  ─────────── BACKUP ──────────────────────────  │
│                                                 │
│  "If you want to keep details longer,          │
│   save a copy to Google Drive.                 │
│                                                 │
│   If not, Luma will summarize them             │
│   like ordinary memory."                       │
│                                                 │
│  [🔄 Backup Now]                               │
│                                                 │
│  Last backup: May 16, 2026                     │
│  Size: 1.2 MB                                  │
│                                                 │
│  ─────────────────────────────────────────────  │
│  [Available backups]                           │
│  • May 16, 2026 (1.2 MB)                       │
│  • May 9, 2026 (1.1 MB)                        │
│  • May 2, 2026 (1.0 MB)                        │
│                                                 │
│  [⚙️ Auto-backup every Sunday] (toggle)        │
│    → Default: ON                               │
│    → Only when charging + WiFi                 │
└─────────────────────────────────────────────────┘
```

**Restore Confirmation Bottom Sheet:**

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  "Pulihkan dari Cadangan?"                     │
│                                                 │
│  "Ini akan mengganti data yang ada.            │
│   Data saat ini tidak bisa digabungkan.        │
│                                                 │
│   Cadangan: 16 Mei 2026                        │
│   Ukuran: 1.2 MB"                              │
│                                                 │
│  [Pulihkan]              [Batal]               │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

### Section 5.2: Severity Colors — Added Fading Rule

```dart
// Tambahan aturan: Severity colors juga ikut fade
// Saat data memasuki fase Redup/Samar/Siluet, warna severity juga
// mengalami desaturasi secara halus.

extension SeverityColors on InsightSeverity {
  Color getIndicatorColor(int daysOld) {
    final baseColor = _getBaseIndicatorColor();
    final opacity = FadeGranularity.getOpacity(daysOld);
    
    // Desaturasi halus untuk data lama
    if (daysOld > 14) {
      return baseColor.withOpacity(opacity * 0.7);
    }
    
    return baseColor.withOpacity(opacity);
  }
}
```

---

# UPDATE 3: ADR-001-CROSS-DEVICE-SYNC.md → ADR-001-BACKUP-KEY-MANAGEMENT.md

## Perubahan yang Dilakukan

1. **Rename** → ADR-001-BACKUP-KEY-MANAGEMENT.md
2. **Clarify scope**: Backup hanya insight + agregat (bukan raw events)
3. **Hapus semua referensi ke "sync"** (karena pure offline)
4. **Tambahkan filosofi backup sebagai pilihan emosional**

---

### Revised ADR-001: Backup & Key Management

**Status**: ACCEPTED (Updated 18 Mei 2026)  
**Tanggal Awal**: 16 Mei 2026  
**Tanggal Update**: 18 Mei 2026  
**Berlaku untuk**: Phase 0–3  
**Perubahan utama**: Backup scope diperkecil ke insight + agregat, clarify pure offline

---

## Keputusan

**Gunakan Google Drive Key Wrapping (C1) untuk encryption key, dan Google Drive appDataFolder untuk backup data insight + agregat.**

- Encryption key: random 32-byte, disimpan di `appDataFolder/key.json`
- Backup data: hanya insight, weekly_profile, baseline, user_preferences (~1 MB/bulan)
- Server Luma: **TIDAK ADA** (pure offline)

---

## Filosofi Backup

> Backup bukan fitur teknis. Backup adalah pilihan emosional.
> User memilih: membiarkan detail memudar alami, atau menjaga detail hidup lebih lama.

**Konsekuensi:**
- Backup tidak otomatis tanpa persetujuan user (default: ON, tapi user bisa OFF)
- Tidak ada "upgrade to premium for more storage"
- Copywriting: emosional tapi fungsional, bukan fear-based

---

## Arsitektur Teknis

### Apa yang Dibackup

| Data | Ukuran | Frekuensi Backup |
|------|--------|------------------|
| insights | ~500 bytes/hari | Setiap backup |
| weekly_profiles | ~200 bytes/minggu | Setiap backup |
| baseline | ~10 KB | Setiap backup |
| user_preferences | ~1 KB | Setiap backup |
| **Total** | **~1 MB/bulan** | - |

### Apa yang TIDAK Dibackup

- raw_event (7 hari, terlalu besar, tidak perlu)
- daily_summary (bisa di-re-generate dari insight)

### Flow Backup

```
[User trigger backup manual ATAU schedule mingguan]
        │
        ▼
[Kumpulkan data: insights + weekly_profiles + baseline + preferences]
        │
        ▼
[Serialize ke JSON + gzip compress]
        │
        ▼
[AES-256-GCM encrypt dengan key dari DriveKeyManager]
        │
        ▼
[Upload ke Google Drive appDataFolder/luma_backups/]
        │
        ▼
[Tampilkan "Cadangan terakhir: hari ini"]
```

### Flow Restore

```
[User pilih file backup dari daftar]
        │
        ▼
[Download dari Google Drive]
        │
        ▼
[Decrypt dengan key yang sama]
        │
        ▼
[Decompress + deserialize]
        │
        ▼
[Replace existing data di Isar]
        │
        ▼
[Tampilkan "Data dipulihkan"]
```

---

## Threat Model (Updated)

| Ancaman | Status | Mekanisme |
|---------|--------|-----------|
| Server Luma baca data | ✅ Tidak bisa | Server tidak ada (pure offline) |
| APK reverse engineering | ✅ Tidak berbahaya | Key random, tidak ada secret hardcoded |
| Attacker punya APK + userId | ✅ Tidak cukup | Butuh akses Google Drive user |
| User kehilangan Google account | ❌ Data tidak bisa dipulihkan | By design, dikomunikasikan eksplisit |
| Forensic/device seizure | ⚠️ Data lokal terenkripsi | Fokus pada proteksi casual |
| Backup file di Drive di-breach | ✅ Tidak berguna | Ciphertext tanpa key = noise |

---

## Perubahan dari ADR-001 Original

| Aspek | Original (16 Mei) | Updated (18 Mei) |
|-------|-------------------|------------------|
| Nama | ADR-001-CROSS-DEVICE-SYNC.md | ADR-001-BACKUP-KEY-MANAGEMENT.md |
| Server | Supabase untuk sync | ❌ TIDAK ADA (pure offline) |
| Backup unit | Full Isar database | Hanya insight + agregat |
| Ukuran backup | ~30 MB/tahun | ~1 MB/bulan |
| Cross-device | Otomatis via Supabase | Manual restore dari file backup |
| Filosofi | Teknis | Pilihan emosional |

---

## Copywriting untuk Backup (di Settings)

### Indonesia

```
"Jika ingin menjaga detail lebih lama, simpan salinan ke Google Drive.
 Jika tidak, Luma akan merangkumnya seperti ingatan biasa."
```

### English

```
"If you want to keep details longer, save a copy to Google Drive.
 If not, Luma will summarize them like ordinary memory."
```

---

## Implementation Checklist (Updated)

```dart
// Phase 0-1 Backup Implementation

// [ ] DriveKeyManager (sama seperti ADR-001 original)
//   → getOrCreateKey() → random 32-byte
//   → cache di Android Keystore
//   → save ke Drive appDataFolder/key.json

// [ ] EncryptionService (sama)
//   → AES-256-GCM dengan key dari DriveKeyManager

// [ ] DriveBackupManager (BARU, lebih kecil scope)
//   → backup() → hanya insight + weekly_profile + baseline + preferences
//   → restore(fileName) → replace data di Isar
//   → listBackups() → daftar file backup di Drive
//   → deleteBackup(fileName)

// [ ] Scheduled Backup (via WorkManager)
//   → Minggu 00:00, hanya jika charging + WiFi
//   → Default: ON, user bisa OFF di Settings

// [ ] Settings Backup UI
//   → Copywriting baru (emosional tapi fungsional)
//   → Tombol "Cadangkan Sekarang"
//   → Daftar backup yang tersedia
//   → Toggle auto-backup
```

---

## Kesimpulan

ADR-001 sekarang secara eksplisit menyatakan:

1. **Luma adalah pure offline** — tidak ada server Luma
2. **Backup adalah pilihan** — bukan kewajiban teknis
3. **Key tetap di Drive** — zero-knowledge terjaga
4. **Backup scope kecil** — hanya insight + agregat (~1 MB/bulan)

---

## Ringkasan Semua Perubahan

| Dokumen | Perubahan Utama | Status |
|---------|-----------------|--------|
| LUMA_TECHNICAL_FOUNDATION.md | §2.3 Fade Granularity, §5 NVC Locale-Aware, §10 Backup kecil | ✅ Updated |
| LUMA_DESIGN.md | §8.4 Insight Card (grounded), §8.5 Timeline fading, §8.9 Backup copywriting | ✅ Updated |
| ADR-001 | Rename, clarify pure offline, backup scope kecil, filosofi emosional | ✅ Updated |

---
