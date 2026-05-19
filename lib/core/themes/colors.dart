import 'package:flutter/material.dart';

/// Semantic color palette untuk Luma
/// Menggunakan pendekatan severity-based untuk insight dan status
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primaryDark = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF60A5FA);

  // Background colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFFF8FAFC);

  // Text colors
  static const Color textDarkPrimary = Color(0xFFE2E8F0);
  static const Color textDarkSecondary = Color(0xFF94A3B8);
  
  static const Color textLightPrimary = Color(0xFF1E293B);
  static const Color textLightSecondary = Color(0xFF64748B);

  // Severity colors (untuk insight)
  static const Color critical = Color(0xFFEF4444);    // Merah - Warning level tinggi
  static const Color warning = Color(0xFFF59E0B);     // Orange - Notice level
  static const Color positive = Color(0xFF10B981);    // Hijau - Gentle/Positive
  static const Color info = Color(0xFF3B82F6);        // Biru - Info level

  // Fade granularity opacity levels
  static const double opacitySharp = 1.0;      // 0-7 hari
  static const double opacityDim = 0.85;       // 8-14 hari
  static const double opacityBlurry = 0.65;    // 15-28 hari
  static const double opacitySilhouette = 0.45; // 28+ hari

  // Border colors
  static const Color borderDark = Color(0xFF334155);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Utility colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color disabled = Color(0xFF94A3B8);
}
