import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../core/utils/fade_granularity.dart';
import '../../config/colors.dart';
import '../../data/db/models/daily_summary.dart';

class FadingTimelinePainter extends CustomPainter {
  final List<DailySummary> summaries;
  final dynamic language;

  FadingTimelinePainter({required this.summaries, this.language});

  @override
  void paint(Canvas canvas, Size size) {
    if (summaries.isEmpty) return;
    final today = DateTime.now();
    final barWidth = size.width / summaries.length;

    for (int i = 0; i < summaries.length; i++) {
      final summary = summaries[i];
      final daysOld = today.difference(summary.date).inDays;
      final opacity = FadeGranularity.getOpacity(daysOld);
      final blurSigma = FadeGranularity.getBlurSigma(daysOld);

      final baseColor = summary.focusQuality > 0.7
          ? LumaColors.encodeFocus
          : summary.focusQuality > 0.4
              ? LumaColors.accentMuted
              : LumaColors.encodeDistraction;

      final paint = Paint()
        ..color = baseColor.withOpacity(opacity)
        ..maskFilter = (blurSigma > 0)
            ? MaskFilter.blur(BlurStyle.normal, blurSigma)
            : null;

      final h = (summary.focusQuality * size.height).clamp(8.0, size.height);
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
