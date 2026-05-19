import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// AppTheme — Tema visual Luma untuk dark & light mode.
///
/// Sumber kebenaran warna ada di [LumaPalette] (ThemeExtension).
/// Widget yang bersih theme-aware: `context.luma.bgBase`.
/// Widget legacy: `AppColors.X` (hanya cocok untuk dark, akan di-migrate bertahap).
class AppTheme {
  AppTheme._();

  // ──────────────────────────────────────────────────────────────────
  // DARK THEME
  // ──────────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return _buildTheme(brightness: Brightness.dark, palette: LumaPalette.dark);
  }

  // ──────────────────────────────────────────────────────────────────
  // LIGHT THEME
  // ──────────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return _buildTheme(brightness: Brightness.light, palette: LumaPalette.light);
  }

  // ──────────────────────────────────────────────────────────────────
  // SHARED BUILDER — satu sumber, dua brightness
  // ──────────────────────────────────────────────────────────────────
  static ThemeData _buildTheme({
    required Brightness brightness,
    required LumaPalette palette,
  }) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final colorScheme = brightness == Brightness.dark
        ? ColorScheme.dark(
            primary: palette.accent,
            secondary: palette.accentLight,
            surface: palette.bgSurface,
            error: palette.warnText,
            onPrimary: palette.textPrimary,
            onSecondary: palette.textPrimary,
            onSurface: palette.textPrimary,
            onError: palette.textPrimary,
            outline: palette.borderSubtle,
          )
        : ColorScheme.light(
            primary: palette.accent,
            secondary: palette.accentLight,
            surface: palette.bgSurface,
            error: palette.warnText,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: palette.textPrimary,
            onError: Colors.white,
            outline: palette.borderSubtle,
          );

    return base.copyWith(
      brightness: brightness,
      scaffoldBackgroundColor: palette.bgBase,
      primaryColor: palette.accent,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[palette],
      appBarTheme: AppBarTheme(
        backgroundColor: palette.bgBase,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: palette.bgSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.borderFaint,
        thickness: 1,
        space: 0,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          color: palette.textPrimary,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          color: palette.textSecondary,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 12,
          color: palette.textTertiary,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: palette.textPrimary,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: palette.textPrimary,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: palette.textTertiary,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.accentMuted,
          foregroundColor: palette.accentLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textSecondary,
          side: BorderSide(color: palette.borderSubtle),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.bgElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.borderFaint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.accent),
        ),
        labelStyle: GoogleFonts.dmSans(color: palette.textTertiary),
        hintStyle: GoogleFonts.dmSans(color: palette.textSubtle),
      ),
    );
  }

  /// Severity indicator color (theme-aware).
  /// Pakai ini di painter / komponen yang tidak punya akses langsung ke palette.
  static Color getSeverityColor(BuildContext context, String severity) {
    final p = context.luma;
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return p.warnInd;
      case 'notice':
        return p.noticeInd;
      case 'gentle':
      case 'positive':
        return p.gentleInd;
      case 'info':
      default:
        return p.infoInd;
    }
  }
}
