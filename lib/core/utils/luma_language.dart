/// LumaLanguage — Supported languages for the app
///
/// Each language has its own InsightRenderer that maintains
/// the "soul" of Luma across cultures.
/// This is NOT translation — this is cultural emotional adaptation.
library;

enum LumaLanguage {
  indonesian('id', 'Bahasa Indonesia'),
  english('en', 'English');

  final String code;
  final String displayName;

  const LumaLanguage(this.code, this.displayName);

  /// Get language from code string (e.g., 'id' → indonesian)
  static LumaLanguage fromCode(String code) {
    return values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => indonesian,
    );
  }

  /// Get language from system locale
  static LumaLanguage fromLocale(String? localeCode) {
    if (localeCode == null) return indonesian;
    if (localeCode.startsWith('id')) return indonesian;
    if (localeCode.startsWith('en')) return english;
    return indonesian; // Default to Indonesian
  }

  /// Check if language is RTL (right-to-left)
  /// Currently all supported languages are LTR
  bool get isRTL => false;

  @override
  String toString() => displayName;
}
