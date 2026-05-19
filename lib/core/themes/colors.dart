import 'package:flutter/material.dart';

/// Luma Color System — Sesuai visual_prototype_dark.html
///
/// Filosofi: Tidak ada warna yang menghakimi.
/// Warna hanya mencerminkan state, bukan nilai baik/buruk.
///
/// Cara baru (theme-aware): pakai `context.luma.bgBase` dst.
/// `AppColors.X` tetap dipertahankan untuk backward compatibility,
/// tetapi nilainya hanya cocok untuk dark mode. Migrasikan secara bertahap.
class AppColors {
  AppColors._();

  // ── Background Layer ──────────────────────────────────────────────
  /// Warna dasar paling dalam
  static const Color bgBase     = Color(0xFF0C0C14);
  /// Surface card, panel
  static const Color bgSurface  = Color(0xFF12121E);
  /// Elevated element (dialog, tooltip)
  static const Color bgElevated = Color(0xFF191927);
  /// Subtle background (detail card, form)
  static const Color bgSubtle   = Color(0xFF1E1E30);

  // ── Border ────────────────────────────────────────────────────────
  static const Color borderFaint  = Color(0xFF1F1F32);
  static const Color borderSubtle = Color(0xFF2A2A42);
  static const Color borderMedium = Color(0xFF363654);

  // ── Text ──────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFE8E8F2);
  static const Color textSecondary = Color(0xFFB4B4CC);
  static const Color textTertiary  = Color(0xFF7A7A96);
  static const Color textSubtle    = Color(0xFF4A4A68);

  // ── Accent (core brand) ───────────────────────────────────────────
  static const Color accent      = Color(0xFF6B6BCA);
  static const Color accentLight = Color(0xFF8A8ADA);
  static const Color accentMuted = Color(0xFF3D3D7A);

  // ── Semantic Insight Colors (Indicator only, bukan fill warna) ───
  /// Info — observasi netral
  static const Color infoText = Color(0xFF7B9FD4);
  static const Color infoInd  = Color(0xFF3A5A8A);

  /// Notice — perhatian lembut
  static const Color noticeText = Color(0xFFC4944A);
  static const Color noticeInd  = Color(0xFF7A5220);

  /// Gentle — self-compassion, pola positif
  static const Color gentleText = Color(0xFF6BA896);
  static const Color gentleInd  = Color(0xFF2E5A50);

  /// Warning — anomali, perlu perhatian (tanpa menghakimi)
  static const Color warnText = Color(0xFFB87066);
  static const Color warnInd  = Color(0xFF6A3028);

  // ── Ambient / Timeline Encoding ───────────────────────────────────
  /// Warna untuk representasi fokus di timeline (bukan label)
  static const Color encodeFocus      = Color(0xFF6B8FCA);
  /// Warna transisi / medium
  static const Color encodeMiddle     = Color(0xFF3D3D7A);
  /// Warna untuk distraksi di timeline
  static const Color encodeDistraction = Color(0xFF8A6B8A);
  /// Rest / idle
  static const Color encodeRest       = Color(0xFF2A2A3E);

  // ── Fade Granularity Opacity ──────────────────────────────────────
  static const double opacitySharp      = 1.00;  // 0–7 hari
  static const double opacityDim        = 0.85;  // 8–14 hari
  static const double opacityBlurry     = 0.65;  // 15–28 hari
  static const double opacitySilhouette = 0.45;  // 28+ hari

  // ── Legacy Aliases (backward compat) ──────────────────────────────
  @Deprecated('Gunakan AppColors.bgBase')
  static const Color backgroundDark = bgBase;
  @Deprecated('Gunakan AppColors.bgSurface')
  static const Color surfaceDark = bgSurface;
  @Deprecated('Gunakan AppColors.textPrimary')
  static const Color textDarkPrimary = textPrimary;
  @Deprecated('Gunakan AppColors.textSecondary')
  static const Color textDarkSecondary = textSecondary;
  @Deprecated('Gunakan AppColors.borderSubtle')
  static const Color borderDark = borderSubtle;
  @Deprecated('Gunakan AppColors.accent')
  static const Color primaryDark = accent;
  @Deprecated('Gunakan AppColors.accentLight')
  static const Color primaryLight = accentLight;
  @Deprecated('Gunakan AppColors.warnText')
  static const Color critical = warnText;
  @Deprecated('Gunakan AppColors.noticeText')
  static const Color warning = noticeText;
  @Deprecated('Gunakan AppColors.gentleText')
  static const Color positive = gentleText;
  @Deprecated('Gunakan AppColors.infoText')
  static const Color info = infoText;
  static const Color success = gentleText;
  static const Color error   = warnText;
  static const Color disabled = textTertiary;
}

