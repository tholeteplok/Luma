# PHASE 3 COMPLETED - Background Services

## ✅ Summary

Phase 3: Background Services telah selesai dengan komponen berikut:

### 📦 Files Created (2 files):
- `lib/core/services/background_task_manager.dart` - WorkManager initialization & task definitions
- `android/app/src/main/kotlin/com/example/luma_app/MainActivity.kt` - Native Android screen listener

### 🔧 Files Modified (4 files):
- `lib/data/db/database_service.dart` - Added CRUD methods for background tasks
- `lib/core/di/di.dart` - Registered BackgroundTaskInitializer
- `lib/data/tracking/event_aggregator.dart` - Already has aggregation logic
- `lib/data/tracking/usage_stats_service.dart` - Already has usage stats collection

---

## 🎯 Background Tasks Implemented

### 1. **Aggregate Events** (`com.luma.app.aggregate_events`)
- **Frequency**: Setiap 1 jam
- **Constraints**: Charging + Battery not low + Device idle
- **Function**: Mengagregasi raw events dari 1 jam terakhir menjadi daily metrics

### 2. **Generate Daily Summary** (`com.luma.app.daily_summary`)
- **Frequency**: Setiap hari (23:00)
- **Constraints**: Battery not low
- **Function**: Membuat summary lengkap untuk hari yang sudah selesai

### 3. **Generate Weekly Profile** (`com.luma.app.weekly_profile`)
- **Frequency**: Setiap 7 hari
- **Constraints**: Battery not low
- **Function**: Agregasi 7 daily summaries menjadi weekly profile

### 4. **Cleanup Expired Data** (`com.luma.app.cleanup_data`)
- **Frequency**: Setiap hari (03:00)
- **Constraints**: None
- **Function**: Hapus data expired berdasarkan fade granularity policy

---

## 📱 Android Native Integration

### MainActivity.kt
Implementasi `EventChannel` untuk screen state listener:
- Listen `ACTION_SCREEN_ON` dan `ACTION_SCREEN_OFF` broadcast
- Stream events ke Flutter melalui platform channel
- Auto cleanup on destroy

### Permissions Required (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
```

---

## 🔧 Database Service Updates

### New Methods Added:
```dart
// Raw Events
Future<List<RawEvent>> getRawEventsBetween(DateTime start, DateTime end)
Future<int> deleteRawEventsOlderThan(DateTime date)

// Daily Summaries
Future<DailySummary?> getDailySummaryByDate(DateTime date)
Future<List<DailySummary>> getDailySummariesBetween(DateTime start, DateTime end)
Future<int> deleteDailySummariesOlderThan(DateTime date)

// Weekly Profiles
Future<void> saveWeeklyProfile(WeeklyProfile profile)
Future<WeeklyProfile?> getWeeklyProfile(DateTime weekStart)
Future<List<WeeklyProfile>> getWeeklyProfilesBetween(DateTime start, DateTime end)
Future<int> deleteWeeklyProfilesOlderThan(DateTime date)

// Daily Metrics (Aggregated)
Future<void> saveDailyMetric(DailyAppMetric metric)
Future<List<DailyAppMetric>> getDailyMetricsForDate(DateTime date)
```

---

## 🚀 Usage

### Initialize di main.dart:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await initDependencies();
  
  // Initialize background tasks
  await sl<BackgroundTaskInitializer>().initialize();
  
  runApp(const MyApp());
}
```

### Manual Trigger untuk Testing:
```dart
// Trigger daily summary manually
await sl<BackgroundTaskInitializer>().triggerManualTask(
  BackgroundTasks.generateDailySummary,
);

// Cancel all tasks (untuk logout/reset)
await sl<BackgroundTaskInitializer>().cancelAll();
```

---

## ⚠️ Important Notes

1. **Build Runner**: Jangan lupa jalankan setelah membuat changes:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **WorkManager Constraints**: 
   - Tasks hanya jalan saat device charging (untuk battery efficiency)
   - Di debug mode, tasks bisa dipicu manual untuk testing

3. **Platform Specific**:
   - Screen listener hanya tersedia di Android
   - iOS akan menggunakan fallback (tidak track screen state)

4. **Battery Optimization**: 
   - User perlu disable battery optimization untuk Luma
   - Agar background tasks bisa jalan konsisten

---

## 📊 Task Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    WorkManager Scheduler                     │
└───────────────┬─────────────────────────────────────────────┘
                │
        ┌───────┼───────────┬───────────────┬─────────────────┐
        │       │           │               │                 │
        ▼       ▼           ▼               ▼                 ▼
   ┌────────┐ ┌──────────┐ ┌────────────┐ ┌──────────────┐ ┌──────────┐
   │Aggregate│ │Daily     │ │Weekly      │ │Cleanup       │ │Manual    │
   │Events  │ │Summary   │ │Profile     │ │Expired Data  │ │Triggers  │
   │(1 hour)│ │(23:00)   │ │(7 days)    │ │(03:00)       │ │          │
   └────┬───┘ └────┬─────┘ └─────┬──────┘ └──────┬───────┘ └──────────┘
        │          │             │                │
        │          ▼             ▼                ▼
        │    ┌─────────────────────────────────────────┐
        │    │          EventAggregator                 │
        │    │  - aggregateDay()                        │
        │    │  - generateDailySummary()                │
        │    │  - generateWeeklyProfile()               │
        │    └─────────────────────────────────────────┘
        │                      │
        ▼                      ▼
   ┌─────────────────────────────────────────┐
   │         DatabaseService (Isar)          │
   │  - Save/Get RawEvents                   │
   │  - Save/Get DailySummaries              │
   │  - Save/Get WeeklyProfiles              │
   │  - Delete Expired Data                  │
   └─────────────────────────────────────────┘
```

---

## ✅ Phase 3 Checklist

- [x] WorkManager setup dengan callback dispatcher
- [x] 4 periodic tasks registered
- [x] Constraints configuration (charging, battery, idle)
- [x] Android native screen listener
- [x] Database CRUD methods lengkap
- [x] DI registration
- [x] Manual trigger function untuk testing
- [x] Cleanup logic sesuai fade granularity

---

## 🎯 Next: Phase 4 - Insight Engine

Phase 4 akan menambahkan:
1. **Rule Engine** - Threshold-based insight generation
2. **Template Repository** - Multi-language insight templates (ID + EN)
3. **NVC Validator** - Locale-aware tone validation
4. **Insight Generator** - Combine rules + templates → insights
5. **Baseline Calculator** - Long-term pattern detection

Ready untuk lanjut ke Phase 4?
