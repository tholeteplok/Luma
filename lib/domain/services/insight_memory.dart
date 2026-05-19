library;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:luma/domain/entities/insight_id.dart';

/// InsightMemory — Melacak kapan terakhir setiap insight muncul.
///
/// Ini adalah "memori" Luma.
/// Luma tidak menampilkan hal yang sama terlalu cepat —
/// bukan karena tidak tahu, tapi karena memilih diam.
class InsightMemory {
  static const _prefix = 'luma_insight_cooldown_';
  static const _historyKey = 'luma_insight_history';
  static const _maxHistoryItems = 60; // 60 insight terakhir tersimpan

  final SharedPreferences _prefs;

  InsightMemory(this._prefs);

  static Future<InsightMemory> create() async {
    final prefs = await SharedPreferences.getInstance();
    return InsightMemory(prefs);
  }

  // ──────────────────────────────────────────────────────────────
  // Cooldown Tracking
  // ──────────────────────────────────────────────────────────────

  /// Catat bahwa insight ini baru saja ditampilkan
  Future<void> record(InsightId id) async {
    final key = '$_prefix${id.name}';
    await _prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
  }

  /// Catat beberapa insight sekaligus
  Future<void> recordAll(List<InsightId> ids) async {
    for (final id in ids) {
      await record(id);
    }
  }

  /// Cek apakah insight ini masih dalam cooldown
  bool isOnCooldown(InsightId id) {
    final key = '$_prefix${id.name}';
    final lastShownMs = _prefs.getInt(key);
    if (lastShownMs == null) return false; // Belum pernah muncul

    final lastShown = DateTime.fromMillisecondsSinceEpoch(lastShownMs);
    final cooldown = insightCooldowns[id] ?? const Duration(days: 7);
    final cooldownEnd = lastShown.add(cooldown);

    return DateTime.now().isBefore(cooldownEnd);
  }

  /// Berapa hari tersisa sebelum insight bisa muncul lagi
  int daysUntilAvailable(InsightId id) {
    final key = '$_prefix${id.name}';
    final lastShownMs = _prefs.getInt(key);
    if (lastShownMs == null) return 0;

    final lastShown = DateTime.fromMillisecondsSinceEpoch(lastShownMs);
    final cooldown = insightCooldowns[id] ?? const Duration(days: 7);
    final cooldownEnd = lastShown.add(cooldown);
    final remaining = cooldownEnd.difference(DateTime.now());

    return remaining.isNegative ? 0 : remaining.inDays;
  }

  /// Filter InsightId yang tersedia (tidak dalam cooldown + data threshold terpenuhi)
  List<InsightId> filterAvailable(
    List<InsightId> candidates,
    int daysOfData,
  ) {
    return candidates.where((id) {
      if (isOnCooldown(id)) return false;
      final threshold = insightDataThreshold[id] ?? 0;
      return daysOfData >= threshold;
    }).toList();
  }

  // ──────────────────────────────────────────────────────────────
  // History Tracking (untuk "lihat insight sebelumnya")
  // ──────────────────────────────────────────────────────────────

  /// Simpan insight ke history (untuk ditampilkan user saat request)
  Future<void> saveToHistory(LumaInsightRecord record) async {
    final history = getHistory();
    history.insert(0, record); // Terbaru di depan

    // Batasi max history
    final trimmed = history.take(_maxHistoryItems).toList();
    final encoded = trimmed.map((r) => r.toPrefsString()).toList();
    await _prefs.setStringList(_historyKey, encoded);
  }

  /// Ambil semua history insight
  List<LumaInsightRecord> getHistory() {
    final raw = _prefs.getStringList(_historyKey) ?? [];
    return raw
        .map((s) => LumaInsightRecord.fromPrefsString(s))
        .whereType<LumaInsightRecord>()
        .toList();
  }

  /// Apakah ada history (untuk menentukan UI silent state)
  bool get hasHistory {
    final history = getHistory();
    return history.isNotEmpty;
  }

  /// Clear semua cooldown (untuk testing / reset)
  Future<void> clearAll() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
    await _prefs.remove(_historyKey);
  }
}

/// Record satu insight yang pernah ditampilkan — untuk history
class LumaInsightRecord {
  final String phrase;
  final String? subPhrase;
  final InsightId insightId;
  final DateTime shownAt;
  final String tone; // InsightTone.name

  const LumaInsightRecord({
    required this.phrase,
    this.subPhrase,
    required this.insightId,
    required this.shownAt,
    required this.tone,
  });

  /// Simpan ke string (untuk SharedPrefs)
  String toPrefsString() {
    final sub = subPhrase?.replaceAll('|', '\\|') ?? '';
    final phrase_ = phrase.replaceAll('|', '\\|');
    return '${insightId.name}|${shownAt.millisecondsSinceEpoch}|$tone|$phrase_|$sub';
  }

  /// Baca dari string
  static LumaInsightRecord? fromPrefsString(String s) {
    try {
      final parts = s.split('|');
      if (parts.length < 4) return null;
      final id = InsightId.values.firstWhere(
        (e) => e.name == parts[0],
        orElse: () => InsightId.screenPresent,
      );
      final ms = int.tryParse(parts[1]) ?? 0;
      return LumaInsightRecord(
        insightId: id,
        shownAt: DateTime.fromMillisecondsSinceEpoch(ms),
        tone: parts[2],
        phrase: parts[3].replaceAll('\\|', '|'),
        subPhrase: parts.length > 4 && parts[4].isNotEmpty
            ? parts[4].replaceAll('\\|', '|')
            : null,
      );
    } catch (_) {
      return null;
    }
  }
}
