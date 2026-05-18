import 'package:flutter/material.dart';

import '../../data/db/models/daily_summary.dart';
import '../../config/colors.dart';
import 'fading_timeline_painter.dart';

// Tiny timeline widget that renders summaries with fade/blur based on age
class TinyTimeline extends StatelessWidget {
  final List<DailySummary> summaries;
  final dynamic language;

  const TinyTimeline({Key? key, required this.summaries, this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Height aligned with design: 72px
    return SizedBox(
      height: 72.0,
      child: CustomPaint(
        painter: FadingTimelinePainter(
          summaries: summaries,
          language: language,
        ),
        size: Size(double.infinity, 72.0),
      ),
    );
  }
}
