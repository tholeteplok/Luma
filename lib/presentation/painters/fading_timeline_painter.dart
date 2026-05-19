import 'package:flutter/material.dart';

import '../../core/utils/fade_granularity.dart';
import '../../core/utils/luma_language.dart';
import '../../config/colors.dart';
import '../../data/db/models/daily_summary_model.dart';

/// FadingTimelinePainter — Visualisasi memori dengan decay progresif.
///
/// Bar lebih pendek → hari dengan fokus rendah.
/// Bar lebih buram → hari yang lebih jauh ke masa lalu.
/// Ini bukan chart — ini adalah representasi visual ingatan.
class FadingTimelinePainter extends CustomPainter {
  final List<DailySummary> summaries;
  final LumaLanguage language;
  final DateTime? today;

  FadingTimelinePainter({
    required this.summaries,
    this.language = LumaLanguage.indonesian,
    this.today,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (summaries.isEmpty) return;
    final now = today ?? DateTime.now();
    final barWidth = size.width / summaries.length;

    for (int i = 0; i < summaries.length; i++) {
      final summary = summaries[i];
      final daysOld = now.difference(summary.date).inDays;
      final opacity = FadeGranularity.getOpacity(daysOld);
      final blurSigma = FadeGranularity.getBlurSigma(daysOld);

      final focusQuality = summary.focusScore / 100.0;

      final baseColor = focusQuality > 0.7
          ? LumaColors.encodeFocus
          : focusQuality > 0.4
              ? LumaColors.accentMuted
              : LumaColors.encodeDistraction;

      final paint = Paint()
        ..color = baseColor.withValues(alpha: opacity)
        ..maskFilter = (blurSigma > 0)
            ? MaskFilter.blur(BlurStyle.normal, blurSigma)
            : null;

      final h = (focusQuality * size.height).clamp(8.0, size.height);
      final barRect = Rect.fromLTWH(
        i * barWidth + 2,
        size.height - h,
        barWidth - 4,
        h,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(barRect, Radius.circular(3)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FadingTimelinePainter oldDelegate) {
    return oldDelegate.summaries != summaries ||
        oldDelegate.language != language;
  }
}
