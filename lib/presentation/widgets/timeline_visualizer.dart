import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';

/// Timeline Visualizer - Abstract ambient visualization untuk weekly data
/// Menggunakan pendekatan visual abstrak, bukan angka (sesuai design philosophy Luma)
class TimelineVisualizer extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;
  final double height;

  const TimelineVisualizer({
    super.key,
    required this.weeklyData,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklyData.isEmpty) {
      return Container(
        height: height,
        alignment: Alignment.center,
        child: Text(
          'Belum ada data',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textDarkSecondary,
              ),
        ),
      );
    }

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: weeklyData.map((day) {
          final screenTime = day['screenTime'] as double? ?? 0;
          final focusScore = day['focusScore'] as double? ?? 0.5;
          final dayLabel = day['day'] as String? ?? '';

          // Normalize values untuk visualisasi
          final normalizedHeight = (screenTime / 10).clamp(0.2, 1.0);
          final focusOpacity = focusScore.clamp(0.3, 1.0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Bar dengan gradient berdasarkan focus score
              Container(
                width: 24,
                height: height * normalizedHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottom,
                    end: Alignment.top,
                    colors: [
                      _getFocusColor(focusScore).withOpacity(0.6),
                      _getFocusColor(focusScore).withOpacity(focusOpacity),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              // Day label
              Text(
                dayLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textDarkSecondary,
                      fontSize: 10,
                    ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getFocusColor(double focusScore) {
    if (focusScore >= 0.75) {
      return AppColors.positive; // Hijau - fokus tinggi
    } else if (focusScore >= 0.5) {
      return AppColors.info; // Biru - fokus sedang
    } else if (focusScore >= 0.25) {
      return AppColors.warning; // Orange - fokus rendah
    } else {
      return AppColors.critical; // Merah - fokus sangat rendah
    }
  }
}

/// Focus Ring - Animated indicator untuk current focus level
class FocusRing extends StatefulWidget {
  final double focusLevel; // 0.0 - 1.0
  final double size;

  const FocusRing({
    super.key,
    required this.focusLevel,
    this.size = 120,
  });

  @override
  State<FocusRing> createState() => _FocusRingState();
}

class _FocusRingState extends State<FocusRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring (background)
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.borderDark.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          // Animated progress ring
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RingPainter(
                  progress: widget.focusLevel,
                  rotation: _animation.value * 2 * 3.14159,
                  color: _getFocusColor(widget.focusLevel),
                ),
              );
            },
          ),
          // Center text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(widget.focusLevel * 100).toInt()}%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getFocusColor(widget.focusLevel),
                    ),
              ),
              Text(
                'Fokus',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textDarkSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getFocusColor(double focusLevel) {
    if (focusLevel >= 0.75) {
      return AppColors.positive;
    } else if (focusLevel >= 0.5) {
      return AppColors.info;
    } else if (focusLevel >= 0.25) {
      return AppColors.warning;
    } else {
      return AppColors.critical;
    }
  }
}

/// Custom painter untuk animated ring
class _RingPainter extends CustomPainter {
  final double progress;
  final double rotation;
  final Color color;

  _RingPainter({
    required this.progress,
    required this.rotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.borderDark.withOpacity(0.2)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc dengan rotation
    final progressPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start dari atas
      sweepAngle,
      false,
      progressPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.rotation != rotation ||
        oldDelegate.color != color;
  }
}
