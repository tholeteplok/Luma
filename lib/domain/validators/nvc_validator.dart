library;

import 'package:luma/core/utils/luma_language.dart';

/// NVCValidator — Guardrail etis Luma.
///
/// Setiap insight yang keluar dari engine harus lolos validator ini
/// sebelum ditampilkan ke user. Ini bukan filter estetika — ini
/// perlindungan filosofis: Luma tidak boleh menghakimi.
///
/// 4 aturan keras (dari LUMA_UI_CLARIFICATIONS.md Section 5):
/// 1. Tidak ada kata terlarang (evaluatif, preskriptif, menghakimi)
/// 2. Tidak ada angka absolut dalam teks
/// 3. Tidak ada kalimat imperatif ("lakukan X", "coba Y")
/// 4. Maksimal 2 kalimat per insight
///
/// Validator ini juga mendeteksi apakah insight adalah "first insight"
/// (hari 1–3) dan menerapkan aturan tambahan untuk momen itu.
class NVCValidator {
  NVCValidator._();

  // ─── Kata terlarang ────────────────────────────────────────────────────────

  /// Kata-kata yang mengevaluasi, menghakimi, atau menekan (Bahasa Indonesia)
  static const _forbiddenId = <String>[
    // Preskriptif / imperatif
    'harus', 'seharusnya', 'wajib', 'jangan', 'perlu', 'cobalah', 'coba untuk',
    'sebaiknya', 'lebih baik', 'disarankan',
    // Evaluatif negatif
    'buruk', 'gagal', 'salah', 'malas', 'bodoh', 'payah', 'lemah',
    'tidak produktif', 'kecanduan', 'buang waktu', 'sia-sia',
    'tidak disiplin', 'tidak bisa', 'tidak mampu', 'malu', 'memalukan',
    // Evaluatif positif yang memicu tekanan
    'bagus sekali', 'hebat', 'luar biasa', 'sempurna',
    // Generalisasi
    'selalu', 'tidak pernah', 'terus-menerus',
  ];

  /// Kata-kata terlarang (English)
  static const _forbiddenEn = <String>[
    // Prescriptive / imperative
    'should', 'must', 'have to', 'need to', 'try to', 'you need',
    'you should', 'better', 'recommended',
    // Evaluative negative
    'bad', 'failed', 'failure', 'lazy', 'stupid', 'weak', 'shameful',
    'unproductive', 'addicted', 'wasting time', 'pointless',
    'undisciplined', 'cannot', 'unable',
    // Evaluative positive (pressure-inducing)
    'amazing', 'perfect', 'excellent',
    // Generalizations
    'always', 'never', 'constantly',
    'you always', 'you never',
  ];

  /// Pola angka absolut — insight tidak boleh menyebut durasi/jumlah spesifik
  static final _absoluteNumberPattern = RegExp(
    r'\b\d+\s*(jam|menit|detik|kali|hari|hour|minute|second|time|day)\b',
    caseSensitive: false,
  );

  /// Pola kalimat imperatif (dimulai dengan kata kerja perintah)
  static final _imperativePatternId = RegExp(
    r'^(lakukan|mulai|hentikan|kurangi|tambah|perbaiki|ubah|coba|pastikan)',
    caseSensitive: false,
  );
  static final _imperativePatternEn = RegExp(
    r'^(do|start|stop|reduce|increase|fix|change|try|make sure|ensure)',
    caseSensitive: false,
  );

  // ─── Public API ────────────────────────────────────────────────────────────

  /// Validasi satu teks insight.
  ///
  /// [text] — teks yang akan divalidasi
  /// [language] — bahasa teks
  /// [isFirstInsight] — true jika ini insight pertama user (hari 1–3).
  ///   First insight punya aturan lebih ketat: harus lebih pendek dan
  ///   tidak boleh ada sub-phrase yang terasa seperti analisis.
  static NVCValidationResult validate(
    String text,
    LumaLanguage language, {
    bool isFirstInsight = false,
  }) {
    final issues = <NVCIssue>[];
    final lowerText = text.toLowerCase().trim();

    // ── Rule 1: Forbidden words ──────────────────────────────────────────────
    final forbidden =
        language == LumaLanguage.indonesian ? _forbiddenId : _forbiddenEn;
    final found = <String>[];
    for (final word in forbidden) {
      if (lowerText.contains(word.toLowerCase())) {
        found.add(word);
      }
    }
    if (found.isNotEmpty) {
      issues.add(NVCIssue(
        rule: NVCRule.forbiddenWord,
        detail: found.join(', '),
        severity: NVCIssueSeverity.blocking,
      ));
    }

    // ── Rule 2: No absolute numbers ─────────────────────────────────────────
    if (_absoluteNumberPattern.hasMatch(lowerText)) {
      issues.add(const NVCIssue(
        rule: NVCRule.absoluteNumber,
        detail: 'Angka absolut ditemukan',
        severity: NVCIssueSeverity.blocking,
      ));
    }

    // ── Rule 3: No imperative sentences ─────────────────────────────────────
    final imperativePattern = language == LumaLanguage.indonesian
        ? _imperativePatternId
        : _imperativePatternEn;
    // Cek setiap kalimat
    final sentences = _splitSentences(text);
    for (final sentence in sentences) {
      if (imperativePattern.hasMatch(sentence.trim())) {
        issues.add(NVCIssue(
          rule: NVCRule.imperativeSentence,
          detail: sentence.trim(),
          severity: NVCIssueSeverity.blocking,
        ));
        break; // satu cukup untuk flag
      }
    }

    // ── Rule 4: Max sentence count ───────────────────────────────────────────
    final maxSentences = isFirstInsight ? 1 : 2;
    if (sentences.length > maxSentences) {
      issues.add(NVCIssue(
        rule: NVCRule.tooLong,
        detail: '${sentences.length} kalimat (maks $maxSentences)',
        severity: NVCIssueSeverity.blocking,
      ));
    }

    // ── Warning: tidak ada observational opener ──────────────────────────────
    final hasObservationalOpener = _hasObservationalOpener(text, language);
    if (!hasObservationalOpener) {
      issues.add(const NVCIssue(
        rule: NVCRule.missingObservationalOpener,
        detail: 'Tidak dimulai dengan frasa observasional',
        severity: NVCIssueSeverity.warning, // tidak blocking
      ));
    }

    final blockingIssues =
        issues.where((i) => i.severity == NVCIssueSeverity.blocking).toList();

    return NVCValidationResult(
      isValid: blockingIssues.isEmpty,
      issues: issues,
      hasObservationalOpener: hasObservationalOpener,
      sentenceCount: sentences.length,
    );
  }

