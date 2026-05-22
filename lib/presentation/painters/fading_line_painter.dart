import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';
import '../../core/utils/fade_granularity.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  POSISI TITIK BERDASARKAN USIA DATA
//
//  Titik bergerak dari kiri ke kanan seiring waktu.
//  Tidak pernah sampai 100% — Luma terus belajar, tidak pernah "selesai".
//
//  Hari 1-2   → 5–10%   (kiri, baru mulai)
//  Hari 3-4   → 10–25%
//  Hari 5-7   → 25–40%
//  Hari 8-14  → 40–60%
//  Hari 15-28 → 60–80%
//  Hari 28+   → 80–95%  (tidak pernah 100%)
// ─────────────────────────────────────────────────────────────────────────────

double _dotPositionRatio(int baselineDays) {
  if (baselineDays <= 1)  return 0.07; // Hari 1
  if (baselineDays == 2)  return 0.18; // Hari 2
  if (baselineDays <= 4)  return 0.33; // Hari 3-4
  if (baselineDays <= 7)  return 0.50; // Hari 5-7
  if (baselineDays <= 14) return 0.70; // Hari 8-14
  return 0.88; // Hari 15+ (tidak pernah 1.0)
}

/// Panjang garis solid (0.0–1.0) berdasarkan usia data
double _solidLineRatio(int baselineDays) {
  if (baselineDays <= 1)  return 0.08;
  if (baselineDays == 2)  return 0.22;
  if (baselineDays <= 4)  return 0.40;
  if (baselineDays <= 7)  return 0.60;
  if (baselineDays <= 14) return 0.78;
  return 0.92;
}

// ─────────────────────────────────────────────────────────────────────────────
//  RIPPLE MODELS
// ─────────────────────────────────────────────────────────────────────────────

class RippleInfo {
  final Offset position;
  final double progress;

  RippleInfo({required this.position, required this.progress});
}

class RippleEffect {
  final Offset position;
  final AnimationController controller;

  RippleEffect({required this.position, required this.controller});
}

// ─────────────────────────────────────────────────────────────────────────────
//  FADING LINE PAINTER
// ─────────────────────────────────────────────────────────────────────────────

/// FadingLinePainter — Timeline yang hidup.
///
/// Titik mulai dari kiri, bergerak ke kanan seiring waktu.
/// Garis solid di kiri (data ada), putus-putus di kanan (belum ada data).
/// Titik bergerak naik-turun seperti detak jantung via [heartbeatOffset].
class FadingLinePainter extends CustomPainter {
  final List<Map<String, dynamic>> weeklyData;
  final DateTime today;

  /// 0.0–1.0: progress draw kiri→kanan (animasi masuk pertama kali)
  final double drawProgress;

  /// Offset vertikal titik untuk animasi detak jantung (±px)
  final double heartbeatOffset;

  final Color lineColor;
  final Color accentColor;

  /// Berapa hari data tersedia — menentukan posisi titik dan panjang garis solid
  final int baselineDays;

  /// Daftar riak air berpendar (bioluminescent ripples)
  final List<RippleInfo> ripples;

  const FadingLinePainter({
    required this.weeklyData,
    required this.today,
    this.drawProgress = 1.0,
    this.heartbeatOffset = 0.0,
    required this.lineColor,
    required this.accentColor,
    this.baselineDays = 0,
    this.ripples = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dotX = size.width * _dotPositionRatio(baselineDays);
    final solidEnd = size.width * _solidLineRatio(baselineDays);
    final centerY = size.height / 2;

    // ── Garis putus-putus (kanan — belum ada data) ────────────────────────────
    _paintDashedLine(
      canvas,
      Offset(dotX, centerY),
      Offset(size.width, centerY),
      lineColor.withValues(alpha: 0.18),
    );

    // ── Garis solid (kiri — data sudah ada) ───────────────────────────────────
    if (weeklyData.isNotEmpty && baselineDays > 1) {
      _paintSolidLine(canvas, size, solidEnd, centerY);
    } else {
      // Tidak ada data / Hari pertama — garis solid minimal dari kiri ke titik
      _paintSimpleLine(
        canvas,
        Offset(0, centerY),
        Offset(dotX * drawProgress, centerY),
        lineColor.withValues(alpha: 0.45),
      );
    }

    // ── Titik detak jantung ───────────────────────────────────────────────────
    final dotY = centerY + heartbeatOffset;
    _paintDot(canvas, Offset(dotX, dotY));

    // ── Bioluminescent Ripples ───────────────────────────────────────────────
    if (ripples.isNotEmpty) {
      for (final ripple in ripples) {
        _paintRipple(canvas, ripple.position, ripple.progress);
      }
    }
  }

  void _paintRipple(Canvas canvas, Offset center, double progress) {
    final maxRadius = 100.0;
    final radius = progress * maxRadius;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    // 1. Outer soft glowing ring
    final outerPaint = Paint()
      ..color = accentColor.withValues(alpha: opacity * 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8.0);

    canvas.drawCircle(center, radius, outerPaint);

    // 2. Middle sharp glowing ring
    final innerPaint = Paint()
      ..color = accentColor.withValues(alpha: opacity * 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 2.0);

    canvas.drawCircle(center, radius, innerPaint);

    // 3. Central glowing aura
    final centerPaint = Paint()
      ..color = accentColor.withValues(alpha: opacity * 0.25)
      ..style = PaintingStyle.fill
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, 12.0 + progress * 10.0);

    canvas.drawCircle(center, radius * 0.35, centerPaint);
  }

