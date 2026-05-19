import 'package:flutter/material.dart';

/// Home page state management
class HomeState {
  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>> insights;
  final Map<String, dynamic>? todaySummary;
  final List<Map<String, dynamic>> weeklyData;
  final double focusLevel;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.insights = const [],
    this.todaySummary,
    this.weeklyData = const [],
    this.focusLevel = 0.5,
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? insights,
    Map<String, dynamic>? todaySummary,
    List<Map<String, dynamic>>? weeklyData,
    double? focusLevel,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      insights: insights ?? this.insights,
      todaySummary: todaySummary ?? this.todaySummary,
      weeklyData: weeklyData ?? this.weeklyData,
      focusLevel: focusLevel ?? this.focusLevel,
    );
  }

  /// Get severity color untuk insight berdasarkan index
  Color getInsightSeverityColor(int index) {
    if (insights.isEmpty) return Colors.blue;
    if (index >= insights.length) return Colors.blue;
    
    final severity = insights[index]['severity'] as String?;
    switch (severity?.toLowerCase()) {
      case 'critical':
      case 'warning':
        return const Color(0xFFEF4444);
      case 'notice':
        return const Color(0xFFF59E0B);
      case 'gentle':
      case 'positive':
        return const Color(0xFF10B981);
      case 'info':
      default:
        return const Color(0xFF3B82F6);
    }
  }
}

/// Simple home notifier (alternatif jika tidak menggunakan BLoC/Riverpod)
class HomeNotifier extends ChangeNotifier {
  HomeState _state = const HomeState();

  HomeState get state => _state;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  List<Map<String, dynamic>> get insights => _state.insights;
  Map<String, dynamic>? get todaySummary => _state.todaySummary;
  List<Map<String, dynamic>> get weeklyData => _state.weeklyData;
  double get focusLevel => _state.focusLevel;

  /// Load data dari database
  Future<void> loadData() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // TODO: Implement dengan actual data loading dari DatabaseService
      await Future.delayed(const Duration(milliseconds: 500));
      
      _state = _state.copyWith(
        isLoading: false,
        insights: [
          {
            'id': '1',
            'title': 'Pagi ini fokusmu stabil.',
            'message': 'Ritme kerja yang konsisten terlihat dalam 3 hari terakhir.',
            'severity': 'positive',
            'timestamp': DateTime.now(),
          },
        ],
        todaySummary: {
          'screenTime': 4.5,
          'unlocks': 45,
          'focusScore': 0.75,
        },
        weeklyData: List.generate(7, (index) {
          return {
            'day': ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'][index],
            'screenTime': 4.0 + (index % 3),
            'focusScore': 0.6 + (index % 4) * 0.1,
          };
        }),
        focusLevel: 0.75,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    
    notifyListeners();
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadData();
  }

  /// Clear error
  void clearError() {
    _state = _state.copyWith(error: null);
    notifyListeners();
  }
}
