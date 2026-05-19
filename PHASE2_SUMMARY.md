# ✅ PHASE 2 COMPLETED - Data Collection Layer

## Summary

Phase 2 telah selesai dengan implementasi lengkap **Data Collection Layer** untuk mengumpulkan data penggunaan device secara pasif.

---

## 📦 Files Created/Modified

### 1. **UsageStatsService** (`lib/data/tracking/usage_stats_service.dart`)
Service untuk mengakses Android UsageStats API.

**Features:**
- ✅ Check usage stats permission status
- ✅ Request usage stats permission
- ✅ Redirect to settings for manual grant
- ✅ Get recent app usage (configurable duration)
- ✅ Get current foreground app snapshot
- ✅ Get top apps by usage duration
- ✅ Auto-filter system apps

**Key Methods:**
```dart
Future<bool> hasUsageStatsPermission()
Future<bool> requestUsageStatsPermission()
Future<void> openAppSettings()
Future<List<RawEvent>> getRecentAppUsage({Duration duration})
Future<RawEvent?> getCurrentForegroundApp()
Future<Map<String, int>> getTopApps({Duration duration, int limit})
```

---

### 2. **ScreenStateListener** (`lib/core/platform/screen_state_listener.dart`)
Platform channel untuk mendengarkan screen ON/OFF events.

**Features:**
- ✅ Broadcast stream untuk screen state changes
- ✅ Method channel communication dengan native Android
- ✅ Auto-start/stop listening
- ✅ Get current screen state

**Platform Integration:**
- Android: BroadcastReceiver untuk `ACTION_SCREEN_ON`, `ACTION_SCREEN_OFF`, `ACTION_USER_PRESENT`
- iOS: Ready for DarwinNotificationCenter (future implementation)

**Key Methods:**
```dart
void initialize()
Stream<ScreenStateEvent> get screenStateStream
Future<void> dispose()
Future<bool> isScreenOn()
```

---

### 3. **EventAggregator** (`lib/data/tracking/event_aggregator.dart`)
Core logic untuk aggregasi raw events menjadi insights.

**Features:**
- ✅ Auto-listen screen state events → save to DB
- ✅ Periodic app usage collection
- ✅ Daily aggregation logic
- ✅ Pending days backfill
- ✅ Focus score calculation (0-100)
- ✅ Distraction counting (social media switches)
- ✅ Top apps ranking
- ✅ Screen on/off counting

**Metrics Calculated:**
| Metric | Description |
|--------|-------------|
| `totalScreenTimeSeconds` | Total waktu layar aktif |
| `appUsageMinutes` | Breakdown per aplikasi |
| `topApps` | Top 5 apps by duration |
| `screenOnCount` | Jumlah kali layar dinyalakan |
| `screenOffCount` | Jumlah kali layar dimatikan |
| `focusScore` | Score 0-100 (sedikit switch = tinggi) |
| `distractionCount` | Jumlah switch ke social media |

**Key Methods:**
```dart
void initialize()
Future<int> collectAppUsage()
Future<DailySummary?> aggregateDay(DateTime date)
Future<int> aggregatePendingDays()
```

---

### 4. **Android Native Implementation** (`android/app/src/main/kotlin/.../MainActivity.kt`)
Kotlin code untuk screen state listener.

**Features:**
- ✅ Method channel setup (`luma/screen_state`)
- ✅ BroadcastReceiver registration
- ✅ SCREEN_ON / SCREEN_OFF / USER_PRESENT handling
- ✅ Auto-unregister on destroy
- ✅ PowerManager integration for current state

---

### 5. **Android Permissions** (`android/app/src/main/AndroidManifest.xml`)
Permissions yang ditambahkan:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

---

### 6. **Updated Models**

#### `raw_event.dart`
- ✅ Added `EventType` enum (separated to `event_type.dart`)
- ✅ Added `type` field
- ✅ Added `appName` field
- ✅ Added `metadata` map
- ✅ Constructor with defaults

#### `daily_summary_model.dart`
- ✅ Updated fields untuk match aggregator output
- ✅ Added `appUsageMinutes` map
- ✅ Added `topApps` list
- ✅ Added `screenOnCount` / `screenOffCount`
- ✅ Added `focusScore` (double 0-100)
- ✅ Added `distractionCount`
- ✅ Constructor dengan auto expiresAt

