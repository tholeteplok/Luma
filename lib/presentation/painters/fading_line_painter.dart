import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';
import '../../core/utils/fade_granularity.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  TIME-OF-DAY LINE COLOR
// ─────────────────────────────────────────────────────────────────────────────

Color _timeOfDayLineColor() {
  final hour = DateTime.now().hour;
  if (hour >= 6 && hour < 10) return const Color(0xFF60A5FA);
  if (hour >= 10 && hour < 16) return const Color(0xFF8A94A8);
  if (hour >= 16 && hour < 22) {
    final t = (hour - 16) / 6.0;
    return Color.lerp(
      const Color(0xFFA78BFA),
      const Color(0xFFD97706),
      t * 0.6,
    )!;
  }
  return const Color(0xFF3730A3);
}

// ─────────────────────────────────────────────────────────────────────────────
//  FADING LINE PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class FadingLinePainter extends CustomPainter {
  final List<Map<String, dynamic>> weeklyData;
  final DateTime today;
  final double drawProgress;
  final double breathOffset;
  final Color lineColor;
  final Color accentColor; // theme-aware today dot

  const FadingLinePainter({
    required this.weeklyData,
    required this.today,
    this.drawProgress = 1.0,
    this.breathOffset = 0.0,
    required this.lineColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weeklyData.isEmpty) return;

    final count = weeklyData.length;
    final stepX = size.width / (count > 1 ? count - 1 : 1);

    final basePoints = <Offset>[];
    for (int i = 0; i < count; i++) {
      final quality =
          (weeklyData[i]['focusScore'] as double? ?? 0.5).clamp(0.05, 1.0);
      final x = i * stepX;
      final y = size.height -
          (quality * (size.height * 0.80)) -
          (size.height * 0.05);
      basePoints.add(Offset(x, y));
    }

    final points = basePoints.asMap().entries.map((entry) {
      final i = entry.key;
      final p = entry.value;
      final phase = (i / count) * math.pi * 2;
      final yShift = breathOffset * math.sin(phase);
      return Offset(p.dx, p.dy + yShift);
    }).toList();

    for (int i = 0; i < points.length - 1; i++) {
      final segmentStart = i / (points.length - 1);
      final segmentEnd = (i + 1) / (points.length - 1);
      if (drawProgress < segmentStart) continue;

      final dateStr = weeklyData[i]['date'] as String?;
      int daysOld = 0;
      if (dateStr != null) {
        try {
          daysOld = today.difference(DateTime.parse(dateStr)).inDays;
        } catch (_) {
          daysOld = (count - 1 - i) * 2;
        }
      } else {
        daysOld = (count - 1 - i) * 2;
      }

      final opacity = FadeGranularity.getOpacity(daysOld) * 0.85;
      final blur = FadeGranularity.getBlurSigma(daysOld);

      final paint = Paint()
        ..color = lineColor.withValues(alpha: opacity)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      if (blur > 0) {
        paint.maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, blur);
      }

      final p0 = points[i];
      var p1 = points[i + 1];

      if (drawProgress < segmentEnd) {
        final t = (drawProgress - segmentStart) / (segmentEnd - segmentStart);
        p1 = Offset.lerp(p0, p1, t.clamp(0, 1))!;
      }

      final ctrl1 = Offset((p0.dx + p1.dx) / 2, p0.dy);
      final ctrl2 = Offset((p0.dx + p1.dx) / 2, p1.dy);

      canvas.drawPath(
        Path()
          ..moveTo(p0.dx, p0.dy)
          ..cubicTo(ctrl1.dx, ctrl1.dy, ctrl2.dx, ctrl2.dy, p1.dx, p1.dy),
        paint,
      );
    }

    if (drawProgress >= 1.0 && points.isNotEmpty) {
      canvas.drawCircle(
        points.last,
        3.5,
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FadingLinePainter old) =>
      old.drawProgress != drawProgress ||
      old.breathOffset != breathOffset ||
      old.lineColor != lineColor ||
      old.accentColor != accentColor ||
      old.weeklyData != weeklyData;
}

// ─────────────────────────────────────────────────────────────────────────────
//  FADING LINE CHART WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class FadingLineChart extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyData;
  final double height;
  final bool reduceMotion;

  const FadingLineChart({
    super.key,
    required this.weeklyData,
    this.height = 72,
    this.reduceMotion = false,
  });

  @override
  State<FadingLineChart> createState() => _FadingLineChartState();
}

class _FadingLineChartState extends State<FadingLineChart>
    with TickerProviderStateMixin {
  late final AnimationController _drawController;
  late final Animation<double> _drawAnim;
  late final AnimationController _breathController;
  late final Animation<double> _breathAnim;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _drawAnim =
        CurvedAnimation(parent: _drawController, curve: Curves.easeOut);

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
    _breathAnim = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    if (!widget.reduceMotion) {
      _drawController.forward();
      _drawController.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _breathController.repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _drawController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;

    if (widget.weeklyData.isEmpty) {
      return SizedBox(
        height: widget.height + 32,
        child: Center(
          child: Text(
            'Luma mengamati ritmemu.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: p.textSubtle,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      );
    }

    final now = DateTime.now();
    final lineColor = _timeOfDayLineColor();
    const amplitudePx = 3.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: SizedBox(
            height: widget.height,
            child: widget.reduceMotion
                ? CustomPaint(
                    size: Size.infinite,
                    painter: FadingLinePainter(
                      weeklyData: widget.weeklyData,
                      today: now,
                      drawProgress: 1.0,
                      breathOffset: 0,
                      lineColor: lineColor,
                      accentColor: p.accent,
                    ),
                  )
                : AnimatedBuilder(
                    animation: Listenable.merge([_drawAnim, _breathAnim]),
                    builder: (context, _) => CustomPaint(
                      size: Size.infinite,
                      painter: FadingLinePainter(
                        weeklyData: widget.weeklyData,
                        today: now,
                        drawProgress: _drawAnim.value,
                        breathOffset: _breathAnim.value * amplitudePx,
                        lineColor: lineColor,
                        accentColor: p.accent,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: widget.weeklyData.asMap().entries.map((entry) {
            final i = entry.key;
            final day = entry.value;
            final label = day['day'] as String? ?? '';
            final isToday = i == widget.weeklyData.length - 1;
            return Expanded(
              child: Column(
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 10,
                      fontWeight:
                          isToday ? FontWeight.w500 : FontWeight.w400,
                      color: isToday ? p.textPrimary : p.textTertiary,
                    ),
                  ),
                  if (isToday)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.accent,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Text(
          'Pola tetap tersimpan.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: p.textSubtle,
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}
