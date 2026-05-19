import 'luma_language.dart';

/// NVCValidator — Validator tone untuk insight Luma
///
/// NVC (Non-Violent Communication) dalam konteks Luma berarti:
/// - Observasi, bukan penilaian ("Luma mencatat..." bukan "Kamu lalai...")
/// - Fakta, bukan asumsi ("Layar aktif 3.5 jam" bukan "Kamu kecanduan")
/// - Maks 2 kalimat per insight
/// - Hindari kata-kata yang menghakimi, mendesak, atau menimbulkan rasa malu
///
/// Luma tidak pernah menghakimi. Luma hanya mencerminkan.
class NVCValidator {
  // ─── Forbidden words per language ───

  static const _forbiddenId = [
    'harus', 'seharusnya', 'wajib', 'jangan',
    'buruk', 'gagal', 'salah', 'malas', 'bodoh',
    'tidak produktif', 'kecanduan', 'buang waktu',
    'sia-sia', 'payah', 'lemah', 'malu',
    'tidak disiplin', 'tidak bisa', 'tidak mampu',
  ];

  static const _forbiddenEn = [
    'should', 'must', 'have to', 'need to',
    'bad', 'failed', 'failure', 'lazy', 'stupid',
    'unproductive', 'addicted', 'wasting time',
    'pointless', 'weak', 'shameful',
    'undisciplined', 'cannot', 'unable',
    'you never', 'you always',
  ];

  // ─── Compassion phrases (observational, not judgmental) ───

  static const _compassionPhrasesId = [
    'Luma mencatat',
    'Terlihat bahwa',
    'Pola menunjukkan',
    'Hari ini',
    'Dalam seminggu terakhir',
    'Rata-rata',
  ];

  static const _compassionPhrasesEn = [
    'Luma noticed',
    'It appears',
    'The pattern shows',
    'Today',
    'Over the past week',
    'On average',
  ];

  /// Validasi apakah teks sesuai NVC guidelines
  static NVCValidationResult validate(
    String text,
    LumaLanguage language,
  ) {
    final issues = <String>[];

    // 1. Cek panjang (maks 2 kalimat)
    final sentences = _countSentences(text);
    if (sentences > 2) {
      issues.add(language == LumaLanguage.indonesian
          ? 'Terlalu panjang. Maksimal 2 kalimat.'
          : 'Too long. Maximum 2 sentences.');
    }

    // 2. Cek forbidden words
    final forbidden = language == LumaLanguage.indonesian
        ? _forbiddenId
        : _forbiddenEn;

    final foundForbidden = <String>[];
    final lowerText = text.toLowerCase();
    for (final word in forbidden) {
      if (lowerText.contains(word.toLowerCase())) {
        foundForbidden.add(word);
      }
    }

    if (foundForbidden.isNotEmpty) {
      issues.add(language == LumaLanguage.indonesian
          ? 'Hindari kata-kata: ${foundForbidden.join(", ")}.'
          : 'Avoid words: ${foundForbidden.join(", ")}.');
    }

    // 3. Cek apakah dimulai dengan observational phrase (opsional, warning saja)
    final compassion = language == LumaLanguage.indonesian
        ? _compassionPhrasesId
        : _compassionPhrasesEn;

    final hasCompassionOpener = compassion.any(
      (phrase) => text.startsWith(phrase),
    );

    return NVCValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
      hasObservationalOpener: hasCompassionOpener,
      sentenceCount: sentences,
    );
  }

  /// Return fallback message yang selalu NVC-compliant
  static String getFallbackMessage(LumaLanguage language) {
    return language == LumaLanguage.indonesian
        ? 'Luma mencatat pola aktivitas hari ini.'
        : 'Luma noticed your activity pattern today.';
  }

  /// Sanitize teks dengan mengganti forbidden words (best-effort)
  static String sanitize(String text, LumaLanguage language) {
    final forbidden = language == LumaLanguage.indonesian
        ? _forbiddenId
        : _forbiddenEn;

    String result = text;
    for (final word in forbidden) {
      // Ganti dengan frasa netral (hanya lowercase match)
      final pattern = RegExp(RegExp.escape(word), caseSensitive: false);
      if (language == LumaLanguage.indonesian) {
        result = result.replaceAll(pattern, 'terlihat');
      } else {
        result = result.replaceAll(pattern, 'appears to');
      }
    }
    return result;
  }

  /// Hitung jumlah kalimat dalam teks
  static int _countSentences(String text) {
    if (text.trim().isEmpty) return 0;
    // Split berdasarkan . ! ? yang diikuti spasi atau akhir string
    final pattern = RegExp(r'[.!?]+(?:\s|$)');
    final matches = pattern.allMatches(text.trim());
    final count = matches.length;
    // Jika tidak ada tanda baca kalimat, anggap satu kalimat
    return count == 0 ? 1 : count;
  }
}

/// Hasil validasi NVC
class NVCValidationResult {
  final bool isValid;
  final List<String> issues;
  final bool hasObservationalOpener;
  final int sentenceCount;

  const NVCValidationResult({
    required this.isValid,
    required this.issues,
    required this.hasObservationalOpener,
    required this.sentenceCount,
  });

  @override
  String toString() {
    return 'NVCValidationResult(valid=$isValid, sentences=$sentenceCount, '
        'issues=$issues, observational=$hasObservationalOpener)';
  }
}
