import 'package:flutter/material.dart';

/// Luma Color System
///
/// Palette: Emerald & Gold (Bioluminescence + Mineral)
/// Referensi: #EEE8B2, #C18D52, #081B1B, #203B37, #5A8F76, #96CDB0
///
/// Filosofi: Tidak ada warna yang menghakimi.
/// Warna hanya mencerminkan state, bukan nilai baik/buruk.
class AppColors {
  AppColors._();

  // ── Background Layer ──────────────────────────────────────────────
  static const Color bgBase     = Color(0xFF081B1B); // #081B1B — laut dalam
  static const Color bgSurface  = Color(0xFF0F2626); // sedikit lebih terang
  static const Color bgElevated = Color(0xFF162E2E);
  static const Color bgSubtle   = Color(0xFF1C3535);

  // ── Border ────────────────────────────────────────────────────────
  static const Color borderFaint  = Color(0xFF1E3030);
  static const Color borderSubtle = Color(0xFF203B37); // #203B37
  static const Color borderMedium = Color(0xFF2A4A44);

  // ── Text ──────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFEEE8B2); // #EEE8B2 — krem keemasan
  static const Color textSecondary = Color(0xFFB8C4A8);
  static const Color textTertiary  = Color(0xFF7A9A8A);
  static const Color textSubtle    = Color(0xFF4A6A5A);

  // ── Accent (core brand) — gold-teal ──────────────────────────────
  static const Color accent      = Color(0xFF5A8F76); // #5A8F76
  static const Color accentLight = Color(0xFF96CDB0); // #96CDB0
  static const Color accentMuted = Color(0xFF1E3D32);

  // ── Semantic Insight Colors ───────────────────────────────────────
  static const Color infoText = Color(0xFF96CDB0); // teal terang
  static const Color infoInd  = Color(0xFF203B37);

  static const Color noticeText = Color(0xFFC18D52); // #C18D52 — gold
  static const Color noticeInd  = Color(0xFF6B4A20);

  static const Color gentleText = Color(0xFF96CDB0); // #96CDB0
  static const Color gentleInd  = Color(0xFF203B37); // #203B37

  static const Color warnText = Color(0xFFC18D52); // gold-amber, bukan merah
  static const Color warnInd  = Color(0xFF5A3A10);

  // ── Ambient / Timeline Encoding ───────────────────────────────────
  static const Color encodeFocus       = Color(0xFF5A8F76);
  static const Color encodeMiddle      = Color(0xFF203B37);
  static const Color encodeDistraction = Color(0xFF3A5A4A);
  static const Color encodeRest        = Color(0xFF0F2020);

  // ── Fade Granularity Opacity ──────────────────────────────────────
  static const double opacitySharp      = 1.00;
  static const double opacityDim        = 0.85;
  static const double opacityBlurry     = 0.65;
  static const double opacitySilhouette = 0.45;

  // ── Legacy Aliases ────────────────────────────────────────────────
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
  static const Color success  = gentleText;
  static const Color error    = warnText;
  static const Color disabled = textTertiary;
}

// ─────────────────────────────────────────────────────────────────────────────
//  THEME-AWARE PALETTE
// ─────────────────────────────────────────────────────────────────────────────

/// LumaPalette — Token warna Luma yang reaktif terhadap brightness.
///
/// Dark mode: Emerald laut dalam (#081B1B base) + gold (#C18D52 accent)
/// Light mode: Krem keemasan (#EEE8B2 base) + emerald (#203B37 accent)
class LumaPalette extends ThemeExtension<LumaPalette> {
  final Color bgBase;
  final Color bgSurface;
  final Color bgElevated;
  final Color bgSubtle;
  final Color borderFaint;
  final Color borderSubtle;
  final Color borderMedium;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textSubtle;
  final Color accent;
  final Color accentLight;
  final Color accentMuted;
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

