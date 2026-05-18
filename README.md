# Luma - Personal Digital Behavior Intelligence

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **Luma** mengamati pola perilaku digitalmu secara pasif, memberikan insight tentang fokus, distraksi, dan keseimbangan hidup digital — tanpa judgement, tanpa friction.

---

## 🌟 Filosofi

### Zero Friction
Tidak ada setup rumit. Login Google = langsung jalan. Tidak ada form, tidak ada konfigurasi manual.

### Zero Knowledge
Server tidak pernah bisa membaca datamu. Enkripsi end-to-end dengan kunci yang hanya ada di perangkatmu dan Google Drive pribadimu.

### Memory-Inspired Design
Data memudar seperti ingatan manusia (**Fade Granularity**), bukan dihapus. Semakin lama, semakin abstrak — seperti kenangan.

### Grounded Tone
Insight yang observasional, bukan judgemental. Selaras dengan prinsip **Non-Violent Communication (NVC)**.

---

## 📱 Fitur Utama

- **Passive Tracking**: Merekam pola penggunaan layar tanpa intervensi user
- **Ambient Visualization**: Visualisasi abstrak yang menenangkan, bukan dashboard angka
- **Fading Timeline**: Data visual memudar seiring waktu (0-7 hari: tajam, 28+ hari: siluet)
- **Smart Insights**: Insight otomatis berdasarkan pola perilaku (maks 2 kalimat)
- **Waiting Room**: 3 hari pertama sebelum insight muncul (biarkan data terkumpul dulu)
- **Offline-First**: Semua data tersimpan lokal, sinkronisasi opsional ke Google Drive
- **Auto-Cleanup**: Data lama otomatis dirangkum dan dibersihkan sesuai retention policy

---

## 🏗️ Arsitektur

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│  (Pages, Widgets, Providers, Screens, Theme, Routes)        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  (Entities, Repositories Interfaces, Use Cases, Validators) │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  (Isar DB, Encryption, Sync, Tracking, Repositories Impl)   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    CORE LAYER                                │
│  (DI, Utils, Errors, Services, Constants, Extensions)       │
└─────────────────────────────────────────────────────────────┘
```

### Tech Stack

| Kategori | Technology |
|----------|-----------|
| **Framework** | Flutter 3.x, Dart |
| **State Management** | Riverpod, flutter_riverpod |
| **Database** | Isar (local NoSQL) |
| **Encryption** | cryptography (AES-256-GCM), crypto (SHA-256) |
| **Auth** | google_sign_in, googleapis, googleapis_auth |
| **Sync** | dio, googleapis (Drive API) |
| **Background** | workmanager |
| **Notifications** | flutter_local_notifications |
| **Secure Storage** | flutter_secure_storage |
| **DI** | get_it |

---

## 📂 Struktur Folder

```
lib/
├── main.dart                  # Entry point + DI initialization
├── config/                    # Konfigurasi global
│   ├── theme/                 # Dark/Light theme definitions
│   ├── constants/             # App-wide constants
│   └── routes/                # Navigation routes
├── core/                      # Core utilities & infrastructure
│   ├── di/                    # Dependency Injection (GetIt)
│   ├── utils/                 # Helper functions (fade granularity, etc.)
│   ├── services/              # Platform services
│   ├── errors/                # Custom exceptions & failures
│   └── extensions/            # Dart extensions
├── data/                      # Data layer implementation
│   ├── db/                    # Isar database
│   │   ├── database_service.dart
│   │   └── models/            # Isar collections (@Collection)
│   │       ├── raw_event.dart
│   │       ├── daily_summary_model.dart
│   │       ├── weekly_profile.dart
│   │       ├── baseline.dart
│   │       ├── insight.dart
│   │       └── app_preferences.dart
│   ├── encryption/            # Zero-knowledge encryption
│   │   └── encryption_service.dart
│   ├── sync/                  # Google Drive sync
│   │   └── drive_key_manager.dart
│   ├── tracking/              # Screen & usage tracking
│   └── repositories/          # Repository implementations
├── domain/                    # Business logic layer
│   ├── entities/              # Pure business objects
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business use cases
└── presentation/              # UI layer
    ├── pages/                 # Full-screen pages
    ├── widgets/               # Reusable widgets
    ├── providers/             # Riverpod providers
    ├── screens/               # Screen-specific components
    └── theme/                 # UI theme helpers
