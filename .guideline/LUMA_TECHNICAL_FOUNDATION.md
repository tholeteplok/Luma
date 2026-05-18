# Luma — Dokumen Fondasi Teknis

## Personal Digital Behavior Intelligence  
**Kerangka Kerja Engineering untuk Solo Developer**

**Versi**: 1.0  
**Tanggal**: 16 Mei 2026  
**Status**: Siap untuk Fase 0 Development

---

## DAFTAR ISI

1. [Struktur Proyek & Setup](#1-struktur-proyek--setup)
2. [Database Schema & Desain Data](#2-database-schema--desain-data)
3. [Data Pipeline Architecture](#3-data-pipeline-architecture)
4. [Rule Engine & Threshold](#4-rule-engine--threshold)
5. [Insight Generation Engine](#5-insight-generation-engine)
6. [Security & Encryption Layer](#6-security--encryption-layer)
7. [Background Services & Timing](#7-background-services--timing)
8. [UI/UX Components & State Management](#8-uiux-components--state-management)
9. [Testing & Validation Strategy](#9-testing--validation-strategy)
10. [Deployment & Server Setup](#10-deployment--server-setup)
11. [Development Checklist](#11-development-checklist)
12. [Performance & Optimization](#12-performance--optimization)

---

## 1. STRUKTUR PROYEK & SETUP

### 1.1 Struktur Folder

```
luma/
├── android/
│   ├── app/src/main/AndroidManifest.xml
│   └── app/src/main/kotlin/
│       └── com.luma/
│           └── UsageStatsService.kt
│
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── theme.dart
│   │   ├── constants.dart
│   │   └── routes.dart
│   │
│   ├── data/
│   │   ├── db/
│   │   │   ├── isar_service.dart
│   │   │   ├── models/
│   │   │   │   ├── raw_event.dart
│   │   │   │   ├── daily_summary.dart
│   │   │   │   ├── weekly_profile.dart
│   │   │   │   ├── baseline.dart
│   │   │   │   └── insight.dart
│   │   │   └── migrations/
│   │   │       └── migration_log.dart
│   │   │
│   │   ├── tracking/
│   │   │   ├── usage_stats_service.dart
│   │   │   ├── screen_listener_service.dart
│   │   │   └── event_aggregator.dart
│   │   │
│   │   ├── encryption/
│   │   │   ├── encryption_service.dart     ← terima key sebagai param
│   │   │   ├── drive_key_manager.dart      ← ADR-001: C1 Google Drive
│   │   │   └── secure_storage.dart         ← local key cache (Keystore)
│   │   │
│   │   └── sync/
│   │       ├── supabase_service.dart
│   │       └── sync_manager.dart
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── focus_session.dart
│   │   │   ├── activity_pattern.dart
│   │   │   └── burnout_indicator.dart
│   │   │
│   │   ├── repositories/
│   │   │   ├── data_repository.dart
│   │   │   └── insight_repository.dart
│   │   │
│   │   └── usecases/
│   │       ├── analyze_focus_pattern.dart
│   │       ├── detect_burnout.dart
│   │       └── generate_insight.dart
│   │
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── onboarding_page.dart
│   │   │   ├── home_page.dart
│   │   │   ├── timeline_page.dart
│   │   │   └── settings_page.dart
│   │   │
│   │   ├── widgets/
│   │   │   ├── ambient_visualization.dart
│   │   │   ├── insight_card.dart
│   │   │   ├── timeline_widget.dart
│   │   │   ├── waiting_room.dart
│   │   │   └── burnout_indicator_widget.dart
│   │   │
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── data_provider.dart
│   │   │   ├── insight_provider.dart
│   │   │   └── theme_provider.dart
│   │   │
│   │   └── screens/
│   │       └── [individual feature screens]
│   │
│   ├── core/
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   ├── time_formatters.dart
│   │   │   ├── nvc_validator.dart
│   │   │   └── constants.dart
│   │   │
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   ├── notification_service.dart
│   │   │   └── logger_service.dart
│   │   │
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failure_models.dart
│   │   │
│   │   └── di/
│   │       └── service_locator.dart
│   │
│   └── generated/ (auto-generated)
│       └── ...
│
├── test/
│   ├── unit/
│   │   ├── rule_engine_test.dart
│   │   ├── insight_generation_test.dart
│   │   └── encryption_test.dart
│   │
│   ├── widget/
│   │   └── home_page_test.dart
│   │
│   └── integration/
│       └── full_flow_test.dart
│
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
├── .env
└── README.md
```

### 1.2 Pubspec Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  riverpod: ^2.4.0
  flutter_riverpod: ^2.4.0
  
  # Database
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  
  # Encryption & Security (ADR-001: key = random via Google Drive C1)
  cryptography: ^2.5.0          # AES-256-GCM
  crypto: ^3.0.3                # SHA-256 untuk userId hashing
  # argon2: REMOVED — key tidak lagi derived, tapi random (ADR-001)
  flutter_secure_storage: ^9.0.0
  
  # Auth
  google_sign_in: ^6.1.0
  googleapis: ^12.0.0           # Google Drive API (ADR-001)
  googleapis_auth: ^1.4.1       # Auth client untuk googleapis
  http: ^1.1.0                  # HTTP client helper untuk Drive API
  # google_sign_in_web: REMOVED — mobile only for MVP
  
  # API & Sync
  supabase_flutter: ^1.10.0
  dio: ^5.3.0
  
  # Background
  workmanager: ^0.5.1
  
  # Device Info
  device_info_plus: ^9.0.0
  
  # Usage Stats
  usage_stats: ^1.1.5
  
  # Notifications
  flutter_local_notifications: ^14.1.0
  timezone: ^0.9.2
  
  # UI & Animation
  flutter_animate: ^4.2.0
  smooth_page_indicator: ^1.0.1
  
  # Utilities
  get_it: ^7.6.0
  intl: ^0.19.0
  logging: ^1.2.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  isar_generator: ^3.1.0
  build_runner: ^2.4.0
  freezed: ^2.4.1
  json_serializable: ^6.7.0
  mocktail: ^1.0.0
```

### 1.3 Android Permissions & Configuration

**AndroidManifest.xml**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  
  <!-- Usage Stats -->
  <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" />
  
  <!-- Screen Activity -->
  <uses-permission android:name="android.permission.GET_ACCOUNTS" />
  
  <!-- Notifications -->
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
  
  <!-- Background Services -->
  <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
  <uses-permission android:name="android.permission.WAKE_LOCK" />
  
  <!-- Internet -->
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  
  <application>
    <!-- Services -->
    <service
      android:name=".UsageStatsService"
      android:enabled="true"
      android:exported="false" />
      
    <service
      android:name=".ScreenListenerService"
      android:enabled="true"
      android:exported="false" />
      
    <!-- Broadcast Receivers -->
    <receiver
      android:name=".ScreenStateReceiver"
      android:enabled="true"
      android:exported="false">
      <intent-filter>
        <action android:name="android.intent.action.SCREEN_ON" />
        <action android:name="android.intent.action.SCREEN_OFF" />
      </intent-filter>
    </receiver>
  </application>
</manifest>
```

---

## 2. DATABASE SCHEMA & DESAIN DATA

### 2.1 Data Model Architecture

```
Raw Events (Minutely)
        ↓
Daily Aggregation (Hourly via Charging Trigger)
        ↓
Weekly Profiling (Saat 00:00 Minggu Baru)
        ↓
Baseline Computation (Continuous, Exponential Moving Average)
        ↓
Insight Generation (Harian, berdasarkan trigger)
```

### 2.2 Isar Collections

#### **Collection: raw_event**

```dart
@Collection()
class RawEvent {
  late Id? id;
  
  late DateTime timestamp;              // Waktu event terjadi
  late String eventType;                // "screen_on", "screen_off", "app_opened", "app_closed"
  late String? packageName;             // com.instagram, com.code, null untuk screen_off
  late int? duration;                   // Durasi dalam milidetik (untuk app_closed, screen_off)
  late String userId;                   // Dienkripsi di transit, disimpan terenkripsi
  
  late DateTime createdAt;
  late DateTime? syncedAt;              // null = belum tersinkronisasi
  
  // Metadata
  late bool isEncrypted;
  late String encryptionVersion;        // "v1", "v2", dst
  
  // Index untuk query cepat
}

// Query helpers
extension RawEventQueries on IsarCollection<RawEvent> {
  Query<RawEvent> byUserId(String userId) =>
    where().userIdEqualTo(userId).build();
    
  Query<RawEvent> byTimeRange(DateTime start, DateTime end) =>
    where().timestampBetween(start, end).build();
    
  Query<RawEvent> byEventType(String type) =>
    where().eventTypeEqualTo(type).build();
}
```

**Storage**: ~100 MB/minggu (raw events, high resolution)  
**Retention**: Hari ke-1 sampai ke-7 (7 hari penuh)

---

#### **Collection: daily_summary**

```dart
@Collection()
class DailySummary {
  late Id? id;
  
  late String userId;
  late DateTime date;                   // 00:00 pukul hari itu
  
  // Screen Time & Sessions
  late int totalScreenTime;             // Milidetik
  late int totalSessions;               // Berapa kali screen dinyalakan
  late double avgSessionDuration;       // Menit
  late List<int> sessionDurations;      // Durasi setiap sesi (menit)
  
  // Focus Sessions
  late int focusSessions;               // Sesi >45 menit tanpa distraksi
  late int focusMinutes;                // Total menit fokus
  late double focusQuality;             // 0-1: berdasarkan app switch rate
  
  // App Activity
  late Map<String, int> appUsageMap;    // {"com.instagram": 45000, ...}
  late int appSwitchCount;              // Total app switches
  late int appSwitchesPerHour;          // Rate
  late List<int> switchingSpikes;       // Timestamp jam dengan banyak switch
  
  // Sleep & Night Activity
  late int screenOffDuration;           // Durasi screen OFF (estimasi tidur)
  late int nightActivity;               // Screen ON antara 23:00-06:00 (menit)
  late bool hasLateNightSpike;          // >30 menit antara 23:00-03:00
  
  // Distraction Analysis
  late int cascadingSwitches;           // 5+ switches dalam 5 menit
  late List<TimeRange> distrationPeriods; // Periode dengan high switching
  late double distractionScore;         // 0-1
  
  // Meta
  late DateTime createdAt;
  late DateTime? syncedAt;
}

class TimeRange {
  final DateTime start;
  final DateTime end;
  final int switchCount;
  TimeRange(this.start, this.end, this.switchCount);
}
```

**Storage**: ~2 MB/minggu (7 hari summary)  
**Retention**: Hari ke-8 sampai ke-28 (agregat harian)

---

#### **Collection: weekly_profile**

```dart
@Collection()
class WeeklyProfile {
  late Id? id;
  
  late String userId;
  late DateTime weekStart;              // Senin 00:00
  
  // Focus Patterns
  late Map<int, double> focusByHour;    // {8: 0.8, 9: 0.9, ...} (0-1)
  late Map<String, double> focusByDayOfWeek; // {"Monday": 0.75, ...}
  late int bestFocusDay;                // 1-7 (Monday-Sunday)
  late TimeOfDay bestFocusTime;         // Peak focus hour
  
  // Sleep & Recovery
  late Map<String, int> sleepByDay;     // {"Monday": 360, ...} menit
  late double avgSleepMinutes;
  late int nightActivityDays;           // Berapa hari ada late-night spike
  
  // Distraction Patterns
  late Map<int, int> switchesByHour;    // {8: 45, 9: 52, ...}
  late List<String> riskHours;          // ["14:00-15:00", "23:00-24:00"]
  
  // Weekly Trend
  late double overallFocusScore;        // 0-1
  late double overallDistractionScore;  // 0-1
  late String weeklyMood;               // "balanced", "burned", "focused", "scattered"
  
  // Recovery Indicators
  late int zeroActivityDays;            // Hari dengan 0 night activity
  late bool hasConsistentSleep;         // Sleep variance < 30%
  
  late DateTime createdAt;
}

class TimeOfDay {
  final int hour;
  final int minute;
  TimeOfDay(this.hour, this.minute);
}
```

**Storage**: ~500 KB/minggu (1-2 minggu)  
**Retention**: Minggu ke-2 sampai ke-4 (agregat mingguan)

---

#### **Collection: baseline**

```dart
@Collection()
class Baseline {
  late Id? id;
  
  late String userId;
  late DateTime lastUpdated;
  
  // EMA (Exponential Moving Average) Values
  // Used for anomaly detection
  
  late double emaScreenTimeDaily;       // Target: 4-6 jam/hari
  late double emaFocusScore;            // Target: 0.6-0.8
  late double emaDistractionScore;      // Target: 0.2-0.4
  late double emaSleepMinutes;          // Target: 360-480 menit
  late double emaNightActivityMinutes;  // Target: <30 menit
  late double emaAppSwitchesPerHour;    // Target: <5
  
  // Variance tracking (untuk anomali detection)
  late double screenTimeVariance;
  late double focusVariance;
  late double sleepVariance;
  
  // Historical reference
  late DateTime firstDataPoint;         // Hari user pertama kali pakai
  late int daysOfData;                  // Berapa hari data terkumpul
  
  // Personalization
  late Map<String, double> hourlyWeights; // Jam mana yang "normal" buat user ini
  late Map<String, double> dayWeights;    // Hari mana yang "busy"
}
```

**Storage**: ~10 KB  
**Retention**: Selamanya (terus di-update)

---

#### **Collection: insight**

```dart
@Collection()
class Insight {
  late Id? id;
  
  late String userId;
  late DateTime createdAt;
  late DateTime displayDate;            // Kapan insight ditampilkan
  
  late String category;                 // "focus", "sleep", "distraction", "burnout", "recovery"
  late String text;                     // Insight dalam bahasa (sudah di-generate)
  late String? subtext;                 // Optional context
  
  late InsightType type;                // "daily", "weekly", "anomaly", "gentle_nudge"
  late InsightSeverity severity;        // "info", "notice", "warning", "gentle"
  
  // Evidence
  late String evidence;                 // JSON string yang menyebabkan insight (untuk debugging)
  late double confidence;               // 0-1: seberapa yakin sistem dengan insight ini
  
  // User Interaction
  late bool userFeedback;               // true = "Apakah ini benar? Ya"
  late DateTime? viewedAt;              // Kapan user lihat
  
  // For Notification
  late bool notified;
  late DateTime? notifiedAt;
  
  late DateTime? syncedAt;
}

enum InsightType { daily, weekly, anomaly, gentleNudge }
enum InsightSeverity { info, notice, warning, gentle }
```

**Storage**: ~50 KB/minggu (7 insights/minggu × besar insight)  
**Retention**: Selamanya

---

#### **Collection: user_preferences**

```dart
@Collection()
class UserPreferences {
  late Id? id;
  
  late String userId;
  
  // Notification Settings
  late bool enableNotifications;
  late String notificationMode;        // "all", "important_only", "none"
  late TimeRange quietHours;            // 22:00-08:00 default
  
  // Thresholds (User dapat customize)
  late int lateNightThreshold;          // Jam berapa dianggap "late night" (23, 00, 01)
  late int focusSessionMin;             // Berapa menit minimum dianggap focus (45 default)
  late int appSwitchThreshold;          // Berapa switches/jam dianggap excessive (8 default)
  
  // Privacy
  late bool allowCloudSync;
  late bool enableAnonymousAnalytics;   // Untuk product improvement (opsional)
  
  // Display
  late String theme;                    // "dark", "light", "auto"
  late String language;                 // "id", "en"
  
  late DateTime lastUpdated;
}
```

---

### 2.3 Progressive Summarization Timeline

```
Hari 1-7
├── raw_event (high res)
├── daily_summary (calculated at charge trigger)
└── baseline (EMA updated)

Minggu ke-2 sampai ke-4
├── raw_event (DELETED)
├── daily_summary (RETAINED)
├── weekly_profile (NEW)
└── baseline (RETAINED & updated)

Bulan ke-2 sampai ke-6
├── daily_summary (AGGREGATED & deleted original)
├── weekly_profile (RETAINED)
└── baseline (RETAINED & updated)

6+ Bulan
├── Hanya baseline statistics
├── yearly_aggregates (optional)
└── historical_comparison (untuk trend)

Implementation:
```

```dart
class ProgressiveSummarizationService {
  /// Dipanggil setiap kali charging trigger
  Future<void> summarizeLastDay() async {
    // Ambil raw_events dari 24 jam lalu
    // Compute daily_summary
    // Hapus raw_events yang sudah di-summarize
  }
  
  /// Dipanggil saat new week (Monday 00:00)
  Future<void> summarizeLastWeek() async {
    // Ambil daily_summaries dari 7 hari lalu
    // Compute weekly_profile
  }
  
  /// Dipanggil saat new month (1st day 00:00)
  Future<void> summarizeLastMonth() async {
    // Agregat daily_summaries menjadi 1 monthly record
    // Hapus daily_summaries lebih lama dari 28 hari
  }
  
  /// Retention Policy
  final retentionPolicy = {
    'raw_event': Duration(days: 7),        // 100 MB
    'daily_summary': Duration(days: 28),   // 2 MB
    'weekly_profile': Duration(days: 180), // 500 KB
    'baseline': Duration(days: 999999),    // Selamanya
  };
}
```

---

## 3. DATA PIPELINE ARCHITECTURE

### 3.1 Data Acquisition Flow

```
┌─────────────────────┐
│  Device Activity    │
│  (Android OS)       │
└──────────┬──────────┘
           │
    ┌──────┴────────┐
    │               │
    ▼               ▼
Screen Event   UsageStats
Listener       API
    │               │
    └───────┬───────┘
            │
    ┌───────▼────────────┐
    │ Event Aggregator   │
    │ (Every 5 minutes)  │
    └───────┬────────────┘
            │
    ┌───────▼──────────────────┐
    │ Raw Event Storage        │
    │ (Isar: raw_event table)  │
    └───────┬──────────────────┘
            │
    ┌───────┴────────────────────────┐
    │  Is it charging?               │
    │  AND >= 24 hours passed?       │
    └───────┬──────────────────────┬─┘
            │ YES                  │ NO
            │                      │
    ┌───────▼──────────────┐       │
    │ Daily Summarization  │       │
    │ (Aggregate raw data) │       │
    └───────┬──────────────┘       │
            │                       │
    ┌───────▼────────────────────┐ │
    │ Daily Summary Storage      │ │
    │ (Isar: daily_summary)      │ │
    └───────┬────────────────────┘ │
            │                       │
    ┌───────┴───────────────────────┤
    │  Is it Monday 00:00?          │
    │  AND >= 7 days of data?       │
    └───────┬──────────────────────┬┤
            │ YES                  ││NO
            │                      ││
    ┌───────▼────────────────────┐ ││
    │ Weekly Profiling           │ ││
    │ (Aggregate daily summaries)│ ││
    └───────┬────────────────────┘ ││
            │                       ││
    ┌───────▼─────────────────────┐ ││
    │ Weekly Profile Storage      │ ││
    │ (Isar: weekly_profile)      │ ││
    └─────────────────────────────┘ ││
                                     ││
    ┌────────────────────────────────┘│
    │ Update Baseline (EMA)          │
    │ (Every aggregation)            │
    └────────────────────────────────┘
```

### 3.2 Service Implementation

#### **UsageStatsService (Kotlin/Android)**

```kotlin
// android/app/src/main/kotlin/com/luma/UsageStatsService.kt

package com.luma

import android.app.Service
import android.content.Intent
import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents
import android.content.Context
import java.util.Calendar

class UsageStatsService : Service() {
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Dipanggil setiap 5 menit via WorkManager
        collectUsageStats()
        return START_STICKY
    }
    
    private fun collectUsageStats() {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) 
            as UsageStatsManager
        
        val calendar = Calendar.getInstance()
        val endTime = calendar.timeInMillis
        calendar.add(Calendar.MINUTE, -5)
        val beginTime = calendar.timeInMillis
        
        // Get events dalam 5 menit terakhir
        val events = usageStatsManager.queryEvents(beginTime, endTime)
        val usageEvent = UsageEvents.Event()
        
        val eventList = mutableListOf<Map<String, Any>>()
        
        while (events.hasNextEvent()) {
            events.getNextEvent(usageEvent)
            
            // Hanya catat app opened/closed events
            if (usageEvent.eventType == UsageEvents.Event.ACTIVITY_RESUMED ||
                usageEvent.eventType == UsageEvents.Event.ACTIVITY_PAUSED) {
                
                eventList.add(mapOf(
                    "timestamp" to usageEvent.timeStamp,
                    "packageName" to usageEvent.packageName,
                    "eventType" to when (usageEvent.eventType) {
                        UsageEvents.Event.ACTIVITY_RESUMED -> "app_opened"
                        UsageEvents.Event.ACTIVITY_PAUSED -> "app_closed"
                        else -> "unknown"
                    },
                    "duration" to 0 // Duration computed later
                ))
            }
        }
        
        // Kirim ke Flutter via platform channel
        sendToFlutter(eventList)
    }
    
    private fun sendToFlutter(events: List<Map<String, Any>>) {
        // TODO: Implement platform channel communication
    }
}
```

#### **ScreenListenerService (Flutter)**

```dart
// lib/data/tracking/screen_listener_service.dart

import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';

class ScreenListenerService {
  static const platform = MethodChannel('com.luma/screen_events');
  
  final IsarService isarService;
  final EventAggregator eventAggregator;
  
  ScreenListenerService(this.isarService, this.eventAggregator);
  
  Future<void> initialize() async {
    // Setup broadcast receiver untuk screen events
    platform.setMethodCallHandler(_handleScreenEvent);
  }
  
  Future<void> _handleScreenEvent(MethodCall call) async {
    if (call.method == 'screenEvent') {
      final Map<dynamic, dynamic> args = call.arguments;
      final screenEvent = {
        'timestamp': DateTime.fromMillisecondsSinceEpoch(args['timestamp']),
        'eventType': args['isOn'] ? 'screen_on' : 'screen_off',
        'packageName': null,
      };
      
      await eventAggregator.addEvent(screenEvent);
    } else if (call.method == 'appEvent') {
      final Map<dynamic, dynamic> args = call.arguments;
      final appEvent = {
        'timestamp': DateTime.fromMillisecondsSinceEpoch(args['timestamp']),
        'eventType': args['eventType'], // 'app_opened' atau 'app_closed'
        'packageName': args['packageName'],
      };
      
      await eventAggregator.addEvent(appEvent);
    }
  }
}
```

#### **EventAggregator**

```dart
// lib/data/tracking/event_aggregator.dart

class EventAggregator {
  final IsarService isarService;
  Timer? _aggregationTimer;
  final List<Map<String, dynamic>> _eventBuffer = [];
  
  EventAggregator(this.isarService);
  
  void startAggregation() {
    // Aggregate setiap 5 menit
    _aggregationTimer = Timer.periodic(Duration(minutes: 5), (_) async {
      await aggregate();
    });
  }
  
  Future<void> addEvent(Map<String, dynamic> event) async {
    // Encrypt event sebelum menyimpan
    final encryptedEvent = await _encryptEvent(event);
    _eventBuffer.add(encryptedEvent);
    
    // Jika buffer penuh, langsung save
    if (_eventBuffer.length > 100) {
      await aggregate();
    }
  }
  
  Future<void> aggregate() async {
    if (_eventBuffer.isEmpty) return;
    
    final isar = await isarService.openDb();
    
    // Compute duration untuk setiap event
    final processedEvents = _processEventSequence(_eventBuffer);
    
    // Simpan ke raw_event
    await isar.writeTxn(() async {
      await isar.rawEvents.putAll(processedEvents);
    });
    
    _eventBuffer.clear();
    
    // Check if should trigger daily summarization
    await _checkForDailySummarization();
  }
  
  List<RawEvent> _processEventSequence(List<Map<String, dynamic>> events) {
    // Compute duration berdasarkan interval antar event
    final processed = <RawEvent>[];
    
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      final nextEvent = i + 1 < events.length ? events[i + 1] : null;
      
      final duration = nextEvent != null
          ? (nextEvent['timestamp'] as DateTime).difference(
              event['timestamp'] as DateTime).inMilliseconds
          : null;
      
      processed.add(RawEvent()
        ..timestamp = event['timestamp']
        ..eventType = event['eventType']
        ..packageName = event['packageName']
        ..duration = duration
        ..userId = 'current_user' // TODO: get from auth
        ..isEncrypted = true
        ..encryptionVersion = 'v1'
        ..createdAt = DateTime.now()
      );
    }
    
    return processed;
  }
  
  Future<void> _checkForDailySummarization() async {
    // Check jika sudah 24 jam sejak daily_summary terakhir
    // dan device sedang charging
    // Jika ya, trigger daily summarization
  }
}
```

---

## 4. RULE ENGINE & THRESHOLD

### 4.1 Rule Engine Architecture

```dart
// lib/domain/services/rule_engine.dart

abstract class Rule {
  String get ruleId;
  String get description;
  Future<bool> evaluate(RuleContext context);
  RuleResult? getResult();
}

class RuleContext {
  final DailySummary dailySummary;
  final WeeklyProfile? weeklyProfile;
  final Baseline baseline;
  
  RuleContext({
    required this.dailySummary,
    required this.weeklyProfile,
    required this.baseline,
  });
}

class RuleResult {
  final String ruleId;
  final bool triggered;
  final String insight;
  final InsightSeverity severity;
  final Map<String, dynamic> evidence;
  
  RuleResult({
    required this.ruleId,
    required this.triggered,
    required this.insight,
    required this.severity,
    required this.evidence,
  });
}

class RuleEngine {
  final List<Rule> rules = [];
  
  void registerRules() {
    rules.add(FocusSessionRule());
    rules.add(LateNightActivityRule());
    rules.add(ExcessiveSwitchingRule());
    rules.add(SleepDeprivationRule());
    rules.add(CascadingDistractionRule());
    rules.add(BurnoutAccumulationRule());
    rules.add(RecoveryPatternRule());
  }
  
  Future<List<RuleResult>> evaluate(RuleContext context) async {
    final results = <RuleResult>[];
    
    for (final rule in rules) {
      if (await rule.evaluate(context)) {
        final result = rule.getResult();
        if (result != null) {
          results.add(result);
        }
      }
    }
    
    return results;
  }
}
```

### 4.2 Core Rules Implementation

#### **Rule 1: Focus Session Detection**

```dart
// lib/domain/rules/focus_session_rule.dart

class FocusSessionRule extends Rule {
  @override
  String get ruleId => 'focus_session';
  
  @override
  String get description => 'Deteksi sesi fokus >45 menit';
  
  @override
  Future<bool> evaluate(RuleContext context) async {
    final summary = context.dailySummary;
    
    // Trigger: Ada minimal 1 sesi fokus hari ini
    return summary.focusSessions > 0;
  }
  
  @override
  RuleResult? getResult() {
    // Logic untuk generate insight
    // Contoh:
    // "Pagi ini fokusmu stabil. Seperti Selasa lalu."
    // atau
    // "Sesi fokus terlama hari ini: 2 jam 15 menit (10:30-12:45)"
    
    return RuleResult(
      ruleId: ruleId,
      triggered: true,
      insight: generateFocusInsight(),
      severity: InsightSeverity.info,
      evidence: {
        'focusSessions': 3,
        'totalFocusMinutes': 135,
        'bestSessionDuration': 85,
      },
    );
  }
  
  String generateFocusInsight() {
    // Implementasi di section Insight Generation
    return '';
  }
}
```

#### **Rule 2: Late-Night Activity**

```dart
// lib/domain/rules/late_night_activity_rule.dart

class LateNightActivityRule extends Rule {
  // Threshold dari riset: 30 menit antara 23:00-03:00
  static const LATE_NIGHT_THRESHOLD_MINUTES = 30;
  static const LATE_NIGHT_START_HOUR = 23;
  static const LATE_NIGHT_END_HOUR = 3;
  
  @override
  String get ruleId => 'late_night_activity';
  
  @override
  Future<bool> evaluate(RuleContext context) async {
    final summary = context.dailySummary;
    
    // Trigger: Screen time antara 23:00-03:00 > 30 menit
    return summary.hasLateNightSpike || 
           summary.nightActivity > LATE_NIGHT_THRESHOLD_MINUTES;
  }
  
  @override
  RuleResult? getResult() {
    // Logic:
    // - Jika ini pertama kalinya deteksi anomali → gentle nudge
    // - Jika sudah konsisten 3 hari → warning
    // - Jika sudah seminggu → incorporate ke burnout score
    
    return RuleResult(
      ruleId: ruleId,
      triggered: true,
      insight: 'Malam terakhir lebih panjang dari biasanya.',
      severity: InsightSeverity.notice,
      evidence: {
        'nightActivityMinutes': 45,
        'threshold': LATE_NIGHT_THRESHOLD_MINUTES,
        'consecutive_days': 0, // First time
      },
    );
  }
}
```

#### **Rule 3: Excessive App Switching**

```dart
// lib/domain/rules/excessive_switching_rule.dart

class ExcessiveSwitchingRule extends Rule {
  // Baseline dari riset: 8 switches/jam adalah excessive
  static const SWITCHING_THRESHOLD_PER_HOUR = 8;
  
  // Cascading pattern: 5+ switches dalam 5 menit
  static const CASCADING_THRESHOLD = 5;
  static const CASCADING_WINDOW_MINUTES = 5;
  
  @override
  String get ruleId => 'excessive_switching';
  
  @override
  Future<bool> evaluate(RuleContext context) async {
    final summary = context.dailySummary;
    final baseline = context.baseline;
    
    // Trigger 1: Overall rate tinggi
    if (summary.appSwitchesPerHour > SWITCHING_THRESHOLD_PER_HOUR) {
      return true;
    }
    
    // Trigger 2: Cascading pattern terdeteksi
    if (summary.cascadingSwitches > 0) {
      return true;
    }
    
    // Trigger 3: Significant deviation dari baseline
    if (baseline.emaAppSwitchesPerHour > 0) {
      final deviation = 
        (summary.appSwitchesPerHour - baseline.emaAppSwitchesPerHour) /
        baseline.emaAppSwitchesPerHour;
      
      if (deviation > 0.4) { // 40% increase
        return true;
      }
    }
    
    return false;
  }
  
  @override
  RuleResult? getResult() {
    return RuleResult(
      ruleId: ruleId,
      triggered: true,
      insight: 'Jam 2 siang. Kamu berpindah antar 6 aplikasi dalam 20 menit.',
      severity: InsightSeverity.warning,
      evidence: {
        'appSwitchesPerHour': 12,
        'threshold': SWITCHING_THRESHOLD_PER_HOUR,
        'cascadingSwitches': 2,
      },
    );
  }
}
```

#### **Rule 4: Sleep Deprivation**

```dart
// lib/domain/rules/sleep_deprivation_rule.dart

class SleepDeprivationRule extends Rule {
  static const SLEEP_THRESHOLD_MINUTES = 360; // 6 jam
  
  @override
  String get ruleId => 'sleep_deprivation';
  
  @override
  Future<bool> evaluate(RuleContext context) async {
    final summary = context.dailySummary;
    
    // Trigger: Tidur < 6 jam
    return summary.screenOffDuration < SLEEP_THRESHOLD_MINUTES;
  }
  
  @override
  RuleResult? getResult() {
    return RuleResult(
      ruleId: ruleId,
      triggered: true,
      insight: 'Tidur semalam hanya 4 jam 20 menit. Kurang dari baseline-mu.',
      severity: InsightSeverity.warning,
      evidence: {
        'sleepMinutes': 260,
        'threshold': SLEEP_THRESHOLD_MINUTES,
      },
    );
  }
}
```

#### **Rule 5: Burnout Accumulation**

```dart
// lib/domain/rules/burnout_accumulation_rule.dart

class BurnoutAccumulationRule extends Rule {
  @override
  String get ruleId => 'burnout_accumulation';
  
  @override
  Future<bool> evaluate(RuleContext context) async {
    final score = computeBurnoutScore(context);
    
    // Trigger jika score meningkat signifikan dalam 3 hari
    return score > 60;
  }
  
  double computeBurnoutScore(RuleContext context) {
    double score = 0;
    
    // Sleep Disruption (30 poin)
    if (context.dailySummary.screenOffDuration < 360) {
      score += 15;
    }
    if (context.dailySummary.nightActivity > 30) {
      score += 15;
    }
    
    // Focus Instability (30 poin)
    if (context.baseline.focusVariance > 0.5) {
      score += 20;
    }
    if (context.dailySummary.distractionScore > 0.6) {
      score += 10;
    }
    
    // Switching Frequency (20 poin)
    if (context.dailySummary.appSwitchesPerHour > 8) {
      score += 10;
    }
    if (context.dailySummary.cascadingSwitches > 5) {
      score += 10;
    }
    
    // Recovery Signal (negatif)
    if (context.dailySummary.focusQuality > 0.7) {
      score -= 5;
    }
    
    return score.clamp(0, 100);
  }
  
  @override
  RuleResult? getResult() {
    return RuleResult(
      ruleId: ruleId,
      triggered: true,
      insight: 'Tiga hari terakhir, sesi fokusmu lebih pendek dan sering terganggu. '
               'Pola ini muncul saat beban kerja tinggi. Tidak apa-apa untuk beristirahat.',
      severity: InsightSeverity.gentle,
      evidence: {
        'burnoutScore': 68,
        'components': {
          'sleepDisruption': 30,
          'focusInstability': 28,
          'switchingFrequency': 15,
          'recoverySignal': -5,
        },
      },
    );
  }
}
```

### 4.3 Baseline Computation (EMA)

```dart
// lib/domain/services/baseline_service.dart

class BaselineService {
  /// Exponential Moving Average untuk anomaly detection
  /// EMA memberikan weight lebih besar ke data terbaru
  /// Formula: EMA_t = (Data_t * alpha) + (EMA_(t-1) * (1 - alpha))
  /// alpha = 0.3 untuk medium smoothing
  
  static const ALPHA = 0.3;
  
  Future<void> updateBaseline(
    RuleContext context,
    DailySummary newDaily,
  ) async {
    final baseline = context.baseline;
    
    // Update EMA Screen Time
    baseline.emaScreenTimeDaily = 
      (newDaily.totalScreenTime / 60 / 1000 * ALPHA) +
      (baseline.emaScreenTimeDaily * (1 - ALPHA));
    
    // Update EMA Focus Score
    baseline.emaFocusScore =
      (newDaily.focusQuality * ALPHA) +
      (baseline.emaFocusScore * (1 - ALPHA));
    
    // Update EMA Distraction Score
    baseline.emaDistractionScore =
      (newDaily.distractionScore * ALPHA) +
      (baseline.emaDistractionScore * (1 - ALPHA));
    
    // Update EMA Sleep Minutes
    baseline.emaSleepMinutes =
      (newDaily.screenOffDuration / 60 * ALPHA) +
      (baseline.emaSleepMinutes * (1 - ALPHA));
    
    // Update EMA Night Activity
    baseline.emaNightActivityMinutes =
      (newDaily.nightActivity * ALPHA) +
      (baseline.emaNightActivityMinutes * (1 - ALPHA));
    
    // Update EMA App Switches Per Hour
    baseline.emaAppSwitchesPerHour =
      (newDaily.appSwitchesPerHour * ALPHA) +
      (baseline.emaAppSwitchesPerHour * (1 - ALPHA));
    
    // Update variance for anomaly detection
    baseline.screenTimeVariance = computeVariance(
      baseline.screenTimeVariance,
      newDaily.totalScreenTime / 60 / 1000,
      baseline.emaScreenTimeDaily,
    );
    
    baseline.lastUpdated = DateTime.now();
  }
  
  double computeVariance(double currentVar, double newValue, double mean) {
    // Incremental variance computation
    // Untuk efficiency, gunakan exponential weighted variance
    return (newValue - mean).abs() * ALPHA + currentVar * (1 - ALPHA);
  }
  
  /// Deteksi anomali dengan Z-score
  bool isAnomaly(double value, double mean, double variance) {
    if (variance == 0) return false;
    
    final zScore = (value - mean).abs() / variance;
    return zScore > 2; // 2 standard deviations
  }
}
```

---

## 5. INSIGHT GENERATION ENGINE

### 5.1 NVC-Aligned Insight Generator

```dart
// lib/domain/services/insight_generator.dart

class InsightGenerator {
  /// Mengikuti format NVC:
  /// [Observasi konkret] + [Konteks waktu] + [Tanpa evaluasi]
  
  final InsightTemplateRepository templateRepository;
  
  Future<Insight> generateInsight(
    RuleResult ruleResult,
    RuleContext context,
  ) async {
    String text = '';
    String? subtext;
    
    // Route ke insight type yang spesifik
    switch (ruleResult.ruleId) {
      case 'focus_session':
        text = await generateFocusInsight(context);
        break;
        
      case 'late_night_activity':
        text = await generateLateNightInsight(context);
        break;
        
      case 'excessive_switching':
        text = await generateSwitchingInsight(context);
        break;
        
      case 'sleep_deprivation':
        text = await generateSleepInsight(context);
        break;
        
      case 'burnout_accumulation':
        text = await generateBurnoutInsight(context);
        subtext = 'Tidak ada yang salah denganmu. Hanya beban yang tinggi.';
        break;
    }
    
    // Validate insight dengan NVC checker
    if (!_isValidNVC(text)) {
      text = _rewriteAsNVC(text);
    }
    
    return Insight()
      ..userId = 'current_user'
      ..createdAt = DateTime.now()
      ..displayDate = DateTime.now()
      ..category = ruleResult.ruleId
      ..text = text
      ..subtext = subtext
      ..type = InsightType.daily
      ..severity = ruleResult.severity
      ..evidence = jsonEncode(ruleResult.evidence)
      ..confidence = 0.85;
  }
  
  Future<String> generateFocusInsight(RuleContext context) async {
    final summary = context.dailySummary;
    final weekly = context.weeklyProfile;
    
    // Template selection based on context
    if (weekly != null && summary.focusQuality > 0.75) {
      final bestDay = _getDayName(weekly.bestFocusDay);
      return 'Pagi ini fokusmu tenang. Seperti $bestDay lalu.';
    }
    
    if (summary.focusSessions > 2) {
      return 'Hari ini kamu punya tiga sesi fokus. Itu konsisten dengan '
             'pola akhir pekan.';
    }
    
    return 'Sesi fokus terlama hari ini: ${summary.sessionDurations.reduce((a, b) => a > b ? a : b)} menit.';
  }
  
  Future<String> generateLateNightInsight(RuleContext context) async {
    final summary = context.dailySummary;
    
    if (summary.nightActivity > 120) {
      return 'Malam tadi lebih panjang dari biasanya. Screen tetap menyala '
             'selama ${summary.nightActivity ~/ 60} jam.';
    }
    
    return 'Pola aktivitasmu mulai mirip minggu saat fokus turun.';
  }
  
  Future<String> generateSwitchingInsight(RuleContext context) async {
    final summary = context.dailySummary;
    
    if (summary.cascadingSwitches > 0) {
      // Cari jam dengan banyak switching
      final hour = summary.distrationPeriods.isNotEmpty 
        ? summary.distrationPeriods.first.start.hour
        : 14;
      
      return 'Jam ${hour}:00. Kamu berpindah antar ${summary.cascadingSwitches} '
             'aplikasi dalam ${summary.distrationPeriods.isNotEmpty ? 
             summary.distrationPeriods.first.end.difference(
             summary.distrationPeriods.first.start).inMinutes : 20} menit.';
    }
    
    return 'Switching app hari ini lebih dari biasanya.';
  }
  
  Future<String> generateSleepInsight(RuleContext context) async {
    final summary = context.dailySummary;
    final sleepHours = summary.screenOffDuration ~/ 60;
    
    return 'Tidur semalam hanya $sleepHours jam. '
           'Kurang dari baseline-mu yang biasanya 7 jam.';
  }
  
  Future<String> generateBurnoutInsight(RuleContext context) async {
    return 'Tiga hari terakhir, sesi fokusmu lebih pendek dan sering terganggu. '
           'Pola ini muncul saat beban kerja tinggi. Tidak apa-apa untuk beristirahat.';
  }
  
  bool _isValidNVC(String text) {
    // Check if text contains:
    // ✓ Observation (concrete fact)
    // ✓ Context (when/where)
    // ✗ Judgment (should, must, bad, good)
    // ✗ Universalization (always, never)
    
    final judgmentWords = [
      'should', 'must', 'shouldn\'t', 'bad', 'good',
      'lazy', 'productive', 'unhealthy', 'addicted',
      'selalu', 'tidak pernah', 'harus', 'jangan',
    ];
    
    return !judgmentWords.any((word) => text.toLowerCase().contains(word));
  }
  
  String _rewriteAsNVC(String original) {
    // Rewrite original text to remove judgment
    // Contoh:
    // "Kamu harus tidur lebih" → "Tidur semalam 4 jam"
    // "Kamu terlalu banyak scrolling" → "Scrolling 2 jam hari ini"
    
    return original; // TODO: Implement rewriting logic
  }
  
  String _getDayName(int dayOfWeek) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[(dayOfWeek - 1) % 7];
  }
}
```

### 5.2 Insight Template Repository

```dart
// lib/domain/repositories/insight_template_repository.dart

class InsightTemplateRepository {
  /// Bank template untuk insight yang bervariasi
  /// Tujuan: Agar insight tidak terasa repetitif
  
  final Map<String, List<String>> templates = {
    'focus_morning': [
      'Pagi ini fokusmu tenang. Seperti {day} lalu.',
      'Bangun pagi dengan fokus stabil. {comparison}',
      'Sesi pagi hari ini {duration} menit. Lebih lama dari rata-rata.',
    ],
    'focus_evening': [
      'Sore tadi cukup produktif. Tiga sesi fokus.',
      'Energi tetap ada sampai malam. Itu jarang.',
      'Sesi fokus terakhir mencapai {duration} menit.',
    ],
    'distraction_pattern': [
      'Jam {hour}:00. Kamu berpindah antar aplikasi {count} kali dalam 20 menit.',
      'Distraksi meningkat setelah {hour}:00. Pola biasanya.',
      '{count} app switch dalam periode 20 menit tadi. Cascading pattern terdeteksi.',
    ],
    'late_night': [
      'Malam tadi lebih panjang dari biasanya.',
      'Screen tetap menyala sampai {time}. Itu {duration} jam lebih lama.',
      'Aktivitas malam meningkat {percent}% minggu ini.',
    ],
    'sleep_recovery': [
      'Tidur semalam {hours} jam. Istirahat yang baik.',
      'Konsistensi tidur sebelum jam 11. Itu membantu fokusmu.',
      'Pola tidur lebih stabil minggu ini.',
    ],
    'burnout_gentle': [
      'Tiga hari terakhir, sesi fokusmu lebih pendek. Wajar saat beban tinggi.',
      'Pola ini mirip minggu-minggu padat kerja. Istirahat membantu recover.',
      'Bukan kegagalan. Hanya ritme yang berubah.',
    ],
  };
  
  String getTemplate(String category) {
    final categoryTemplates = templates[category];
    if (categoryTemplates == null || categoryTemplates.isEmpty) {
      return 'Pola aktivitasmu berubah hari ini.';
    }
    
    return categoryTemplates[Random().nextInt(categoryTemplates.length)];
  }
  
  String fillTemplate(String template, Map<String, dynamic> variables) {
    String result = template;
    
    variables.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    
    return result;
  }
}
```

### 5.3 Weekly Reflection Generator

```dart
// lib/domain/services/weekly_reflection_generator.dart

class WeeklyReflectionGenerator {
  
  Future<Insight> generateWeeklyReflection(
    String userId,
    WeeklyProfile weeklyProfile,
  ) async {
    final parts = <String>[];
    
    // Part 1: Sleep Pattern
    parts.add(generateSleepPart(weeklyProfile));
    
    // Part 2: Focus Pattern
    parts.add(generateFocusPart(weeklyProfile));
    
    // Part 3: Distraction Pattern
    parts.add(generateDistractionPart(weeklyProfile));
    
    // Part 4: Overall Mood
    parts.add(generateMoodPart(weeklyProfile));
    
    final text = parts.join('\n');
    
    return Insight()
      ..userId = userId
      ..createdAt = DateTime.now()
      ..displayDate = DateTime.now()
      ..category = 'weekly_reflection'
      ..text = text
      ..type = InsightType.weekly
      ..severity = InsightSeverity.info
      ..confidence = 0.9;
  }
  
  String generateSleepPart(WeeklyProfile profile) {
    final avgSleep = profile.avgSleepMinutes;
    final nightActivityDays = profile.nightActivityDays;
    
    if (nightActivityDays == 0) {
      return 'Minggu ini tidurmu konsisten. Tidak ada aktivitas malam yang mengganggu.';
    }
    
    if (nightActivityDays >= 4) {
      return 'Aktivitas malam terdeteksi $nightActivityDays dari 7 hari. '
             'Pola ini berpengaruh pada fokus pagi.';
    }
    
    return 'Tidur rata-rata ${(avgSleep / 60).toStringAsFixed(1)} jam per malam.';
  }
  
  String generateFocusPart(WeeklyProfile profile) {
    final bestDay = profile.bestFocusDay;
    final bestTime = profile.bestFocusTime;
    final dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    
    return 'Fokusmu paling stabil di ${ dayNames[bestDay - 1]} '
           'terutama antara ${bestTime.hour}:00–${(bestTime.hour + 2)}:00.';
  }
  
  String generateDistractionPart(WeeklyProfile profile) {
    final riskHours = profile.riskHours;
    
    if (riskHours.isEmpty) {
      return 'Distraksi cukup merata sepanjang hari.';
    }
    
    return 'Distraksi paling tinggi di jam-jam: ${riskHours.join(', ')}.';
  }
  
  String generateMoodPart(WeeklyProfile profile) {
    switch (profile.weeklyMood) {
      case 'balanced':
        return 'Minggu yang seimbang. Fokus dan istirahat berjalan baik.';
      case 'burned':
        return 'Minggu yang padat. Istirahat akan membantu minggu depan.';
      case 'focused':
        return 'Minggu yang produktif. Fokus terjaga dengan baik.';
      case 'scattered':
        return 'Minggu yang tersebar. Fokus butuh consolidation.';
      default:
        return 'Minggu yang unik dengan polanya sendiri.';
    }
  }
}
```

---

## 6. SECURITY & ENCRYPTION LAYER

> **ADR-001 ACTIVE** — Arsitektur ini menggunakan Google Drive Key Wrapping (C1).
> Baca `ADR-001-CROSS-DEVICE-SYNC.md` sebelum mengubah section ini.
> Key adalah **random 32 bytes**, bukan derived dari googleUserId.

### 6.1 Drive Key Manager

```dart
// lib/data/encryption/drive_key_manager.dart
//
// PERAN: Satu-satunya tempat encryption key dibuat dan diambil.
// KEY SOURCE: Google Drive (appDataFolder) — bukan APP_SECRET, bukan server.
// CACHE: Android Keystore via flutter_secure_storage.

class DriveKeyManager {
  static const _driveFileName = 'key.json';
  static const _driveFolder   = 'appDataFolder';
  static const _cacheAlias    = 'luma_cached_key_v1';

  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage;

  DriveKeyManager(this._googleSignIn, this._secureStorage);

  /// Entry point utama. Dipanggil tepat setelah Google Sign-In.
  /// User tidak melihat langkah ini — berjalan di background.
  /// Return: 32-byte encryption key, siap dipakai EncryptionService.
  Future<Uint8List> getOrCreateKey() async {
    // 1. Cek local cache dulu (Android Keystore)
    //    → Tidak perlu hit Drive setiap kali app dibuka
    final cached = await _getCachedKey();
    if (cached != null) return cached;

    // 2. Fetch dari Google Drive
    final existing = await _fetchKeyFromDrive();
    if (existing != null) {
      await _cacheKey(existing); // Cache untuk launch berikutnya
      return existing;
    }

    // 3. Belum ada di Drive → generate baru (setup pertama)
    final newKey = _generateSecureKey();
    await _saveKeyToDrive(newKey);
    await _cacheKey(newKey);
    return newKey;
  }

  /// Hapus cache lokal saat sign out.
  /// Key di Drive tetap ada — tersedia saat sign in berikutnya.
  Future<void> clearLocalCache() async {
    await _secureStorage.delete(key: _cacheAlias);
  }

  // ─── PRIVATE ────────────────────────────────────────────────

  Uint8List _generateSecureKey() {
    final rng = Random.secure();
    return Uint8List.fromList(List.generate(32, (_) => rng.nextInt(256)));
  }

  Future<Uint8List?> _getCachedKey() async {
    final encoded = await _secureStorage.read(key: _cacheAlias);
    if (encoded == null) return null;
    return base64Decode(encoded);
  }

  Future<void> _cacheKey(Uint8List key) async {
    await _secureStorage.write(
      key: _cacheAlias,
      value: base64Encode(key),
    );
  }

  Future<Uint8List?> _fetchKeyFromDrive() async {
    try {
      final headers = await _getAuthHeaders();
      final driveApi = drive.DriveApi(_AuthClient(headers));

      final list = await driveApi.files.list(
        spaces: _driveFolder,
        q: "name = '$_driveFileName'",
        fields: 'files(id)',
      );

      if (list.files == null || list.files!.isEmpty) return null;

      final fileId = list.files!.first.id!;
      final media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = await media.stream.expand((b) => b).toList();
      final json  = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;

      return base64Decode(json['key'] as String);

    } on drive.DetailedApiRequestError catch (e) {
      if (e.status == 404) return null;
      rethrow;
    }
  }

  Future<void> _saveKeyToDrive(Uint8List key) async {
    final headers  = await _getAuthHeaders();
    final driveApi = drive.DriveApi(_AuthClient(headers));

    final payload = jsonEncode({
      'version'   : '1',
      'key'       : base64Encode(key),
      'created_at': DateTime.now().toIso8601String(),
    });

    final bytes  = utf8.encode(payload);
    final stream = Stream.value(bytes);

    await driveApi.files.create(
      drive.File()
        ..name    = _driveFileName
        ..parents = [_driveFolder],
      uploadMedia: drive.Media(stream, bytes.length),
    );
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final account = _googleSignIn.currentUser;
    if (account == null) throw const AuthNotSignedInException();
    return account.authHeaders;
  }
}

// HTTP client wrapper untuk googleapis
class _AuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _inner = http.Client();
  _AuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest req) {
    req.headers.addAll(_headers);
    return _inner.send(req);
  }
}
```

### 6.2 Encryption Service

```dart
// lib/data/encryption/encryption_service.dart
//
// PERUBAHAN dari versi lama:
// - Key tidak lagi derived dari googleUserId + APP_SECRET
// - Key di-inject dari DriveKeyManager (random 32 bytes)
// - Tidak ada initialize(googleUserId) — konstruktor langsung terima key

class EncryptionService {
  final Uint8List _key;

  EncryptionService(this._key) {
    assert(_key.length == 32, 'Key must be exactly 32 bytes for AES-256-GCM');
  }

  Future<EncryptedData> encrypt(String plaintext) async {
    final cipher    = AesGcm.with256bits();
    final secretKey = await cipher.newSecretKeyFromBytes(_key);
    final iv        = _generateIV(); // 96-bit random IV

    final box = await cipher.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: iv,
    );

    return EncryptedData(
      ciphertext: base64Encode(box.cipherText),
      iv        : base64Encode(iv),
      mac       : base64Encode(box.mac.bytes),
      version   : 'v1',
    );
  }

  Future<String> decrypt(EncryptedData data) async {
    final cipher    = AesGcm.with256bits();
    final secretKey = await cipher.newSecretKeyFromBytes(_key);

    final box = SecretBox(
      base64Decode(data.ciphertext),
      nonce: base64Decode(data.iv),
      mac  : Mac(base64Decode(data.mac)),
    );

    final plaintext = await cipher.decrypt(box, secretKey: secretKey);
    return utf8.decode(plaintext);
  }

  Future<List<EncryptedData>> encryptBatch(List<String> items) async {
    return Future.wait(items.map(encrypt));
  }

  Uint8List _generateIV() {
    final rng = Random.secure();
    return Uint8List.fromList(List.generate(12, (_) => rng.nextInt(256)));
  }
}

class EncryptedData {
  final String ciphertext;
  final String iv;
  final String mac;     // GCM authentication tag
  final String version;

  const EncryptedData({
    required this.ciphertext,
    required this.iv,
    required this.mac,
    required this.version,
  });

  Map<String, dynamic> toJson() => {
    'ciphertext': ciphertext,
    'iv'        : iv,
    'mac'       : mac,
    'version'   : version,
  };

  factory EncryptedData.fromJson(Map<String, dynamic> j) => EncryptedData(
    ciphertext: j['ciphertext'] as String,
    iv        : j['iv']         as String,
    mac       : j['mac']        as String,
    version   : j['version']    as String,
  );
}
```

### 6.3 Auth Service (Updated Flow)

```dart
// lib/core/services/auth_service.dart

class AuthService {
  final GoogleSignIn     _googleSignIn;
  final DriveKeyManager  _driveKeyManager;

  AuthService(this._googleSignIn, this._driveKeyManager);

  /// Dipanggil saat user tap "Lanjutkan dengan Google".
  /// Return: AuthResult dengan EncryptionService siap pakai.
  Future<AuthResult> signIn() async {
    // Step 1: Google Sign-In (user melihat Google sheet)
    final account = await _googleSignIn.signIn();
    if (account == null) throw const AuthCancelledException();

    // Step 2: Ambil atau buat key dari Drive (background, ~1 detik)
    final key = await _driveKeyManager.getOrCreateKey();

    // Step 3: Inisialisasi EncryptionService
    final encryptionService = EncryptionService(key);

    return AuthResult(
      userId           : account.id,
      email            : account.email,
      encryptionService: encryptionService,
    );
  }

  Future<void> signOut() async {
    await _driveKeyManager.clearLocalCache(); // Hapus key dari Keystore
    await _googleSignIn.signOut();            // Cabut akses Google
  }
}

// Google Sign-In scope — HARUS include drive.appdata
final googleSignIn = GoogleSignIn(
  scopes: [
    'openid',
    'email',
    'profile',
    // ADR-001: diperlukan untuk Google Drive Key Wrapping
    'https://www.googleapis.com/auth/drive.appdata',
  ],
);
```

### 6.4 Zero-Knowledge Architecture (ADR-001 C1)

```
SETUP (device pertama):

[User]──tap "Lanjutkan dengan Google"
         │
         ▼
[Google Sign-In]
  scope: openid + email + drive.appdata
         │
         ▼
[DriveKeyManager.getOrCreateKey()]
  ├─ Cache miss → fetch Drive → tidak ada
  ├─ Generate random 32 bytes
  ├─ Save ke Google Drive (appDataFolder/key.json)
  └─ Cache ke Android Keystore
         │
         ▼
[EncryptionService(key)]
  ├─ Encrypt raw_events → Supabase
  └─ Encrypt daily_summaries → Supabase

SERVER LUMA (Supabase):
  ├─ Terima: sha256(userId) + ciphertext
  ├─ Simpan AS-IS
  └─ Tidak pernah melihat key ← ZK TERJAGA

GOOGLE DRIVE (milik user):
  ├─ Simpan: key.json (file tersembunyi)
  ├─ Tidak terlihat di Drive UI biasa
  └─ Hanya bisa diakses via app Luma

─────────────────────────────────────────

RESTORE (device baru):

[User]──tap "Lanjutkan dengan Google"
         │
         ▼
[Google Sign-In — akun yang sama]
         │
         ▼
[DriveKeyManager.getOrCreateKey()]
  ├─ Cache miss (device baru)
  ├─ Fetch Drive → key.json DITEMUKAN
  └─ Cache ke Keystore device baru
         │
         ▼
[EncryptionService(key)] — KEY IDENTIK
         │
         ▼
[Pull ciphertext dari Supabase → decrypt] ✓

YANG USER LAKUKAN: Login Google saja.
```

**Jaminan keamanan:**
- ✅ Server tidak pernah menyentuh key (berbeda dari Opsi A)
- ✅ Key adalah random — tidak ada secret di APK
- ✅ APK reverse engineering tidak berguna
- ✅ ZK terjaga secara teknis, bukan hanya klaim
- ✅ Cross-device zero friction — login Google = data kembali
- ⚠️ Root of trust: Google account user
- ⚠️ Jika Google account hilang → data tidak bisa diakses (by design)

---

## 7. BACKGROUND SERVICES & TIMING

### 7.1 WorkManager Setup

```dart
// lib/core/services/background_task_service.dart

class BackgroundTaskService {
  static const String DAILY_SUMMARIZATION_TASK = 'daily_summarization';
  static const String WEEKLY_PROFILING_TASK = 'weekly_profiling';
  static const String SYNC_TASK = 'sync_task';
  
  Future<void> initialize() async {
    // Register background task
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    
    // Schedule periodic tasks
    await scheduleDailySummarization();
    await scheduleWeeklyProfiling();
    await scheduleSyncTask();
  }
  
  /// Daily Summarization
  /// Trigger: Device charging + 24 hours passed
  Future<void> scheduleDailySummarization() async {
    await Workmanager().registerPeriodicTask(
      DAILY_SUMMARIZATION_TASK,
      DAILY_SUMMARIZATION_TASK,
      frequency: Duration(hours: 1),
      initialDelay: Duration(hours: 1),
      constraints: Constraints(
        requiresCharging: true,      // Only run when charging
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.exponential,
    );
  }
  
  /// Weekly Profiling
  /// Trigger: Every Monday 00:00
  Future<void> scheduleWeeklyProfiling() async {
    // WorkManager tidak support exact time scheduling
    // Gunakan AlarmManager + WorkManager combo
    
    final now = DateTime.now();
    final nextMonday = _getNextMonday(now);
    
    await Workmanager().registerOneOffTask(
      WEEKLY_PROFILING_TASK,
      WEEKLY_PROFILING_TASK,
      initialDelay: nextMonday.difference(now),
      constraints: Constraints(
        requiresNetwork: false,
      ),
      backoffPolicy: BackoffPolicy.exponential,
    );
  }
  
  /// Sync Task
  /// Trigger: Every 6 hours (background sync untuk cloud)
  Future<void> scheduleSyncTask() async {
    await Workmanager().registerPeriodicTask(
      SYNC_TASK,
      SYNC_TASK,
      frequency: Duration(hours: 6),
      constraints: Constraints(
        requiresNetwork: true,
        requiresDeviceIdle: false,
      ),
      backoffPolicy: BackoffPolicy.exponential,
    );
  }
  
  DateTime _getNextMonday(DateTime now) {
    final daysUntilMonday = (1 - now.weekday) % 7;
    final nextMonday = now.add(Duration(days: daysUntilMonday));
    return nextMonday.copyWith(hour: 0, minute: 0, second: 0);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      switch (taskName) {
        case 'daily_summarization':
          await _executeDailySummarization();
          return true;
          
        case 'weekly_profiling':
          await _executeWeeklyProfiling();
          return true;
          
        case 'sync_task':
          await _executeSync();
          return true;
          
        default:
          return false;
      }
    } catch (e) {
      print('Background task error: $e');
      return false;
    }
  });
}

Future<void> _executeDailySummarization() async {
  // Inject dependencies
  final serviceLocator = GetIt.instance;
  final isarService = serviceLocator<IsarService>();
  final summarizationService = serviceLocator<DailySummarizationService>();
  
  await summarizationService.summarizeLastDay();
}

Future<void> _executeWeeklyProfiling() async {
  final serviceLocator = GetIt.instance;
  final profilingService = serviceLocator<WeeklyProfilingService>();
  
  await profilingService.profileLastWeek();
}

Future<void> _executeSync() async {
  final serviceLocator = GetIt.instance;
  final syncManager = serviceLocator<SyncManager>();
  
  await syncManager.syncData();
}
```

### 7.2 Screen State Listener

```kotlin
// android/app/src/main/kotlin/com/luma/ScreenStateReceiver.kt

package com.luma

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.app.PendingIntent
import io.flutter.embedding.engine.FlutterEngine

class ScreenStateReceiver : BroadcastReceiver() {
    
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_SCREEN_ON) {
            sendEventToFlutter(context, true)
        } else if (intent?.action == Intent.ACTION_SCREEN_OFF) {
            sendEventToFlutter(context, false)
        }
    }
    
    private fun sendEventToFlutter(context: Context?, isOn: Boolean) {
        // Send event to Flutter via platform channel
        // MethodChannel('com.luma/screen_events').invokeMethod(...)
    }
}
```

---

## 8. UI/UX COMPONENTS & STATE MANAGEMENT

### 8.1 Riverpod Providers

```dart
// lib/presentation/providers/data_provider.dart

// Auth Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(GoogleSignIn());
});

final currentUserProvider = FutureProvider<String?>((ref) async {
  return await ref.watch(authServiceProvider).getCurrentUserId();
});

// Data Providers
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

final dailySummaryProvider = FutureProvider.family<DailySummary?, DateTime>((ref, date) async {
  final isar = await ref.watch(isarServiceProvider).openDb();
  final userId = await ref.watch(currentUserProvider.future);
  
  if (userId == null) return null;
  
  return await isar.dailySummaries
    .where()
    .userIdEqualTo(userId)
    .filter()
    .dateEqualTo(date)
    .findFirst();
});

final weeklyProfileProvider = FutureProvider.family<WeeklyProfile?, DateTime>(
  (ref, weekStart) async {
    final isar = await ref.watch(isarServiceProvider).openDb();
    final userId = await ref.watch(currentUserProvider.future);
    
    if (userId == null) return null;
    
    return await isar.weeklyProfiles
      .where()
      .userIdEqualTo(userId)
      .filter()
      .weekStartEqualTo(weekStart)
      .findFirst();
  },
);

// Insight Providers
final insightGeneratorProvider = Provider<InsightGenerator>((ref) {
  return InsightGenerator(
    InsightTemplateRepository(),
  );
});

final todayInsightProvider = FutureProvider<Insight?>((ref) async {
  final isar = await ref.watch(isarServiceProvider).openDb();
  final userId = await ref.watch(currentUserProvider.future);
  
  if (userId == null) return null;
  
  return await isar.insights
    .where()
    .userIdEqualTo(userId)
    .filter()
    .displayDateEqualTo(DateTime.now())
    .findFirst();
});

// Timeline Providers
final timelineDataProvider = FutureProvider<TimelineData?>((ref) async {
  final isar = await ref.watch(isarServiceProvider).openDb();
  final userId = await ref.watch(currentUserProvider.future);
  
  if (userId == null) return null;
  
  // Fetch last 7 days of daily summaries
  final summaries = await isar.dailySummaries
    .where()
    .userIdEqualTo(userId)
    .filter()
    .dateGreaterThan(DateTime.now().subtract(Duration(days: 7)))
    .findAll();
  
  return TimelineData.fromSummaries(summaries);
});
```

### 8.2 Home Page Widget

```dart
// lib/presentation/pages/home_page.dart

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayInsight = ref.watch(todayInsightProvider);
    final timelineData = ref.watch(timelineDataProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Luma',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Personal Digital Behavior Intelligence',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Insight Card
              todayInsight.when(
                data: (insight) {
                  if (insight == null) {
                    return WaitingRoom();
                  }
                  return InsightCard(insight: insight);
                },
                loading: () => ShimmerLoader(),
                error: (err, stack) => ErrorWidget(),
              ),
              
              SizedBox(height: 32),
              
              // Timeline
              timelineData.when(
                data: (data) {
                  if (data == null) return SizedBox.shrink();
                  return TimelineWidget(data: data);
                },
                loading: () => ShimmerLoader(),
                error: (err, stack) => ErrorWidget(),
              ),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 8.3 Waiting Room Widget

```dart
// lib/presentation/widgets/waiting_room.dart

class WaitingRoom extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysElapsed = _calculateDaysElapsed();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Ambient Visualization
          SizedBox(
            height: 200,
            child: AmbientVisualization(progress: daysElapsed / 7),
          ),
          
          SizedBox(height: 48),
          
          // Changing Message
          AnimatedSwitcher(
            duration: Duration(seconds: 2),
            child: Text(
              _getWaitingMessage(daysElapsed),
              key: ValueKey(daysElapsed),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // Progress indicator
          LinearProgressIndicator(
            value: daysElapsed / 3,
            minHeight: 2,
          ),
        ],
      ),
    );
  }
  
  int _calculateDaysElapsed() {
    // TODO: Get from user's first data point
    return 1;
  }
  
  String _getWaitingMessage(int days) {
    switch (days) {
      case 0:
        return 'Mendengarkan ritmemu...';
      case 1:
        return 'Mengenali pagimu...';
      case 2:
        return 'Hampir siap...';
      default:
        return 'Mengamati...';
    }
  }
}
```

### 8.4 Insight Card Widget

```dart
// lib/presentation/widgets/insight_card.dart

class InsightCard extends StatelessWidget {
  final Insight insight;
  
  const InsightCard({required this.insight});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: () => _showInsightDetail(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(insight.severity),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    insight.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Insight Text
                Text(
                  insight.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
                
                if (insight.subtext != null) ...[
                  SizedBox(height: 12),
                  Text(
                    insight.subtext!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                
                SizedBox(height: 20),
                
                // Feedback Section
                _buildFeedback(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeedback(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apakah ini terasa benar?',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Record feedback
                },
                child: Text('Ya, kurang lebih.'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Record feedback
                },
                child: Text('Belum yakin.'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Luma akan terus mengamati. Cerita yang lebih panjang biasanya muncul setelah seminggu.',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Color _getSeverityColor(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.info:
        return Colors.blue;
      case InsightSeverity.notice:
        return Colors.orange;
      case InsightSeverity.warning:
        return Colors.red;
      case InsightSeverity.gentle:
        return Colors.green;
    }
  }
  
  void _showInsightDetail(BuildContext context) {
    // TODO: Show bottom sheet atau full screen detail
  }
}
```

---

## 9. TESTING & VALIDATION STRATEGY

### 9.1 Unit Tests

```dart
// test/unit/rule_engine_test.dart

void main() {
  group('FocusSessionRule', () {
    late FocusSessionRule rule;
    
    setUp(() {
      rule = FocusSessionRule();
    });
    
    test('Should trigger when focus sessions > 0', () async {
      final context = RuleContext(
        dailySummary: DailySummary()
          ..focusSessions = 2
          ..focusMinutes = 120,
        weeklyProfile: null,
        baseline: Baseline()..emaFocusScore = 0.7,
      );
      
      final result = await rule.evaluate(context);
      
      expect(result, true);
    });
    
    test('Should not trigger when no focus sessions', () async {
      final context = RuleContext(
        dailySummary: DailySummary()..focusSessions = 0,
        weeklyProfile: null,
        baseline: Baseline(),
      );
      
      final result = await rule.evaluate(context);
      
      expect(result, false);
    });
  });
  
  group('BurnoutAccumulationRule', () {
    test('Should compute correct burnout score', () {
      final rule = BurnoutAccumulationRule();
      
      final context = RuleContext(
        dailySummary: DailySummary()
          ..screenOffDuration = 300 // <6 jam
          ..nightActivity = 45 // >30
          ..distractionScore = 0.7
          ..appSwitchesPerHour = 10,
        weeklyProfile: null,
        baseline: Baseline()
          ..focusVariance = 0.6,
      );
      
      final score = rule.computeBurnoutScore(context);
      
      // Expected: 15 + 15 + 20 + 10 + 10 = 70
      expect(score, greaterThan(60));
    });
  });
}
```

### 9.2 Encryption Tests

```dart
// test/unit/encryption_test.dart

void main() {
  group('EncryptionService', () {
    late EncryptionService encryptionService;
    
    setUp(() async {
      encryptionService = EncryptionService(MockSecureStorageService());
      await encryptionService.initialize('test_google_id_12345');
    });
    
    test('Should encrypt and decrypt correctly', () async {
      final plaintext = 'This is secret data';
      
      final encrypted = await encryptionService.encrypt(plaintext);
      final decrypted = await encryptionService.decrypt(encrypted);
      
      expect(decrypted, plaintext);
    });
    
    test('Should produce different ciphertexts for same plaintext', () async {
      final plaintext = 'Same data';
      
      final encrypted1 = await encryptionService.encrypt(plaintext);
      final encrypted2 = await encryptionService.encrypt(plaintext);
      
      expect(encrypted1.ciphertext, isNot(encrypted2.ciphertext));
      expect(encrypted1.iv, isNot(encrypted2.iv));
    });
    
    test('Should fail to decrypt with wrong key', () async {
      final encrypted = await encryptionService.encrypt('secret');
      
      // Create new service dengan different key
      final wrongService = EncryptionService(MockSecureStorageService());
      await wrongService.initialize('different_google_id');
      
      expect(
        () => wrongService.decrypt(encrypted),
        throwsException,
      );
    });
  });
}
```

### 9.3 Integration Tests

```dart
// test/integration/full_flow_test.dart

void main() {
  group('Full Data Pipeline', () {
    test('Raw events → Daily summary → Insight generation', () async {
      // Setup
      final isarService = IsarService();
      final isar = await isarService.openDb();
      
      // Create mock raw events
      final events = _createMockEvents(duration: Duration(hours: 24));
      
      await isar.writeTxn(() async {
        await isar.rawEvents.putAll(events);
      });
      
      // Trigger daily summarization
      final summaryService = DailySummarizationService(isarService);
      await summaryService.summarizeLastDay();
      
      // Verify daily summary created
      final summary = await isar.dailySummaries.findFirst();
      expect(summary, isNotNull);
      expect(summary?.totalScreenTime, greaterThan(0));
      
      // Trigger insight generation
      final ruleContext = RuleContext(
        dailySummary: summary!,
        weeklyProfile: null,
        baseline: await isar.baselines.findFirst(),
      );
      
      final ruleEngine = RuleEngine();
      ruleEngine.registerRules();
      final results = await ruleEngine.evaluate(ruleContext);
      
      // Verify insights generated
      expect(results, isNotEmpty);
      expect(results.first.insight, isNotEmpty);
      
      // NVC validation
      expect(_isValidNVC(results.first.insight), true);
    });
  });
  
  List<RawEvent> _createMockEvents({required Duration duration}) {
    // Create realistic mock event sequence
    // ...
    return [];
  }
}
```

---

## 10. DEPLOYMENT & SERVER SETUP

### 10.1 Supabase Storage Setup

```typescript
// supabase/functions/handle-sync/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
}

serve(async (req) => {
  // Handle CORS
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  const { user_id, encrypted_data, iv, version } = await req.json()

  // Validate
  if (!user_id || !encrypted_data || !iv) {
    return new Response(
      JSON.stringify({ error: "Missing required fields" }),
      { 
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    )
  }

  // Store encrypted data
  // Server NEVER decrypts, just stores as-is
  const timestamp = new Date().toISOString()
  const filename = `${user_id}/${timestamp}.json`

  try {
    // Upload to Supabase Storage
    const { data, error } = await supabase
      .storage
      .from('luma_encrypted_data')
      .upload(filename, JSON.stringify({
        user_id,
        encrypted_data,
        iv,
        version,
        uploaded_at: timestamp,
      }))

    if (error) {
      throw error
    }

    return new Response(
      JSON.stringify({ 
        success: true,
        filename,
      }),
      { 
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    )
  }
})
```

### 10.2 Environment Configuration

```bash
# .env.development
FLUTTER_ENV=development
API_BASE_URL=http://localhost:3000
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
GOOGLE_IOS_CLIENT_ID=xxx.apps.googleusercontent.com
GOOGLE_ANDROID_CLIENT_ID=xxx.apps.googleusercontent.com

# .env.production
FLUTTER_ENV=production
API_BASE_URL=https://api.luma.app
SUPABASE_URL=https://abc.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
GOOGLE_IOS_CLIENT_ID=xxx.apps.googleusercontent.com
GOOGLE_ANDROID_CLIENT_ID=xxx.apps.googleusercontent.com
APP_SECRET=<32-char-secret-for-key-derivation>
```

---

## 11. DEVELOPMENT CHECKLIST

### Phase 0: Foundation (Weeks 1-2)

- [ ] Setup Flutter project dengan folder structure
- [ ] Pubspec setup (dependencies)
- [ ] Android permissions & manifest configuration
- [ ] Isar database schema design
- [ ] Initial Google Sign-In setup
- [ ] Encryption key derivation (Argon2id)
- [ ] AES-256-GCM encryption implementation
- [ ] Secure storage setup

### Phase 1: Data Collection (Weeks 3-4)

- [ ] UsageStatsManager integration (Android)
- [ ] Screen listener broadcast receiver
- [ ] Event aggregation service
- [ ] Background task service (WorkManager)
- [ ] Daily summarization logic
- [ ] Raw event → Daily summary pipeline
- [ ] Data retention policy implementation

### Phase 2: Analysis & Rules (Weeks 5-6)

- [ ] Rule engine architecture
- [ ] 5 core rules implementation
- [ ] Baseline (EMA) computation
- [ ] Anomaly detection logic
- [ ] Burnout score calculation
- [ ] Unit tests for rules

### Phase 3: Insights (Weeks 7-8)

- [ ] Insight generator engine
- [ ] NVC validation for insights
- [ ] Insight templates & variation
- [ ] Weekly reflection generator
- [ ] Insight storage & retrieval

### Phase 4: UI/UX (Weeks 9-10)

- [ ] Theme & color palette
- [ ] Ambient visualization component
- [ ] Home page layout
- [ ] Insight card widget
- [ ] Waiting room widget
- [ ] Timeline widget (basic)
- [ ] Onboarding screens

### Phase 5: Integration & Sync (Weeks 11-12)

- [ ] Riverpod state management setup
- [ ] Data sync to Supabase
- [ ] Cloud sync manager
- [ ] Multi-device support
- [ ] Data decryption on download

### Phase 6: Beta Testing (Weeks 13-14)

- [ ] Integration tests
- [ ] Performance optimization
- [ ] Battery & memory profiling
- [ ] Beta tester onboarding
- [ ] Feedback collection & iteration

---

## 12. PERFORMANCE & OPTIMIZATION

### 12.1 Database Indexing

```dart
// lib/data/db/isar_service.dart

// Indexes untuk performa query
@Collection()
class RawEvent {
  late Id? id;
  late DateTime timestamp;
  late String userId; // INDEX
  late String eventType; // INDEX
  late DateTime createdAt; // INDEX
  
  // Create composite indexes
  // indexed: [['userId', 'timestamp'], ['userId', 'eventType']]
}
```

### 12.2 Background Service Optimization

```dart
// Jangan trigger terlalu sering
// Optimal:
// - Event aggregation: Every 5 minutes
// - Daily summarization: Once per day (charging trigger)
// - Weekly profiling: Once per week (Monday 00:00)
// - Cloud sync: Every 6 hours

// Hindari:
// - Real-time streaming
// - Continuous rule evaluation
// - Frequent database writes
```

### 12.3 Memory Management

```dart
// Use streams dengan backpressure
// Limit batch operations
// Clear cache setelah summarization
// Use object pooling untuk events
```

---

## KESIMPULAN

Dokumen ini adalah **technical blueprint** untuk Luma yang menerjemahkan filosofi menjadi implementasi konkret.

**Key Principle**: Setiap keputusan teknis harus align dengan filosofi "Observe Quietly":
- ✅ Data privacy (absolute ZK)
- ✅ Minimal notifications
- ✅ Meaningful insights (NVC-aligned)
- ✅ Efficient background services
- ✅ User autonomy (tidak paksakan behavior)

**Next Step**: Mulai Phase 0 dengan fokus pada database design & data pipeline. Semua layer lain bergantung pada fondasi ini.

---

**Status**: Ready to build 🚀