// ─────────────────────────────────────────────────────────────────────────────
//  THEME-AWARE PALETTE  (ThemeExtension)
// ─────────────────────────────────────────────────────────────────────────────

/// LumaPalette — Token warna Luma yang reaktif terhadap brightness.
///
/// Akses via `context.luma` (lihat extension di bawah) atau
/// `Theme.of(context).extension<LumaPalette>()`.
///
/// Kenapa pakai ThemeExtension dan bukan dua kelas warna terpisah?
/// - Material 3 mendukung lerp otomatis saat transisi tema (animasi halus)
/// - Sekali deklarasi di `app_theme.dart`, semua widget anak otomatis dapat
class LumaPalette extends ThemeExtension<LumaPalette> {
  // Backgrounds
  final Color bgBase;
  final Color bgSurface;
  final Color bgElevated;
  final Color bgSubtle;

  // Borders
  final Color borderFaint;
  final Color borderSubtle;
  final Color borderMedium;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textSubtle;

  // Accent
  final Color accent;
  final Color accentLight;
  final Color accentMuted;

  // Semantic indicators (slot warna untuk badge / left-bar di insight card)
  final Color infoText;
  final Color infoInd;
  final Color infoBadgeBg;
  final Color noticeText;
  final Color noticeInd;
  final Color noticeBadgeBg;
  final Color gentleText;
  final Color gentleInd;
  final Color gentleBadgeBg;
  final Color warnText;
  final Color warnInd;
  final Color warnBadgeBg;

  const LumaPalette({
    required this.bgBase,
    required this.bgSurface,
    required this.bgElevated,
    required this.bgSubtle,
    required this.borderFaint,
    required this.borderSubtle,
    required this.borderMedium,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textSubtle,
    required this.accent,
    required this.accentLight,
    required this.accentMuted,
    required this.infoText,
    required this.infoInd,
    required this.infoBadgeBg,
    required this.noticeText,
    required this.noticeInd,
    required this.noticeBadgeBg,
    required this.gentleText,
    required this.gentleInd,
    required this.gentleBadgeBg,
    required this.warnText,
    required this.warnInd,
    required this.warnBadgeBg,
  });

  /// Palette untuk dark mode — sumber kebenaran utama (sesuai visual_prototype_dark.html)
  static const LumaPalette dark = LumaPalette(
    bgBase: Color(0xFF0C0C14),
    bgSurface: Color(0xFF12121E),
    bgElevated: Color(0xFF191927),
    bgSubtle: Color(0xFF1E1E30),
    borderFaint: Color(0xFF1F1F32),
    borderSubtle: Color(0xFF2A2A42),
    borderMedium: Color(0xFF363654),
    textPrimary: Color(0xFFE8E8F2),
    textSecondary: Color(0xFFB4B4CC),
    textTertiary: Color(0xFF7A7A96),
    textSubtle: Color(0xFF4A4A68),
    accent: Color(0xFF6B6BCA),
    accentLight: Color(0xFF8A8ADA),
    accentMuted: Color(0xFF3D3D7A),
    infoText: Color(0xFF7B9FD4),
    infoInd: Color(0xFF3A5A8A),
    infoBadgeBg: Color(0xFF0E1420),
    noticeText: Color(0xFFC4944A),
    noticeInd: Color(0xFF7A5220),
    noticeBadgeBg: Color(0xFF1A1008),
    gentleText: Color(0xFF6BA896),
    gentleInd: Color(0xFF2E5A50),
    gentleBadgeBg: Color(0xFF101E1B),
    warnText: Color(0xFFB87066),
    warnInd: Color(0xFF6A3028),
    warnBadgeBg: Color(0xFF1E1010),
  );

  /// Palette untuk light mode — versi pagi yang halus, tetap intim, tidak silau
  static const LumaPalette light = LumaPalette(
    bgBase: Color(0xFFF6F5F2),     // off-white hangat
    bgSurface: Color(0xFFFFFFFF),  // putih bersih untuk card
    bgElevated: Color(0xFFFAF9F5), // sedikit lebih terang dari surface
    bgSubtle: Color(0xFFEDECE7),   // subtle backdrop
    borderFaint: Color(0xFFE8E6E0),
    borderSubtle: Color(0xFFD8D5CC),
    borderMedium: Color(0xFFC2BFB4),
    textPrimary: Color(0xFF1A1A2E),
    textSecondary: Color(0xFF45455A),
    textTertiary: Color(0xFF7A7A8E),
    textSubtle: Color(0xFFA8A8B8),
    accent: Color(0xFF5454B8),
    accentLight: Color(0xFF6B6BCA),
    accentMuted: Color(0xFFE0E0F2),
    infoText: Color(0xFF3A5A8A),
    infoInd: Color(0xFF7B9FD4),
    infoBadgeBg: Color(0xFFEAF0FA),
    noticeText: Color(0xFF7A5220),
    noticeInd: Color(0xFFC4944A),
    noticeBadgeBg: Color(0xFFFAF1E2),
    gentleText: Color(0xFF2E5A50),
    gentleInd: Color(0xFF6BA896),
    gentleBadgeBg: Color(0xFFE6F1ED),
    warnText: Color(0xFF8A3A30),
    warnInd: Color(0xFFB87066),
    warnBadgeBg: Color(0xFFFAEAE7),
  );

