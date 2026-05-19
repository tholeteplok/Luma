import 'package:luma/data/tracking/usage_stats_service.dart';
import 'package:luma/core/platform/screen_state_listener.dart';
import 'package:luma/data/db/database_service.dart';
import 'package:luma/data/db/models/models.dart';
import 'package:logging/logging.dart';

/// Service untuk mengagregasi raw events menjadi DailySummary.
/// 
/// Menjalankan aggregation setiap jam (saat charging) untuk membuat
/// summary dari aktivitas hari ini.
class EventAggregator {
  static final _log = Logger('EventAggregator');

  final DatabaseService _db;
  final UsageStatsService _usageStats;
  final ScreenStateListener _screenListener;

  EventAggregator({
    required DatabaseService db,
    required UsageStatsService usageStats,
    required ScreenStateListener screenListener,
  })  : _db = db,
        _usageStats = usageStats,
        _screenListener = screenListener;

  /// Initialize aggregator - start listening to screen events
  void initialize() {
    _log.info('Initializing event aggregator');
    
    // Listen to screen state changes
    _screenListener.screenStateStream.listen((event) {
      _handleScreenEvent(event);
    });
  }

  /// Handle screen state event dan save ke database
  Future<void> _handleScreenEvent(ScreenStateEvent event) async {
    try {
      final rawEvent = event.toRawEvent();
      await _db.saveRawEvent(rawEvent);
      _log.fine('Saved screen state event: ${event.isScreenOn ? "ON" : "OFF"}');
    } catch (e) {
      _log.severe('Error saving screen state event: $e');
    }
  }

  /// Collect app usage data dan save sebagai raw events
  /// Dipanggil secara periodic (setiap 15-30 menit)
  Future<int> collectAppUsage() async {
    try {
      _log.info('Collecting app usage data...');
      
      final events = await _usageStats.getRecentAppUsage(
        duration: const Duration(minutes: 30),
      );

      if (events.isEmpty) {
        _log.fine('No app usage data to save');
        return 0;
      }

      // Save semua events ke database
      int savedCount = 0;
      for (final event in events) {
        try {
          await _db.saveRawEvent(event);
          savedCount++;
        } catch (e) {
          _log.warning('Failed to save event: $e');
        }
      }

      _log.info('Collected and saved $savedCount app usage events');
      return savedCount;
    } catch (e) {
      _log.severe('Error collecting app usage: $e');
      return 0;
    }
  }

  /// Aggregate raw events menjadi DailySummary untuk tanggal tertentu
  /// Returns DailySummary atau null jika tidak ada data
  Future<DailySummary?> aggregateDay(DateTime date) async {
    try {
      _log.info('Aggregating day: ${date.toString().substring(0, 10)}');

      // Get semua raw events untuk hari ini
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final rawEvents = await _db.getRawEvents(
        startTime: startOfDay,
        endTime: endOfDay,
      );

      if (rawEvents.isEmpty) {
        _log.fine('No raw events found for $date');
        return null;
      }

      // Hitung metrics
      final totalScreenTime = _calculateTotalScreenTime(rawEvents);
      final appUsage = _calculateAppUsage(rawEvents);
      final screenOnOffCount = _countScreenEvents(rawEvents);
      final topApps = _getTopApps(appUsage, limit: 5);
      final focusScore = _calculateFocusScore(rawEvents, appUsage);
      final distractionCount = _countDistractions(rawEvents);

      // Buat DailySummary
      final summary = DailySummary.create(
        date: date,
        totalScreenTimeSeconds: totalScreenTime,
        appUsageMinutes: Map.fromEntries(
          appUsage.entries.map((e) => MapEntry(e.key, (e.value / 60).round())),
        ),
        topApps: topApps,
        screenOnCount: screenOnOffCount['on'] ?? 0,
        screenOffCount: screenOnOffCount['off'] ?? 0,
        focusScore: focusScore,
        distractionCount: distractionCount,
        createdAt: DateTime.now(),
      );

      // Save ke database
      await _db.saveDailySummary(summary);
      _log.info('Created daily summary for $date: ${summary.totalScreenTimeSeconds}s screen time');

      return summary;
    } catch (e) {
      _log.severe('Error aggregating day: $e');
      return null;
    }
  }

