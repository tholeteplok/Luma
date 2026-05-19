import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';
import '../../core/utils/fade_granularity.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  TIME-OF-DAY COLOR HELPER
// ─────────────────────────────────────────────────────────────────────────────

/// Warna garis berdasarkan jam perangkat — ambient shift tanpa animasi loop.
/// Dipanggil sekali saat build, diperbarui saat widget rebuild alami.
Color _timeOfDayLineColor() {
  final hour = DateTime.now().hour;
  if (hour >= 6 && hour < 10) {
    return const Color(0xFF60A5FA); // pagi: cool blue
  } else if (hour >= 10 && hour < 16) {
    return const Color(0xFF8A94A8); // siang: neutral slate (desaturated)
  } else if (hour >= 16 && hour < 22) {
    // sore–malam: blend amber → purple berdasarkan jam
    final t = (hour - 16) / 6.0; // 0.0 = 16:00, 1.0 = 22:00
    return Color.lerp(
      const Color(0xFFA78BFA), // lavender-purple
      const Color(0xFFD97706), // warm amber
      t * 0.6,
    )!;
  } else {
    return const Color(0xFF3730A3); // tengah malam: deep indigo
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FADING LINE PAINTER
// ─────────────────────────────────────────────────────────────────────────────

/// FadingLinePainter — Custom painter untuk line chart yang memudar.
///
/// Parameter animasi:
/// - [drawProgress] 0→1: progressive ink draw (kiri ke kanan)
/// - [breathOffset] -1→1: undulasi napas vertikal
/// - [lineColor]: warna ambient berdasarkan waktu
class FadingLinePainter extends CustomPainter {
  final List<Map<String, dynamic>> weeklyData;
  final DateTime today;
  final double drawProgress; // 0.0 = belum tergambar, 1.0 = selesai
  final double breathOffset; // amplitudo undulasi (px)
  final Color lineColor;

  const FadingLinePainter({
    required this.weeklyData,
    required this.today,
    this.drawProgress = 1.0,
    this.breathOffset = 0.0,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weeklyData.isEmpty) return;

    final count = weeklyData.length;
    final stepX = size.width / (count > 1 ? count - 1 : 1);

    // Titik dasar (tanpa breath)
    final basePoints = <Offset>[];
    for (int i = 0; i < count; i++) {
      final quality = (weeklyData[i]['focusScore'] as double? ?? 0.5)
          .clamp(0.05, 1.0);
      final x = i * stepX;
      final y = size.height - (quality * (size.height * 0.80)) - (size.height * 0.05);
      basePoints.add(Offset(x, y));
    }

    // Titik dengan undulasi napas (sinus per index, fase berbeda-beda)
    final points = basePoints.asMap().entries.map((entry) {
      final i = entry.key;
      final p = entry.value;
      // Setiap titik punya fase sinus berbeda agar terasa organik, bukan mekanis
      final phase = (i / count) * math.pi * 2;
      final yShift = breathOffset * math.sin(phase);
      return Offset(p.dx, p.dy + yShift);
    }).toList();

    // ── Gambar segment per segment (fade per usia data) ──────────────────────
    for (int i = 0; i < points.length - 1; i++) {
      // Hitung progress draw: segment hanya muncul jika drawProgress mencapainya
      final segmentStart = i / (points.length - 1);
      final segmentEnd = (i + 1) / (points.length - 1);
      if (drawProgress < segmentStart) continue;

      final dateStr = weeklyData[i]['date'] as String?;
      int daysOld = 0;
      if (dateStr != null) {
        try {
          final date = DateTime.parse(dateStr);
          daysOld = today.difference(date).inDays;
        } catch (_) {
          daysOld = (count - 1 - i) * 2;
        }
      } else {
        daysOld = (count - 1 - i) * 2;
      }

      final opacity = FadeGranularity.getOpacity(daysOld) * 0.85; // max 0.85
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

      // Jika segment terakhir yang sedang di-draw, potong sampai drawProgress
      if (drawProgress < segmentEnd) {
        final t = (drawProgress - segmentStart) / (segmentEnd - segmentStart);
        p1 = Offset.lerp(p0, p1, t.clamp(0, 1))!;
      }

      final ctrl1 = Offset((p0.dx + p1.dx) / 2, p0.dy);
      final ctrl2 = Offset((p0.dx + p1.dx) / 2, p1.dy);

      final path = Path()
        ..moveTo(p0.dx, p0.dy)
        ..cubicTo(ctrl1.dx, ctrl1.dy, ctrl2.dx, ctrl2.dy, p1.dx, p1.dy);

      canvas.drawPath(path, paint);
    }

    // ── Today dot — hanya muncul setelah draw selesai ────────────────────────
    if (drawProgress >= 1.0 && points.isNotEmpty) {
      final todayPoint = points.last;
      canvas.drawCircle(
        todayPoint,
        3.5,
        Paint()
          ..color = AppColors.accent
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FadingLinePainter old) {
    return old.drawProgress != drawProgress ||
        old.breathOffset != breathOffset ||
        old.lineColor != lineColor ||
        old.weeklyData != weeklyData;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FADING LINE CHART WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// FadingLineChart — Line chart dengan tiga layer "hidup":
///
/// 1. **Progressive Ink Draw** — muncul kiri→kanan saat pertama tampil (1.2s)
/// 2. **Breathing Undulation** — garis naik-turun organik ~4s/cycle
/// 3. **Time-of-Day Color** — warna berubah berdasarkan jam perangkat
///
/// Semua animasi terisolasi di dalam widget ini (RepaintBoundary).
/// Parent tidak di-setState selama animasi berjalan.
///
/// [reduceMotion] → matikan breath & progressive draw, garis statis.
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
  // Ink draw: 0→1 dalam 1.2 detik, sekali saja
  late final AnimationController _drawController;
  late final Animation<double> _drawAnim;

  // Breath: -1→1 looping 4 detik, offset berbeda per titik sudah di painter
  late final AnimationController _breathController;
  late final Animation<double> _breathAnim;

  @override
  void initState() {
    super.initState();

    // ── Progressive ink draw ──────────────────────────────────────────────
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _drawAnim = CurvedAnimation(
      parent: _drawController,
      curve: Curves.easeOut,
    );

    // ── Breathing undulation ──────────────────────────────────────────────
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
    _breathAnim = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    if (!widget.reduceMotion) {
      _drawController.forward();
      // Breath dimulai setelah draw selesai agar tidak overlap
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
    if (widget.weeklyData.isEmpty) {
      return SizedBox(
        height: widget.height + 32,
        child: Center(
          child: Text(
            'Luma mengamati ritmemu.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSubtle,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    final now = DateTime.now();
    final lineColor = _timeOfDayLineColor();
    final amplitudePx = 3.5; // maksimum undulasi ±3.5px — sangat halus

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RepaintBoundary: animasi tidak menyebabkan repaint di parent
        RepaintBoundary(
          child: SizedBox(
            height: widget.height,
            child: widget.reduceMotion
                // Static line (reduce motion on)
                ? CustomPaint(
                    size: Size.infinite,
                    painter: FadingLinePainter(
                      weeklyData: widget.weeklyData,
                      today: now,
                      drawProgress: 1.0,
                      breathOffset: 0,
                      lineColor: lineColor,
                    ),
                  )
                // Animated line
                : AnimatedBuilder(
                    animation: Listenable.merge([_drawAnim, _breathAnim]),
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: FadingLinePainter(
                          weeklyData: widget.weeklyData,
                          today: now,
                          drawProgress: _drawAnim.value,
                          breathOffset: _breathAnim.value * amplitudePx,
                          lineColor: lineColor,
                        ),
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(height: 6),
        // Day labels
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
                      fontWeight: isToday ? FontWeight.w500 : FontWeight.w400,
                      color: isToday
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                  if (isToday)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
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
            color: AppColors.textSubtle,
            fontStyle: FontStyle.italic,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
