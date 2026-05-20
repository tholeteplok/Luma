import 'package:flutter/material.dart';
import 'package:luma/data/db/database_service.dart';
import 'package:luma/data/db/models/daily_summary_model.dart';
import 'package:luma/data/tracking/usage_stats_service.dart';
import 'package:luma/domain/entities/behavior_snapshot.dart';
import 'package:luma/domain/entities/insight_id.dart';
import 'package:luma/domain/rules/severity_selector.dart';
import 'package:luma/domain/services/app_category_classifier.dart';
import 'package:luma/domain/services/dimension_rotation.dart';
import 'package:luma/domain/services/insight_language_engine.dart';
import 'package:luma/domain/services/insight_memory.dart';
import 'package:luma/domain/services/insight_orchestrator.dart';
import 'package:luma/domain/services/orb_state_engine.dart';
import 'package:luma/domain/services/adaptive_ambience_engine.dart';
import 'package:luma/domain/entities/ambience_profile.dart';
import 'package:luma/core/utils/luma_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home page state management
class HomeState {
  final bool isLoading;
  final String? error;

  /// Insight yang ditampilkan hari ini (kosong saat Luma diam).
  final List<Map<String, dynamic>> insights;

  /// Insight historis — untuk panel "lihat insight sebelumnya"
  /// saat Luma sedang diam.
  final List<Map<String, dynamic>> history;

  final Map<String, dynamic>? todaySummary;
  final List<Map<String, dynamic>> weeklyData;

  /// Apakah permission usage stats sudah diberikan
  final bool hasUsagePermission;

  /// Apakah Luma memilih diam hari ini.
  /// Saat true, [insights] kosong dan UI bisa menampilkan
  /// orb dalam mood `gentle` / `rest`.
  final bool isSilent;

  /// Dimensi perhatian aktif minggu ini (untuk debug / future UI hint)
  final InsightDimension activeDimension;

  /// Kedalaman observasi aktif (surface / pattern / relationship / longitudinal)
  final DepthLevel depth;

  /// True jika ini adalah insight pertama user (hari 1–3).
  /// UI akan render [FirstInsightCard] alih-alih [InsightCard] biasa.
  final bool isFirstInsight;

  /// State orb adaptif — berevolusi berdasarkan pola perilaku.
  final OrbState orbState;

  /// Profile ambience lengkap dari AdaptiveAmbienceEngine.
  /// Null jika data belum cukup atau engine belum dijalankan.
  final AmbienceProfile? ambienceProfile;

  /// True jika ada insight dalam history berusia >30 hari
  final bool nostalgiaActive;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.insights = const [],
    this.history = const [],
    this.todaySummary,
    this.weeklyData = const [],
    this.hasUsagePermission = false,
    this.isSilent = false,
    this.activeDimension = InsightDimension.morningRhythm,
    this.depth = DepthLevel.surface,
    this.isFirstInsight = false,
    this.orbState = OrbState.dawn,
    this.ambienceProfile,
    this.nostalgiaActive = false,
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<Map<String, dynamic>>? insights,
    List<Map<String, dynamic>>? history,
    Map<String, dynamic>? todaySummary,
    List<Map<String, dynamic>>? weeklyData,
    bool? hasUsagePermission,
    bool? isSilent,
    InsightDimension? activeDimension,
    DepthLevel? depth,
    bool? isFirstInsight,
    OrbState? orbState,
    AmbienceProfile? ambienceProfile,
    bool? nostalgiaActive,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      insights: insights ?? this.insights,
      history: history ?? this.history,
      todaySummary: todaySummary ?? this.todaySummary,
      weeklyData: weeklyData ?? this.weeklyData,
      hasUsagePermission: hasUsagePermission ?? this.hasUsagePermission,
      isSilent: isSilent ?? this.isSilent,
      activeDimension: activeDimension ?? this.activeDimension,
      depth: depth ?? this.depth,
      isFirstInsight: isFirstInsight ?? this.isFirstInsight,
      orbState: orbState ?? this.orbState,
      ambienceProfile: ambienceProfile ?? this.ambienceProfile,
      nostalgiaActive: nostalgiaActive ?? this.nostalgiaActive,
    );
  }
}

/// Home notifier — terhubung ke real behavioral data pipeline
class HomeNotifier extends ChangeNotifier {
  HomeState _state = const HomeState();

  final UsageStatsService _usageStats;
  final DatabaseService _db;

  /// Memory & orchestrator dibangun async saat loadData pertama
  InsightMemory? _memory;
  InsightOrchestrator? _orchestrator;

  HomeNotifier({
    UsageStatsService? usageStats,
    DatabaseService? db,
  })  : _usageStats = usageStats ?? UsageStatsService(),
        _db = db ?? DatabaseService();

