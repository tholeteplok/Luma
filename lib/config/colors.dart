// lib/config/colors.dart

import 'package:flutter/material.dart';

class LumaColors {
  // ─── BACKGROUND ──────────────────────────────────────
  static const Color bgBase         = Color(0xFF0C0C14); // Main bg — deep night
  static const Color bgSurface      = Color(0xFF12121E); // Card, elevated surface
  static const Color bgElevated     = Color(0xFF191927); // Highest elevation
  static const Color bgSubtle       = Color(0xFF1E1E30); // Hover state, subtle diff

  // ─── BORDERS ─────────────────────────────────────────
  static const Color borderFaint    = Color(0xFF1F1F32); // Barely visible border
  static const Color borderSubtle   = Color(0xFF2A2A42); // Visible border
  static const Color borderMedium   = Color(0xFF363654); // Medium emphasis border

  // ─── TEXT ────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFFE8E8F2); // Main text
  static const Color textSecondary  = Color(0xFFB4B4CC); // Supporting text
  static const Color textTertiary   = Color(0xFF7A7A96); // Captions, labels
  static const Color textSubtle     = Color(0xFF4A4A68); // Very muted (waiting room)
  static const Color textDisabled   = Color(0xFF2E2E48); // Disabled

  // ─── ACCENT (Blue-Violet) ────────────────────────────
  static const Color accentPrimary  = Color(0xFF6B6BCA); // Main accent
  static const Color accentLight    = Color(0xFF8A8ADA); // Lighter variant
  static const Color accentMuted    = Color(0xFF3D3D7A); // Very muted accent
  static const Color accentSubtle   = Color(0xFF1E1E48); // Subtle accent bg

  // ─── INSIGHT SEVERITY COLORS ─────────────────────────
  // INFO — Blue (neutral observation)
  static const Color infoText       = Color(0xFF7B9FD4); // Text on dark
  static const Color infoIndicator  = Color(0xFF3A5A8A); // Indicator bar
  static const Color infoBg         = Color(0xFF151E2E); // Card bg tint (optional)

  // NOTICE — Amber (gentle pattern change)
  static const Color noticeText     = Color(0xFFC4944A); // Text on dark
  static const Color noticeIndicator = Color(0xFF7A5220); // Indicator bar
  static const Color noticeBg       = Color(0xFF1E1810); // Card bg tint

  // GENTLE — Sage green (self-compassion)
  static const Color gentleText     = Color(0xFF6BA896); // Text on dark
  static const Color gentleIndicator = Color(0xFF2E5A50); // Indicator bar
  static const Color gentleBg       = Color(0xFF101E1B); // Card bg tint

  // WARNING — Terracotta (burnout signal, rare)
  static const Color warningText    = Color(0xFFB87066); // Text on dark
  static const Color warningIndicator = Color(0xFF6A3028); // Indicator bar
  static const Color warningBg      = Color(0xFF1E1010); // Card bg tint

  // ─── AMBIENT VISUALIZATION ───────────────────────────
  // Time-of-day gradient system
  static const Color ambientMorning = Color(0xFF4A6A9A); // 06:00–10:00 (blue)
  static const Color ambientMidday  = Color(0xFF5A5A8A); // 10:00–14:00 (violet)
  static const Color ambientAfternoon = Color(0xFF6A5A7A); // 14:00–18:00 (muted purple)
  static const Color ambientEvening = Color(0xFF4A3A6A); // 18:00–22:00 (deep purple)
  static const Color ambientNight   = Color(0xFF1A1A3A); // 22:00–06:00 (almost black)

  // ─── FOCUS / DISTRACTION ENCODING ───────────────────
  static const Color encodeFocus       = Color(0xFF6B8FCA); // Focus = blue
  static const Color encodeDistraction = Color(0xFF8A6B8A); // Distraction = muted purple
  static const Color encodeRest        = Color(0xFF2A2A3E); // Rest = dark
  static const Color encodeSleep       = Color(0xFF1A1A2E); // Sleep = very dark

  // ─── INTERACTIVE ─────────────────────────────────────
  static const Color interactiveFg     = Color(0xFFE8E8F2); // Button text
  static const Color interactiveBorder = Color(0xFF363654); // Outlined button border
  static const Color interactiveBorderHover = Color(0xFF6B6BCA); // Hover border
  static const Color interactivePressed = Color(0xFF0C0C14); // Pressed bg

  // ─── FEEDBACK BUTTON ─────────────────────────────────
  static const Color feedbackDefault   = Color(0xFF1E1E30); // Default bg
  static const Color feedbackSelected  = Color(0xFF2A2A42); // Selected bg
  static const Color feedbackText      = Color(0xFFB4B4CC); // Default text
  static const Color feedbackTextSelected = Color(0xFFE8E8F2); // Selected text
}