  /// Validasi pasangan phrase + subPhrase sekaligus.
  /// subPhrase dihitung sebagai kalimat tambahan.
  static NVCValidationResult validateInsight(
    String phrase,
    String? subPhrase,
    LumaLanguage language, {
    bool isFirstInsight = false,
  }) {
    final combined = subPhrase != null && subPhrase.isNotEmpty
        ? '$phrase $subPhrase'
        : phrase;
    return validate(combined, language, isFirstInsight: isFirstInsight);
  }

  /// Kembalikan teks fallback yang selalu valid.
  static String getFallback(LumaLanguage language) {
    return language == LumaLanguage.indonesian
        ? 'Hari ini berjalan dengan ritmenya sendiri.'
        : 'Today moved at its own rhythm.';
  }

  /// Sanitize best-effort: ganti forbidden words dengan frasa netral.
  /// Gunakan hanya sebagai last resort — lebih baik pakai fallback.
  static String sanitize(String text, LumaLanguage language) {
    final forbidden =
        language == LumaLanguage.indonesian ? _forbiddenId : _forbiddenEn;
    String result = text;
    for (final word in forbidden) {
      final pattern = RegExp(RegExp.escape(word), caseSensitive: false);
      result = result.replaceAll(
        pattern,
        language == LumaLanguage.indonesian ? 'terlihat' : 'appears to',
      );
    }
    return result;
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static List<String> _splitSentences(String text) {
    if (text.trim().isEmpty) return [];
    // Split pada . ! ? yang diikuti spasi atau akhir string
    final parts = text.trim().split(RegExp(r'(?<=[.!?])\s+'));
    return parts.where((s) => s.trim().isNotEmpty).toList();
  }

  static bool _hasObservationalOpener(String text, LumaLanguage language) {
    final openers = language == LumaLanguage.indonesian
        ? const [
            'hari ini', 'ada ', 'terlihat', 'pola', 'ritme', 'layar',
            'pikiran', 'malam', 'pagi', 'aktivitas', 'waktu',
          ]
        : const [
            'today', 'there', 'the screen', 'the mind', 'tonight',
            'this morning', 'activity', 'time', 'a pattern', 'the rhythm',
          ];
    final lower = text.toLowerCase();
    return openers.any((o) => lower.startsWith(o));
  }
}

// ─── Result types ──────────────────────────────────────────────────────────

class NVCValidationResult {
  final bool isValid;
  final List<NVCIssue> issues;
  final bool hasObservationalOpener;
  final int sentenceCount;

  const NVCValidationResult({
    required this.isValid,
    required this.issues,
    required this.hasObservationalOpener,
    required this.sentenceCount,
  });

  List<NVCIssue> get blockingIssues =>
      issues.where((i) => i.severity == NVCIssueSeverity.blocking).toList();

  List<NVCIssue> get warnings =>
      issues.where((i) => i.severity == NVCIssueSeverity.warning).toList();

  @override
  String toString() =>
      'NVCValidationResult(valid=$isValid, sentences=$sentenceCount, '
      'issues=${issues.length})';
}

class NVCIssue {
  final NVCRule rule;
  final String detail;
  final NVCIssueSeverity severity;

  const NVCIssue({
    required this.rule,
    required this.detail,
    required this.severity,
  });
}

enum NVCRule {
  forbiddenWord,
  absoluteNumber,
  imperativeSentence,
  tooLong,
  missingObservationalOpener,
}

enum NVCIssueSeverity {
  /// Insight tidak boleh ditampilkan — harus diganti fallback
  blocking,

  /// Insight boleh ditampilkan tapi perlu perhatian
  warning,
}