  /// Aggregate semua hari yang belum di-aggregate (dari 7 hari terakhir)
  /// Returns jumlah hari yang berhasil di-aggregate
  Future<int> aggregatePendingDays() async {
    try {
      _log.info('Aggregating pending days...');

      int aggregatedCount = 0;
      final now = DateTime.now();

      // Cek 7 hari ke belakang
      for (int i = 0; i < 7; i++) {
        final date = DateTime(now.year, now.month, now.day - i);
        
        // Skip hari ini (belum selesai)
        if (i == 0) continue;

        // Cek apakah sudah ada summary untuk hari ini
        final existing = await _db.getDailySummary(date);
        if (existing != null) {
          continue;
        }

        // Aggregate hari ini
        final summary = await aggregateDay(date);
        if (summary != null) {
          aggregatedCount++;
        }
      }

      _log.info('Aggregated $aggregatedCount pending days');
      return aggregatedCount;
    } catch (e) {
      _log.severe('Error aggregating pending days: $e');
      return 0;
    }
  }

  /// Hitung total screen time dari raw events
  int _calculateTotalScreenTime(List<RawEvent> events) {
    int totalSeconds = 0;
    
    for (final event in events) {
      if (event.type == EventType.app_usage && event.isForeground) {
        totalSeconds += event.durationSeconds;
      }
    }

    return totalSeconds;
  }

  /// Hitung usage per aplikasi
  Map<String, int> _calculateAppUsage(List<RawEvent> events) {
    final usage = <String, int>{};

    for (final event in events) {
      if (event.type == EventType.app_usage && event.isForeground) {
        usage[event.packageName] = (usage[event.packageName] ?? 0) + event.durationSeconds;
      }
    }

    return usage;
  }

  /// Hitung jumlah screen on/off events
  Map<String, int> _countScreenEvents(List<RawEvent> events) {
    int onCount = 0;
    int offCount = 0;

    for (final event in events) {
      if (event.type == EventType.screen_state) {
        if (event.isForeground) {
          onCount++;
        } else {
          offCount++;
        }
      }
    }

    return {'on': onCount, 'off': offCount};
  }

  /// Get top N aplikasi berdasarkan usage
  List<Map<String, dynamic>> _getTopApps(Map<String, int> appUsage, {int limit = 5}) {
    final sorted = appUsage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((entry) {
      return {
        'packageName': entry.key,
        'durationSeconds': entry.value,
      };
    }).toList();
  }

  /// Hitung focus score (0-100) berdasarkan pola penggunaan
  /// Score tinggi = fokus baik (sedikit context switching)
  double _calculateFocusScore(List<RawEvent> events, Map<String, int> appUsage) {
    if (appUsage.isEmpty) return 0;

    // Hitung number of app switches
    int switches = 0;
    String? lastApp;

    final sortedEvents = List<RawEvent>.from(events)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final event in sortedEvents) {
      if (event.type == EventType.app_usage && event.isForeground) {
        if (lastApp != null && event.packageName != lastApp) {
          switches++;
        }
        lastApp = event.packageName;
      }
    }

    // Score formula: 100 - (switches per hour * 10), min 0
    final totalHours = _calculateTotalScreenTime(events) / 3600;
    if (totalHours == 0) return 0;

    final switchesPerHour = switches / totalHours;
    final score = (100 - (switchesPerHour * 10)).clamp(0, 100);

