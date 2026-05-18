// lib/config/typography.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LumaTypography {
  // DISPLAY — Cormorant Garamond
  static TextStyle get displayLarge => GoogleFonts.cormorantGaramond(
    fontSize: 48,
    fontWeight: FontWeight.w300,
    height: 1.1,
    letterSpacing: -0.5,
    color: LumaColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.cormorantGaramond(
    fontSize: 36,
    fontWeight: FontWeight.w300,
    height: 1.2,
    letterSpacing: -0.3,
    color: LumaColors.textPrimary,
  );

  // HEADLINE — DM Sans
  static TextStyle get headlineLarge => GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.2,
    color: LumaColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: LumaColors.textPrimary,
  );

  static TextStyle get headlineSmall => GoogleFonts.dmSans(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: LumaColors.textPrimary,
  );

  // BODY — DM Sans
  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: LumaColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: LumaColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: LumaColors.textTertiary,
  );

  // INSIGHT TEXT — Cormorant Garamond (spesial untuk insight)
  static TextStyle get insightText => GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.1,
    color: LumaColors.textPrimary,
  );

  static TextStyle get insightTextItalic => GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.6,
    letterSpacing: 0.1,
    color: LumaColors.textSecondary,
  );

  // LABEL — DM Sans
  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.8,
    color: LumaColors.textTertiary,
  );

  static TextStyle get labelMedium => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.6,
    color: LumaColors.textTertiary,
  );

  // DATA / MONO — JetBrains Mono
  static TextStyle get dataLarge => GoogleFonts.jetBrainsMono(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: LumaColors.textPrimary,
  );

  static TextStyle get dataMedium => GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: LumaColors.textSecondary,
  );

  static TextStyle get dataSmall => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: LumaColors.textTertiary,
  );

  // WAITING ROOM TEXT (special, slow fade)
  static TextStyle get waitingRoomText => GoogleFonts.cormorantGaramond(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    height: 1.7,
    letterSpacing: 0.2,
    color: LumaColors.textSubtle,
  );
}