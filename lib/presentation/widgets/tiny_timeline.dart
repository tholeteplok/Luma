import 'package:flutter/material.dart';

import '../../data/db/models/models.dart';
import '../../core/utils/fade_granularity.dart';
import '../../core/utils/luma_language.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../painters/fading_timeline_painter.dart';

/// TinyTimeline — Visualisasi ringkas pola fokus 30 hari terakhir.
///
/// Bukan chart produktivitas. Bukan scorecard.
/// Ini adalah mirror dari ritme harian — tanpa penilaian.
class TinyTimeline extends StatelessWidget {
  final List<DailySummary> summaries;
  final LumaLanguage language;

  const TinyTimeline({
    super.key,
    required this.summaries,
    this.language = LumaLanguage.indonesian,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 72.0,
          child: CustomPaint(
            painter: FadingTimelinePainter(
              summaries: summaries,
              language: language,
            ),
            size: const Size(double.infinity, 72.0),
          ),
        ),
        const SizedBox(height: 6),
        // Hint text pasif — tidak mendesak, tidak menghakimi
        Text(
          FadeGranularity.getHintText(language),
          style: LumaTypography.labelMedium.copyWith(
            color: LumaColors.textSubtle,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