    return score.toDouble();
  }

  /// Hitung jumlah distraksi (app switches ke social media apps)
  int _countDistractions(List<RawEvent> events) {
    final distractionPackages = [
      'com.instagram.android',
      'com.facebook.katana',
      'com.facebook.orca', // Messenger
      'com.twitter.android',
      'com.snapchat.android',
      'com.tiktok',
      'com.zhiliaoapp.musically', // TikTok
      'com.whatsapp',
      'com.discord',
      'com.reddit.frontpage',
    ];

    int distractionCount = 0;
    String? lastApp;

    final sortedEvents = List<RawEvent>.from(events)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final event in sortedEvents) {
      if (event.type == EventType.app_usage && event.isForeground) {
        if (distractionPackages.contains(event.packageName)) {
          // Count as distraction jika switch dari non-distraction app
          if (lastApp != null && !distractionPackages.contains(lastApp)) {
            distractionCount++;
          }
        }
        lastApp = event.packageName;
      }
    }

    return distractionCount;
  }

  /// Aggregate raw events by app untuk menghasilkan DailyAppMetric
  /// Dipanggil setiap jam oleh background task
  Future<List<DailyAppMetric>> aggregateByApp(List<RawEvent> events) async {
    final metrics = <String, DailyAppMetric>{};
    
    // Group events by package and date
    final groupedEvents = <String, List<RawEvent>>{};
    
    for (final event in events) {
      if (event.type != EventType.app_usage || !event.isForeground) continue;
      
      final key = '${event.packageName}_${event.timestamp.toIso8601String().substring(0, 10)}';
      if (!groupedEvents.containsKey(key)) {
        groupedEvents[key] = [];
      }
      groupedEvents[key]!.add(event);
    }
    
    // Convert ke DailyAppMetric
    for (final entry in groupedEvents.entries) {
      final parts = entry.key.split('_');
      final packageName = parts[0];
      final dateStr = parts[1];
      final date = DateTime.parse(dateStr);
      
      final appEvents = entry.value;
      final totalDuration = appEvents.fold<int>(0, (sum, e) => sum + e.durationSeconds);
      final sessionCount = appEvents.length;
      
      // Find first and last use hour
      final hours = appEvents.map((e) => e.timestamp.hour).toList();
      hours.sort();
      final firstUseHour = hours.first;
      final lastUseHour = hours.last;
      
      final metric = DailyAppMetric(
        date: date,
        packageName: packageName,
        totalDurationSeconds: totalDuration,
        sessionCount: sessionCount,
        firstUseHour: firstUseHour,
        lastUseHour: lastUseHour,
      );
      
      metrics[entry.key] = metric;
    }
    
    return metrics.values.toList();
  }
  
  /// Generate weekly profile dari multiple daily summaries
  Future<WeeklyProfile> generateWeeklyProfile(List<DailySummary> summaries) async {
    if (summaries.isEmpty) {
      throw ArgumentError('Cannot generate weekly profile from empty summaries');
    }
    
    // Sort summaries by date
    final sortedSummaries = List<DailySummary>.from(summaries)
      ..sort((a, b) => a.date.compareTo(b.date));
    
    final weekStart = sortedSummaries.first.date;
    final totalScreenTime = sortedSummaries.fold<int>(
      0,
      (sum, s) => sum + s.totalScreenTimeSeconds,
    );
    
    final avgFocusScore = sortedSummaries.fold<double>(
      0,
      (sum, s) => sum + s.focusScore,
    ) / sortedSummaries.length;
    
    final totalDistractions = sortedSummaries.fold<int>(
      0,
      (sum, s) => sum + s.distractionCount,
    );
    
    // Aggregate top apps dari semua hari
    final appUsageMap = <String, int>{};
    for (final summary in sortedSummaries) {
      for (final entry in summary.appUsageMinutes.entries) {
        appUsageMap[entry.key] = (appUsageMap[entry.key] ?? 0) + entry.value;
      }
    }
    
    final topApps = appUsageMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final topAppsList = topApps.take(10).map((entry) {
      return {
        'packageName': entry.key,
        'durationMinutes': entry.value,
      };
    }).toList();
    
    final profile = WeeklyProfile(
      weekStart: weekStart,
      totalScreenTimeSeconds: totalScreenTime,
      averageDailyScreenTimeSeconds: (totalScreenTime / sortedSummaries.length).round(),
      averageFocusScore: avgFocusScore,
      totalDistractions: totalDistractions,
      dayCount: sortedSummaries.length,
    );
    profile.topApps = topAppsList;
    return profile;
  }
}