  HomeState get state => _state;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  List<Map<String, dynamic>> get insights => _state.insights;
  List<Map<String, dynamic>> get history => _state.history;
  Map<String, dynamic>? get todaySummary => _state.todaySummary;
  List<Map<String, dynamic>> get weeklyData => _state.weeklyData;
  bool get hasUsagePermission => _state.hasUsagePermission;
  bool get isSilent => _state.isSilent;
  bool get isFirstInsight => _state.isFirstInsight;
  OrbState get orbState => _state.orbState;
  AmbienceProfile? get ambienceProfile => _state.ambienceProfile;
  bool get nostalgiaActive => _state.nostalgiaActive;
  InsightDimension get activeDimension => _state.activeDimension;
  DepthLevel get depth => _state.depth;

  Future<InsightOrchestrator> _ensureOrchestrator() async {
    if (_orchestrator != null) return _orchestrator!;
    _memory = await InsightMemory.create();
    _orchestrator = InsightOrchestrator(memory: _memory!);
    return _orchestrator!;
  }

  /// Load data dari pipeline behavioral
  Future<void> loadData({LumaLanguage language = LumaLanguage.indonesian}) async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    try {
      // 1. Cek permission
      final hasPermission = await _usageStats.hasUsageStatsPermission();

      // 2. Ambil data usage hari ini (terakhir 24 jam)
      Map<String, int> topAppsToday = {};
      int screenOpenCount = 0;

      if (hasPermission) {
        topAppsToday = await _usageStats.getTopApps(
          duration: const Duration(hours: 24),
          limit: 20,
        );
      }

      // 3. Ambil daily summary dari DB (jika ada)
      DailySummary? todayDb;
      try {
        todayDb = await _db.getDailySummary(DateTime.now());
        screenOpenCount = todayDb?.screenOnCount ?? 0;
      } catch (_) {
        // DB mungkin belum init — tidak fatal
      }

      // 4. Hitung baseline (rata-rata 7 hari terakhir)
      int baselineSeconds = 0;
      int baselineDays = 0;
      DailySummary? yesterdayDb;
      try {
        final past7 = await _db.getDailySummariesBetween(
          DateTime.now().subtract(const Duration(days: 8)),
          DateTime.now().subtract(const Duration(days: 1)),
        );
        if (past7.isNotEmpty) {
          baselineSeconds =
              past7.fold<int>(0, (s, d) => s + d.totalScreenTimeSeconds) ~/
                  past7.length;
          baselineDays = past7.length;
          // Kemarin = entry terakhir (urutan tergantung filter, ambil yg paling baru)
          past7.sort((a, b) => b.date.compareTo(a.date));
          yesterdayDb = past7.first;
        }
      } catch (_) {}

      // 5. Klasifikasikan usage ke kategori
      final categoryUsage = AppCategoryClassifier.classifyUsageMap(topAppsToday);

      // 6. Hitung total screen time hari ini
      final totalSeconds = todayDb?.totalScreenTimeSeconds ??
          topAppsToday.values.fold<int>(0, (a, b) => a + b);

      // 7. Usage by hour — TODO: integrasi raw_event aggregation
      final Map<int, int> byHour = {};

      // 8. Switch count
      final switchCount = todayDb?.distractionCount ?? 0;

      // 9. Build BehaviorSnapshot hari ini
      final snapshot = BehaviorSnapshotFactory.create(
        categoryUsage: categoryUsage,
        switchCount: switchCount,
        totalScreenSeconds: totalSeconds,
        baselineScreenSeconds: baselineSeconds,
        screenOpenCount: screenOpenCount,
        appUsageByHour: byHour,
        baselineDays: baselineDays,
      );

      // 9b. Build snapshot kemarin (untuk delta detection di silence engine)
      BehaviorSnapshot? previousSnapshot;
      if (yesterdayDb != null) {
        previousSnapshot = BehaviorSnapshotFactory.create(
          categoryUsage: const {}, // category kemarin tidak tersimpan—proxy dengan unknown
          switchCount: yesterdayDb.distractionCount,
          totalScreenSeconds: yesterdayDb.totalScreenTimeSeconds,
          baselineScreenSeconds: baselineSeconds,
          screenOpenCount: yesterdayDb.screenOnCount,
          appUsageByHour: const {},
          baselineDays: baselineDays,
        );
      }

      // 10. Orchestrator: putuskan bicara atau diam
      final orchestrator = await _ensureOrchestrator();
      final decision = await orchestrator.decide(
        snapshot,
        language: language,
        previousSnapshot: previousSnapshot,
      );

      // 10b. Evaluasi OrbState adaptif
      final prefs = await SharedPreferences.getInstance();
      final newOrbState = await OrbStateEngine.evaluate(snapshot, prefs);

      // 10c. Evaluasi AmbienceProfile (AdaptiveAmbienceEngine)
      final newAmbienceProfile = await AdaptiveAmbienceEngine.evaluate(
        snapshot,
        await _db.getDailySummariesBetween(
          DateTime.now().subtract(const Duration(days: 7)),
          DateTime.now(),
        ),
        prefs,
      );

      // 10d. Deteksi nostalgia — ada insight history berusia >30 hari
      final historyRecords = _memory?.getHistory() ?? const [];
      final hasNostalgia = historyRecords.any(
        (r) => DateTime.now().difference(r.shownAt).inDays > 30,
      );

      // 11. Hitung severity context (budget mingguan)
      final isFirstInsight = baselineDays < 3;
      var severityCtx = SeverityContext(daysOfData: baselineDays);

      // 11a. Convert LumaInsight → Map dengan SeveritySelector
      final insightMaps = decision.insights.map((insight) {
        final significant = SeveritySelector.isSignificantChange(
          snapshot,
          previousSnapshot,
        );
        final severity = SeveritySelector.select(
          tone: insight.tone,
          daysOfData: baselineDays,
          warningsThisWeek: severityCtx.warningsThisWeek,
          noticesThisWeek: severityCtx.noticesThisWeek,
          isSignificantChange: significant,
        );
        // Update budget counter
        if (severity == InsightSeverity.warning) {
          severityCtx = severityCtx.incrementWarning();
        } else if (severity == InsightSeverity.notice) {
          severityCtx = severityCtx.incrementNotice();
        }
        return _insightToMap(insight, severity);
      }).toList();

      // 11b. History — selalu dibawa, dipakai saat silent
      final historyMaps = (_memory?.getHistory() ?? const [])
          .map(_recordToMap)
          .toList();

      // 12. Weekly data untuk timeline
      final weeklyMaps = await _buildWeeklyData();

      _state = _state.copyWith(
        isLoading: false,
        hasUsagePermission: hasPermission,
        insights: insightMaps,
        history: historyMaps,
        isSilent: decision.isSilent,
        isFirstInsight: isFirstInsight,
        orbState: newOrbState,
        ambienceProfile: newAmbienceProfile,
        nostalgiaActive: hasNostalgia,
        activeDimension: decision.activeDimension,
        depth: decision.depth,
        todaySummary: todayDb != null
            ? {
                'screenTimeSeconds': todayDb.totalScreenTimeSeconds,
                'unlocks': todayDb.screenOnCount,
              }
            : null,
        weeklyData: weeklyMaps,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
        isSilent: false,
        // Fallback: insight hari pertama
        insights: [
          {
            'id': '0',
            'title': 'Luma baru mulai mengenal ritmemu.',
            'message':
                'Dalam beberapa hari ke depan, cerminan pertama akan muncul.',
            'severity': 'gentle',
            'tone': 'calm',
            'insightId': InsightId.screenQuiet.name,
            'depth': DepthLevel.surface.name,
            'timestamp': DateTime.now(),
          },
        ],
      );
    }