  // ── DARK MODE — Emerald laut dalam ────────────────────────────────
  static const LumaPalette dark = LumaPalette(
    bgBase:     Color(0xFF081B1B), // #081B1B — laut dalam
    bgSurface:  Color(0xFF0F2626),
    bgElevated: Color(0xFF162E2E),
    bgSubtle:   Color(0xFF1C3535),
    borderFaint:  Color(0xFF1E3030),
    borderSubtle: Color(0xFF203B37), // #203B37
    borderMedium: Color(0xFF2A4A44),
    textPrimary:   Color(0xFFEEE8B2), // #EEE8B2 — krem keemasan
    textSecondary: Color(0xFFB8C4A8),
    textTertiary:  Color(0xFF7A9A8A),
    textSubtle:    Color(0xFF4A6A5A),
    accent:      Color(0xFF5A8F76), // #5A8F76
    accentLight: Color(0xFF96CDB0), // #96CDB0
    accentMuted: Color(0xFF1E3D32),
    infoText:   Color(0xFF96CDB0),
    infoInd:    Color(0xFF203B37),
    infoBadgeBg: Color(0xFF0C2020),
    noticeText:   Color(0xFFC18D52), // #C18D52 — gold
    noticeInd:    Color(0xFF6B4A20),
    noticeBadgeBg: Color(0xFF1A1008),
    gentleText:   Color(0xFF96CDB0),
    gentleInd:    Color(0xFF203B37),
    gentleBadgeBg: Color(0xFF0C2020),
    warnText:   Color(0xFFC18D52), // gold-amber, bukan merah
    warnInd:    Color(0xFF5A3A10),
    warnBadgeBg: Color(0xFF1A1005),
  );

  // ── LIGHT MODE — Krem keemasan ────────────────────────────────────
  static const LumaPalette light = LumaPalette(
    bgBase:     Color(0xFFF5F2E8), // krem hangat dari #EEE8B2
    bgSurface:  Color(0xFFFFFFFA),
    bgElevated: Color(0xFFF8F5EC),
    bgSubtle:   Color(0xFFEDE8D8),
    borderFaint:  Color(0xFFDDD8C4),
    borderSubtle: Color(0xFFC8C0A0),
    borderMedium: Color(0xFFB0A880),
    textPrimary:   Color(0xFF081B1B), // #081B1B — gelap di atas terang
    textSecondary: Color(0xFF203B37), // #203B37
    textTertiary:  Color(0xFF4A6A5A),
    textSubtle:    Color(0xFF8A9A8A),
    accent:      Color(0xFF203B37), // #203B37 — emerald gelap
    accentLight: Color(0xFF5A8F76), // #5A8F76
    accentMuted: Color(0xFFD0E8DC),
    infoText:   Color(0xFF203B37),
    infoInd:    Color(0xFF5A8F76),
    infoBadgeBg: Color(0xFFE0F0E8),
    noticeText:   Color(0xFF6B4A20),
    noticeInd:    Color(0xFFC18D52),
    noticeBadgeBg: Color(0xFFF5E8D0),
    gentleText:   Color(0xFF203B37),
    gentleInd:    Color(0xFF5A8F76),
    gentleBadgeBg: Color(0xFFE0F0E8),
    warnText:   Color(0xFF5A3A10),
    warnInd:    Color(0xFFC18D52),
    warnBadgeBg: Color(0xFFF5E0C0),
  );

  @override
  LumaPalette copyWith({
    Color? bgBase, Color? bgSurface, Color? bgElevated, Color? bgSubtle,
    Color? borderFaint, Color? borderSubtle, Color? borderMedium,
    Color? textPrimary, Color? textSecondary, Color? textTertiary, Color? textSubtle,
    Color? accent, Color? accentLight, Color? accentMuted,
    Color? infoText, Color? infoInd, Color? infoBadgeBg,
    Color? noticeText, Color? noticeInd, Color? noticeBadgeBg,
    Color? gentleText, Color? gentleInd, Color? gentleBadgeBg,
    Color? warnText, Color? warnInd, Color? warnBadgeBg,
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

extension LumaPaletteContext on BuildContext {
  LumaPalette get luma =>
      Theme.of(this).extension<LumaPalette>() ?? LumaPalette.dark;
}