#### `event_type.dart` (NEW)
- ✅ Separated enum untuk avoid circular dependency

---

### 7. **Updated Database Service** (`lib/data/db/database_service.dart`)
Added CRUD methods:

**Raw Events:**
```dart
Future<void> saveRawEvent(RawEvent event)
Future<void> saveRawEvents(List<RawEvent> events)
Future<List<RawEvent>> getRawEvents({startTime, endTime})
Future<List<RawEvent>> getRawEventsByPackage({packageName, startTime, endTime})
Future<void> deleteRawEvent(Id id)
```

**Daily Summaries:**
```dart
Future<void> saveDailySummary(DailySummary summary)
Future<DailySummary?> getDailySummary(DateTime date)
Future<List<DailySummary>> getDailySummaries({startTime, endTime})
```

---

### 8. **Updated Dependency Injection** (`lib/core/di/di.dart`)
Registered new services:
- ✅ `ScreenStateListener`
- ✅ `UsageStatsService`
- ✅ `EventAggregator` (dengan dependencies injection)

---

### 9. **Barrel Exports**
- ✅ `lib/data/tracking/tracking.dart` - Export tracking module
- ✅ `lib/data/db/models/models.dart` - Added `event_type.dart` export

---

## 🔄 Data Flow

```
┌─────────────────────┐
│  ScreenStateListener │
│  (Platform Channel)  │
└──────────┬──────────┘
           │ Stream<ScreenStateEvent>
           ▼
┌─────────────────────┐
│   EventAggregator    │
│   (Auto-listen &     │
│    aggregate)        │
└──────────┬──────────┘
           │ RawEvent
           ▼
┌─────────────────────┐
│   DatabaseService    │
│   (Isar DB)          │
└──────────┬──────────┘
           │ Query
           ▼
┌─────────────────────┐
│   DailySummary       │
│   (Aggregated data)  │
└─────────────────────┘
```

---

## 📊 Permission Flow (Android)

```
User opens Luma
    ↓
Check PACKAGE_USAGE_STATS permission
    ↓
Not granted? → Show dialog → Open Settings
    ↓
Granted? → Start collecting data
    ↓
Every 15-30 min: Collect app usage
Every screen change: Log event
End of day: Aggregate to DailySummary
```

---

## ⚠️ Important Notes

### 1. **Build Runner Required**
Setelah phase ini, jalankan:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Ini akan generate `.g.dart` files untuk Isar models.

### 2. **Manual Permission Grant**
`PACKAGE_USAGE_STATS` adalah **special permission** yang tidak bisa di-grant via runtime dialog biasa. User harus:
1. Buka Settings
2. Apps → Luma
3. "Usage Access" atau "App Usage Access"
4. Toggle ON

### 3. **iOS Limitation**
Phase 2 saat ini **Android-only** karena:
- UsageStats API hanya ada di Android
- iOS Screen Time API sangat terbatas (requires MDM or Family Controls entitlement)

Untuk MVP, fokus ke Android dulu.

### 4. **Background Collection**
Untuk periodic collection (setiap 15-30 menit), perlu setup WorkManager di Phase 3 (Background Services).

---

## ✅ Checklist Phase 2

| Task | Status |
|------|--------|
| UsageStatsService implementation | ✅ Done |
| ScreenStateListener Flutter side | ✅ Done |
| ScreenStateListener Android native | ✅ Done |
| EventAggregator logic | ✅ Done |
| RawEvent model update | ✅ Done |
| DailySummary model update | ✅ Done |
| Database CRUD methods | ✅ Done |
| DI registration | ✅ Done |
| Android permissions | ✅ Done |
| Barrel exports | ✅ Done |

---

## 🚀 Next: Phase 3 (Background Services)

Phase 3 akan menambahkan:
1. **WorkManager setup** untuk periodic tasks
2. **Daily summarization job** (setiap jam, saat charging)
3. **Weekly profiling job** (setiap Senin 00:00)
4. **Boot receiver** untuk auto-start setelah reboot
5. **Notification channel** untuk background service status

---

**Phase 2 Complete!** 🎉
Ready untuk lanjut ke Phase 3 atau generate Isar models dengan build_runner.
