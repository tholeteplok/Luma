import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// AppTheme — Tema visual Luma
///
/// Menggunakan color tokens dari AppColors (sesuai visual_prototype_dark.html).
/// Base font: DM Sans. Insight text: Cormorant Garamond (diterapkan di widget).
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgBase,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentLight,
        surface: AppColors.bgSurface,
        error: AppColors.warnText,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
        outline: AppColors.borderSubtle,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgBase,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderFaint,
        thickness: 1,
        space: 0,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 12,
          color: AppColors.textTertiary,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentMuted,
          foregroundColor: AppColors.accentLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.borderSubtle),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderFaint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        labelStyle: GoogleFonts.dmSans(color: AppColors.textTertiary),
        hintStyle: GoogleFonts.dmSans(color: AppColors.textSubtle),
      ),
    );
  }

  /// Light theme — versi terang (opsional, sama token, brightness berbeda)
  static ThemeData get lightTheme {
    // Luma dark-first. Light mode menggunakan surface yang lebih terang.
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF4F4F8),
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.accentLight,
        surface: Colors.white,
        error: AppColors.warnText,
        onPrimary: Colors.white,
        onSurface: Color(0xFF1A1A2E),
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme),
    );
  }

  /// Severity indicator color (untuk backward compat)
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return AppColors.warnInd;
      case 'notice':
        return AppColors.noticeInd;
      case 'gentle':
      case 'positive':
        return AppColors.gentleInd;
      case 'info':
      default:
        return AppColors.infoInd;
    }
  }
}