  /// Garis solid dengan fade granularity per segmen
  void _paintSolidLine(Canvas canvas, Size size, double solidEnd, double centerY) {
    if (weeklyData.isEmpty) return;

    final count = weeklyData.length;
    // Distribusikan titik data di sepanjang garis solid
    final stepX = solidEnd / (count > 1 ? count - 1 : 1);

    final points = <Offset>[];
    for (int i = 0; i < count; i++) {
      final score = (weeklyData[i]['focusScore'] as num? ?? 50).toDouble();
      final screenTime = weeklyData[i]['screenTimeSeconds'] as int? ?? 0;

      // Dynamic wave dampening based on screen time
      double ampFactor = 1.0;
      if (screenTime < 600) {
        ampFactor = 0.0; // Garis lurus rata jika data sangat minim (<10 menit)
      } else if (screenTime < 3600) {
        ampFactor = (screenTime - 600) / 3000.0; // Transisi gelombang gradual
      }

      // Normalize score 0–100 ke amplitudo ±12px di sekitar centerY
      final amplitude = 12.0 * ampFactor;
      final normalized = (score / 100.0 - 0.5) * 2; // -1.0 to 1.0
      final y = centerY - normalized * amplitude;
      points.add(Offset(i * stepX, y));
    }

    for (int i = 0; i < points.length - 1; i++) {
      final segStart = i / (points.length - 1);
      final segEnd = (i + 1) / (points.length - 1);
      if (drawProgress < segStart) continue;

      final dateVal = weeklyData[i]['date'];
      int daysOld = 0;
      if (dateVal is DateTime) {
        daysOld = today.difference(dateVal).inDays;
      } else if (dateVal is String) {
        try {
          daysOld = today.difference(DateTime.parse(dateVal)).inDays;
        } catch (_) {
          daysOld = (count - 1 - i) * 2;
        }
      } else {
        daysOld = (count - 1 - i) * 2;
      }

      final opacity = FadeGranularity.getOpacity(daysOld) * 0.90;
      final blur = FadeGranularity.getBlurSigma(daysOld);

      final paint = Paint()
        ..color = lineColor.withValues(alpha: opacity)
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      if (blur > 0) {
        paint.maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, blur);
      }

      var p0 = points[i];
      var p1 = points[i + 1];

      if (drawProgress < segEnd) {
        final t = (drawProgress - segStart) / (segEnd - segStart);
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
  }

  void _paintDashedLine(Canvas canvas, Offset start, Offset end, Color color) {
    const dashLen = 4.0;
    const gapLen = 6.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    double x = start.dx;
    bool drawing = true;
    while (x < end.dx) {
      final segEnd = math.min(x + (drawing ? dashLen : gapLen), end.dx);
      if (drawing) {
        canvas.drawLine(Offset(x, start.dy), Offset(segEnd, start.dy), paint);
      }
      x = segEnd;
      drawing = !drawing;
    }
  }

  void _paintSimpleLine(Canvas canvas, Offset start, Offset end, Color color) {
    canvas.drawLine(
      start,
      end,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintDot(Canvas canvas, Offset center) {
    // Outer glow
    canvas.drawCircle(
      center,
      7.0,
      Paint()
        ..color = accentColor.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill,
    );
    // Inner dot
    canvas.drawCircle(
      center,
      4.0,
      Paint()
        ..color = accentColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant FadingLinePainter old) =>
      old.drawProgress != drawProgress ||
      old.heartbeatOffset != heartbeatOffset ||
      old.lineColor != lineColor ||
      old.accentColor != accentColor ||
      old.baselineDays != baselineDays ||
      old.weeklyData != weeklyData ||
      old.ripples != ripples;
}

// ─────────────────────────────────────────────────────────────────────────────
//  FADING LINE CHART WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// FadingLineChart — Timeline yang hidup sejak hari pertama.
///
/// Animasi:
/// 1. Draw kiri→kanan saat pertama tampil (1.2s)
/// 2. Detak jantung: titik naik-turun ±3px, 5s/cycle, sine wave
///
/// Titik tidak pernah di kanan — ia bergerak dari kiri seiring waktu.
class FadingLineChart extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyData;
  final double height;
  final bool reduceMotion;

  /// Berapa hari data tersedia — menentukan posisi titik
  final int baselineDays;

  /// Callback interaktif saat disentuh/pinch
  final VoidCallback? onInteraction;

  const FadingLineChart({
    super.key,
    required this.weeklyData,
    this.height = 72,
    this.reduceMotion = false,
    this.baselineDays = 0,
    this.onInteraction,
  });

  @override
  State<FadingLineChart> createState() => _FadingLineChartState();
}

class _FadingLineChartState extends State<FadingLineChart>
    with TickerProviderStateMixin {
  late final AnimationController _drawController;
  late final Animation<double> _drawAnim;

  // Detak jantung — naik turun pelan seperti napas
  late final AnimationController _heartbeatController;
  late final Animation<double> _heartbeatAnim;

  // Daftar riak air aktif
  final List<RippleEffect> _ripples = [];

  @override
  void initState() {
    super.initState();

    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _drawAnim = CurvedAnimation(parent: _drawController, curve: Curves.easeOut);

    // 5 detik per siklus — seperti napas, tidak terburu-buru
    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    _heartbeatAnim = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartbeatController, curve: Curves.easeInOut),
    );

    if (!widget.reduceMotion) {
      _drawController.forward();
      _drawController.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _heartbeatController.repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _drawController.dispose();
    _heartbeatController.dispose();
    for (final ripple in _ripples) {
      ripple.controller.dispose();
    }
    super.dispose();
  }

  void _handleInteraction(Offset localPosition) {
    if (widget.onInteraction != null) {
      widget.onInteraction!();
    }

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final ripple = RippleEffect(
      position: localPosition,
      controller: controller,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _ripples.remove(ripple);
        controller.dispose();
        setState(() {});
      }
    });

    setState(() {
      _ripples.add(ripple);
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    final lineColor = p.accent.withValues(alpha: 0.6);
    const amplitudePx = 3.0; // ±3px — halus, tidak dramatis

    final isChartEmpty = widget.weeklyData.isEmpty || widget.baselineDays == 0;

    Widget chartWidget = widget.reduceMotion
        ? CustomPaint(
            size: Size.infinite,
            painter: FadingLinePainter(
              weeklyData: widget.weeklyData,
              today: DateTime.now(),
              drawProgress: 1.0,
              heartbeatOffset: 0,
              lineColor: lineColor,
              accentColor: p.accent,
              baselineDays: widget.baselineDays,
              ripples: _ripples
                  .map((r) => RippleInfo(
                        position: r.position,
                        progress: r.controller.value,
                      ))
                  .toList(),
            ),
          )
        : AnimatedBuilder(
            animation: Listenable.merge([_drawAnim, _heartbeatAnim]),
            builder: (context, _) => CustomPaint(
              size: Size.infinite,
              painter: FadingLinePainter(
                weeklyData: widget.weeklyData,
                today: DateTime.now(),
                drawProgress: _drawAnim.value,
                heartbeatOffset: _heartbeatAnim.value * amplitudePx,
                lineColor: lineColor,
                accentColor: p.accent,
                baselineDays: widget.baselineDays,
                ripples: _ripples
                    .map((r) => RippleInfo(
                          position: r.position,
                          progress: r.controller.value,
                        ))
                    .toList(),
              ),
            ),
          );

    if (isChartEmpty) {
      chartWidget = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) {
          _handleInteraction(details.localPosition);
        },
        onScaleStart: (details) {
          _handleInteraction(details.localFocalPoint);
        },
        child: chartWidget,
      );
    }

    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        child: chartWidget,
      ),
    );
  }
}
