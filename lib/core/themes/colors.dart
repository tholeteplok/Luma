import 'package:flutter/material.dart';

/// Luma Color System — Sesuai visual_prototype_dark.html
///
/// Filosofi: Tidak ada warna yang menghakimi.
/// Warna hanya mencerminkan state, bukan nilai baik/buruk.
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

  // ── Legacy Aliases (backward compat, hindari penggunaan baru) ─────
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
