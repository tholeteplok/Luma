// lib/config/design_tokens.dart

import 'package:flutter/material.dart';

class LumaTokens {
  // ─── SPACING ───────────────────────────────────────
  static const double spaceXxs = 4.0;
  static const double spaceXs  = 8.0;
  static const double spaceSm  = 12.0;
  static const double spaceMd  = 16.0;
  static const double spaceLg  = 24.0;
  static const double spaceXl  = 32.0;
  static const double spaceXxl = 48.0;
  static const double space3xl = 64.0;
  static const double space4xl = 96.0;

  // ─── BORDER RADIUS ──────────────────────────────────
  static const double radiusXs  = 4.0;
  static const double radiusSm  = 8.0;
  static const double radiusMd  = 12.0;
  static const double radiusLg  = 16.0;
  static const double radiusXl  = 24.0;
  static const double radiusFull = 999.0;

  // ─── ELEVATION / SHADOW ─────────────────────────────
  static const double elevationSm = 4.0;
  static const double elevationMd = 8.0;
  static const double elevationLg = 16.0;

  // ─── OPACITY ────────────────────────────────────────
  static const double opacityDisabled  = 0.38;
  static const double opacitySubtle    = 0.54;
  static const double opacityMedium   = 0.72;
  static const double opacityHigh     = 0.87;
  static const double opacityFull     = 1.0;

  // ─── ANIMATION DURATION ─────────────────────────────
  static const Duration durationFast    = Duration(milliseconds: 150);
  static const Duration durationNormal  = Duration(milliseconds: 300);
  static const Duration durationSlow    = Duration(milliseconds: 600);
  static const Duration durationXslow   = Duration(milliseconds: 1200);
  static const Duration durationBreath  = Duration(seconds: 4);

  // ─── ANIMATION CURVES ───────────────────────────────
  static const Curve curveDefault    = Curves.easeInOut;
  static const Curve curveEntry      = Curves.easeOut;
  static const Curve curveExit       = Curves.easeIn;
  static const Curve curveElastic    = Curves.elasticOut;
  static const Curve curveBreath     = Curves.easeInOutSine;
   
  // ─── ICON SIZE ──────────────────────────────────────
  static const double iconSm  = 16.0;
  static const double iconMd  = 20.0;
  static const double iconLg  = 24.0;
  static const double iconXl  = 32.0;

  // ─── STROKE WIDTH ───────────────────────────────────
  static const double strokeThin   = 0.5;
  static const double strokeLight  = 1.0;
  static const double strokeMedium = 1.5;
  static const double strokeBold   = 2.0;
}