```

---

## 🔐 Keamanan & Privasi

### Zero-Knowledge Architecture

```
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│   Device     │      │  Google Drive│      │    Server    │
│              │      │  (appData)   │      │   (Optional) │
│  [Data] 🔒   │─────▶│  [Key] 🔒    │      │              │
│  [Key] 🗝️   │      │              │      │  [Ciphertext]│
└──────────────┘      └──────────────┘      └──────────────┘
```

- **Encryption Key**: Random 32-byte, disimpan di Google Drive user (appDataFolder)
- **Algorithm**: AES-256-GCM dengan random 96-bit IV
- **Key Cache**: Android Keystore / iOS Keychain via `flutter_secure_storage`
- **Server**: Hanya menyimpan ciphertext (jika cloud sync diaktifkan), tidak pernah melihat key

### Threat Model

| Ancaman | Status | Alasan |
|---------|--------|--------|
| Server baca data | ✅ Aman | Server hanya terima ciphertext |
| APK reverse engineering | ✅ Aman | Key random, tidak ada secret hardcoded |
| Attacker punya APK + userId | ✅ Aman | Butuh akses Google Drive user |
| Kehilangan Google account | ❌ Data hilang | By design, dikomunikasikan ke user |

---

## 🎨 Design System

### Fade Granularity

Data memudar seperti ingatan manusia:

| Usia Data | State | Opacity | Blur | Data Tersimpan |
|-----------|-------|---------|------|----------------|
| 0-7 hari | Sharp | 1.0 | 0 | `raw_event` + `daily_summary` |
| 8-14 hari | Dim | 0.85 | 0 | `daily_summary` |
| 15-28 hari | Blurry | 0.65 | σ=1.5 | `daily_summary` (agregat) |
| 28+ hari | Silhouette | 0.45 | σ=2.5 | `weekly_profile` + `baseline` |

### Tone Insight (NVC-Aligned)

✅ **Good:**
- "Pagi ini fokusmu stabil."
- "Tiga hari terakhir, ritmemu lebih padat. Bukan kegagalan, hanya ritme yang berubah."

❌ **Bad:**
- "Kamu harus tidur lebih awal."
- "Terlalu banyak distraksi."

### Severity Colors

| Level | Color | Usage |
|-------|-------|-------|
| Info | Blue | Informasi netral |
| Notice | Orange | Perhatian ringan |
| Warning | Red | Perlu aksi |
| Gentle | Green | Apresiasi |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x atau lebih baru
- Dart SDK 3.x atau lebih baru
- Android Studio / VS Code
- Google Cloud Console project (untuk Google Sign-In & Drive API)

### Installation

1. **Clone repository**
   ```bash
   git clone https://github.com/your-org/luma.git
   cd luma
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Isar models**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Google Sign-In**
   
   a. Buat project di [Google Cloud Console](https://console.cloud.google.com)
   
   b. Enable APIs:
      - Google Sign-In API
      - Google Drive API
   
   c. Buat OAuth 2.0 credentials:
      - Android: SHA-1 + package name
      - iOS: Bundle ID
   
   d. Update `android/app/google-services.json` dan `ios/Runner/GoogleService-Info.plist`

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Retention Policy

| Collection | Retention | Ukuran Estimasi |_cleanup_ |
|------------|-----------|-----------------|----------|
| `RawEvent` | 7 hari | ~100 MB/minggu | Auto-delete setelah 7 hari |
| `DailySummary` | 28 hari | ~2 MB/minggu | Auto-aggregate ke weekly setelah 28 hari |
| `WeeklyProfile` | 4 minggu | ~500 KB/minggu | Auto-delete setelah 4 minggu |
| `Baseline` | Selamanya | ~10 KB | Never delete |
| `Insight` | Selamanya | ~50 KB/minggu | Never delete |
| `AppPreferences` | Selamanya | ~1 KB | Never delete |

---

## 🔄 Background Services

### WorkManager Tasks

| Task | Frekuensi | Kondisi |
|------|-----------|---------|
| Daily Summarization | Setiap jam | Hanya saat charging |
| Weekly Profiling | Setiap Senin 00:00 | Always |
| Sync Task | Setiap 6 jam | Jika cloud sync aktif |

### Screen Listener

- BroadcastReceiver untuk `SCREEN_ON` / `SCREEN_OFF`
- Platform channel ke Flutter
- Trigger event aggregation

---

## 🧪 Testing

### Run Tests

```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test test/integration/

# All tests
flutter test
```

### Test Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📝 Development Checklist

### Phase 1: Foundation ✅
- [x] Setup Isar collections
- [x] Implement DriveKeyManager
- [x] Build EncryptionService
- [x] Create basic UI skeleton
- [x] Setup Dependency Injection

### Phase 2: Data Collection 🚧
- [ ] UsageStats listener
- [ ] Screen state receiver
- [ ] Event aggregator

### Phase 3: Insight Engine
- [ ] Rule engine threshold
- [ ] Template repository (ID + EN)
- [ ] NVC validator

### Phase 4: Polish
- [ ] Fading timeline visual
- [ ] Ambient visualization
- [ ] Backup/restore flow

---

## 📚 Documentation

- [Architecture Decision Records](.guideline/adr/)
- [Technical Foundation](.guideline/LUMA_TECHNICAL_FOUNDATION.md)
- [Design Revision](.guideline/Luma_Revision_01.md)
- [Visual Prototypes](.guideline/visual_prototype_dark.html) (Dark Theme)
- [Visual Prototypes](.guideline/visual_prototype_light.html) (Light Theme)

---

## 🤝 Contributing

Kami menyambut kontribusi! Silakan:

1. Fork repository
2. Buat feature branch (`git checkout -b feature/amazing-feature`)
3. Commit perubahan (`git commit -m 'Add amazing feature'`)
4. Push ke branch (`git push origin feature/amazing-feature`)
5. Buka Pull Request

### Code Style

Ikuti [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.

```bash
# Format code
dart format .

# Analyze code
flutter analyze
```

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

---

## 🙏 Acknowledgments

- Inspired by Non-Violent Communication (NVC) principles
- Built with ❤️ using Flutter
- Special thanks to all contributors

---

## 📞 Contact

- Website: [luma-app.dev](https://luma-app.dev) *(placeholder)*
- Email: hello@luma-app.dev *(placeholder)*
- Twitter: [@luma_app](https://twitter.com/luma_app) *(placeholder)*

---

<div align="center">

**Luma** — *Mengenal dirimu melalui pola digitalmu.*

Made with Flutter 🚀

</div>