  @override
  LumaPalette copyWith({
    Color? bgBase,
    Color? bgSurface,
    Color? bgElevated,
    Color? bgSubtle,
    Color? borderFaint,
    Color? borderSubtle,
    Color? borderMedium,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textSubtle,
    Color? accent,
    Color? accentLight,
    Color? accentMuted,
    Color? infoText,
    Color? infoInd,
    Color? infoBadgeBg,
    Color? noticeText,
    Color? noticeInd,
    Color? noticeBadgeBg,
    Color? gentleText,
    Color? gentleInd,
    Color? gentleBadgeBg,
    Color? warnText,
    Color? warnInd,
    Color? warnBadgeBg,
  }) {
    return LumaPalette(
      bgBase: bgBase ?? this.bgBase,
      bgSurface: bgSurface ?? this.bgSurface,
      bgElevated: bgElevated ?? this.bgElevated,
      bgSubtle: bgSubtle ?? this.bgSubtle,
      borderFaint: borderFaint ?? this.borderFaint,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderMedium: borderMedium ?? this.borderMedium,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textSubtle: textSubtle ?? this.textSubtle,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      accentMuted: accentMuted ?? this.accentMuted,
      infoText: infoText ?? this.infoText,
      infoInd: infoInd ?? this.infoInd,
      infoBadgeBg: infoBadgeBg ?? this.infoBadgeBg,
      noticeText: noticeText ?? this.noticeText,
      noticeInd: noticeInd ?? this.noticeInd,
      noticeBadgeBg: noticeBadgeBg ?? this.noticeBadgeBg,
      gentleText: gentleText ?? this.gentleText,
      gentleInd: gentleInd ?? this.gentleInd,
      gentleBadgeBg: gentleBadgeBg ?? this.gentleBadgeBg,
      warnText: warnText ?? this.warnText,
      warnInd: warnInd ?? this.warnInd,
      warnBadgeBg: warnBadgeBg ?? this.warnBadgeBg,
    );
  }

  @override
  LumaPalette lerp(ThemeExtension<LumaPalette>? other, double t) {
    if (other is! LumaPalette) return this;
    return LumaPalette(
      bgBase: Color.lerp(bgBase, other.bgBase, t)!,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      bgSubtle: Color.lerp(bgSubtle, other.bgSubtle, t)!,
      borderFaint: Color.lerp(borderFaint, other.borderFaint, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderMedium: Color.lerp(borderMedium, other.borderMedium, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      infoText: Color.lerp(infoText, other.infoText, t)!,
      infoInd: Color.lerp(infoInd, other.infoInd, t)!,
      infoBadgeBg: Color.lerp(infoBadgeBg, other.infoBadgeBg, t)!,
      noticeText: Color.lerp(noticeText, other.noticeText, t)!,
      noticeInd: Color.lerp(noticeInd, other.noticeInd, t)!,
      noticeBadgeBg: Color.lerp(noticeBadgeBg, other.noticeBadgeBg, t)!,
      gentleText: Color.lerp(gentleText, other.gentleText, t)!,
      gentleInd: Color.lerp(gentleInd, other.gentleInd, t)!,
      gentleBadgeBg: Color.lerp(gentleBadgeBg, other.gentleBadgeBg, t)!,
      warnText: Color.lerp(warnText, other.warnText, t)!,
      warnInd: Color.lerp(warnInd, other.warnInd, t)!,
      warnBadgeBg: Color.lerp(warnBadgeBg, other.warnBadgeBg, t)!,
    );
  }
}

/// Shortcut: `context.luma.bgBase` daripada `Theme.of(context).extension<LumaPalette>()!.bgBase`
extension LumaPaletteContext on BuildContext {
  LumaPalette get luma =>
      Theme.of(this).extension<LumaPalette>() ?? LumaPalette.dark;
}