    notifyListeners();
  }

  /// Build weekly chart data dari DB
  Future<List<Map<String, dynamic>>> _buildWeeklyData() async {
    try {
      final past7 = await _db.getDailySummariesBetween(
        DateTime.now().subtract(const Duration(days: 6)),
        DateTime.now(),
      );
      if (past7.isEmpty) return _placeholderWeekly();

      return past7
          .map((s) => {
                'date': s.date,
                'screenTimeSeconds': s.totalScreenTimeSeconds,
                'focusScore': s.focusScore, // 0–100, dipakai painter
              })
          .toList();
    } catch (_) {
      return _placeholderWeekly();
    }
  }

  /// Placeholder untuk 7 hari (hari pertama / tidak ada data)
  List<Map<String, dynamic>> _placeholderWeekly() {
    return List.generate(7, (i) {
      return {
        'date': DateTime.now().subtract(Duration(days: 6 - i)),
        'screenTimeSeconds': 0,
        'focusScore': 0.0,
      };
    });
  }

  /// Refresh data
  Future<void> refresh({LumaLanguage language = LumaLanguage.indonesian}) async {
    await loadData(language: language);
  }

  /// Clear error
  void clearError() {
    _state = _state.copyWith(clearError: true);
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────
  // Mappers
  // ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _insightToMap(LumaInsight insight, InsightSeverity severity) {
    return {
      'id': insight.id.name,
      'insightId': insight.id.name,
      'title': insight.phrase,
      'message': insight.subPhrase ?? '',
      'tone': insight.tone.name,
      'severity': SeveritySelector.toCardSeverity(severity),
      'depth': insight.depth.name,
      'timestamp': DateTime.now(),
    };
  }

  Map<String, dynamic> _recordToMap(LumaInsightRecord r) {
    return {
      'id': '${r.insightId.name}_${r.shownAt.millisecondsSinceEpoch}',
      'insightId': r.insightId.name,
      'title': r.phrase,
      'message': r.subPhrase ?? '',
      'tone': r.tone,
      'severity': _severityFromToneName(r.tone),
      'timestamp': r.shownAt,
    };
  }

  /// Map InsightTone → severity string (fallback untuk history records).
  String _severityFromTone(InsightTone tone) {
    return switch (tone) {
      InsightTone.calm => 'gentle',
      InsightTone.meaningful => 'gentle',
      InsightTone.different => 'notice',
      InsightTone.reflective => 'info',
      InsightTone.neutral => 'info',
    };
  }

  String _severityFromToneName(String name) {
    final tone = InsightTone.values.firstWhere(
      (t) => t.name == name,
      orElse: () => InsightTone.neutral,
    );
    return _severityFromTone(tone);
  }
}
