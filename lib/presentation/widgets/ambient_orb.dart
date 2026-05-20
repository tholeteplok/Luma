import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Mood state untuk AmbientOrb — bukan penilaian, hanya cerminan
enum AmbientMood {
  focus,    // Fokus sedang/tinggi: biru tenang
  gentle,   // Istirahat / self-compassion: hijau redup
  shifting, // Transisi / perubahan ritme: ungu netral
  rest,     // Tidak aktif / malam: ungu sangat gelap
}

/// AmbientOrb — Hero section visual Luma
///
/// Tiga lingkaran berlapis yang bernapas secara organik.
/// Setiap layer punya fase napas berbeda (staggered) agar terasa hidup.
///
/// Perbaikan dari versi sebelumnya:
/// - Staggered breathing: tiap layer punya fase sinus berbeda
/// - Overflow fix: SizedBox diperbesar + ClipRect agar blur tidak terpotong
/// - AnimatedSwitcher untuk transisi mood yang halus
/// - reduceMotion support
/// - Opacity lebih visible, rest mood lebih kontras
class AmbientOrb extends StatefulWidget {
  final AmbientMood mood;
  final double size;

  /// Jika true, animasi breathing dimatikan (aksesibilitas)
  final bool reduceMotion;

  const AmbientOrb({
    super.key,
    this.mood = AmbientMood.focus,
    this.size = 160,
    this.reduceMotion = false,
  });

  @override
  State<AmbientOrb> createState() => _AmbientOrbState();
}

class _AmbientOrbState extends State<AmbientOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _breatheController;

  // Tiga animasi terpisah dengan fase berbeda — staggered breathing
  late Animation<double> _breatheOuter;  // layer luar: fase 0
  late Animation<double> _breatheMid;    // layer tengah: fase 120°
  late Animation<double> _breatheInner;  // layer inti: fase 240°

  @override
  void initState() {
    super.initState();

    // Satu controller, tiga animasi dengan offset kurva berbeda
    // Durasi 5s agar terasa lambat dan organik (bukan mekanis)
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // Outer layer: scale 0.94 → 1.06 (range lebih besar, terasa "mengembang")
    _breatheOuter = _buildBreathAnim(min: 0.94, max: 1.06, phaseOffset: 0.0);

    // Mid layer: scale 0.96 → 1.04, fase 1/3 siklus terlambat
    _breatheMid = _buildBreathAnim(min: 0.96, max: 1.04, phaseOffset: 1 / 3);

    // Inner layer: scale 0.97 → 1.03, fase 2/3 siklus terlambat
    _breatheInner = _buildBreathAnim(min: 0.97, max: 1.03, phaseOffset: 2 / 3);

    if (!widget.reduceMotion) {
      _breatheController.repeat();
    }
  }

  /// Buat animasi napas dengan phase offset menggunakan TweenSequence
  Animation<double> _buildBreathAnim({
    required double min,
    required double max,
    required double phaseOffset,
  }) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: _lerpPhase(min, max, phaseOffset),
                     end: max),
        weight: (1.0 - phaseOffset) * 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: max, end: min),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: min,
                     end: _lerpPhase(min, max, phaseOffset)),
        weight: phaseOffset * 50,
      ),
    ]).animate(_breatheController);
  }

  double _lerpPhase(double min, double max, double phase) {
    // Nilai awal berdasarkan posisi di siklus sinus
    return min + (max - min) * (0.5 + 0.5 * math.sin(phase * 2 * math.pi));
  }

  @override
  void didUpdateWidget(AmbientOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion != oldWidget.reduceMotion) {
      if (widget.reduceMotion) {
        _breatheController.stop();
      } else {
        _breatheController.repeat();
      }
    }
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  /// Tiga warna ambient berdasarkan mood
  List<Color> _moodColors(AmbientMood mood) {
    switch (mood) {
      case AmbientMood.focus:
        return const [
          Color(0xFF3A5A8A), // lapis luar — biru dalam
          Color(0xFF5050A0), // lapis tengah — indigo
          Color(0xFF7070D0), // lapis inti — biru-ungu terang
        ];
      case AmbientMood.gentle:
        return const [
          Color(0xFF1E4A40), // lapis luar — hijau tua
          Color(0xFF2E6A58), // lapis tengah
          Color(0xFF5A9E8A), // lapis inti — teal terang
        ];
      case AmbientMood.shifting:
        return const [
          Color(0xFF3A2A5A), // lapis luar — ungu tua
          Color(0xFF5A3A7A), // lapis tengah
          Color(0xFF9A6AAA), // lapis inti — lavender
        ];
      case AmbientMood.rest:
        // Rest lebih visible dari sebelumnya — pakai indigo gelap bukan hitam
        return const [
          Color(0xFF1A1A3A), // lapis luar
          Color(0xFF252545), // lapis tengah
          Color(0xFF353560), // lapis inti — cukup kontras dari bgBase
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    // Area lebih besar dari orb agar blur tidak terpotong di tepi
    // Blur radius terbesar adalah 24px, jadi tambahkan 2× itu sebagai padding
    final canvasSize = s + 48;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: SizedBox(
        key: ValueKey(widget.mood),
        width: canvasSize,
        height: canvasSize,
        child: widget.reduceMotion
            ? _buildStaticOrb(s)
            : AnimatedBuilder(
                animation: _breatheController,
                builder: (context, _) => _buildAnimatedOrb(s),
              ),
      ),
    );
  }

  Widget _buildStaticOrb(double s) {
    final colors = _moodColors(widget.mood);
    return Stack(
      alignment: Alignment.center,
      children: [
        _OrbLayer(size: s * 1.0,  color: colors[0], blurRadius: 24, opacity: 0.22),
        _OrbLayer(size: s * 0.65, color: colors[1], blurRadius: 16, opacity: 0.35),
        _OrbLayer(size: s * 0.35, color: colors[2], blurRadius: 10, opacity: 0.55),
      ],
    );
  }

  Widget _buildAnimatedOrb(double s) {
    final colors = _moodColors(widget.mood);
    return Stack(
      alignment: Alignment.center,
      children: [
        // Layer luar — paling lambat, range terbesar
        _OrbLayer(
          size: s * _breatheOuter.value,
          color: colors[0],
          blurRadius: 24,
          opacity: 0.22,
        ),
        // Layer tengah — fase 1/3 terlambat
        _OrbLayer(
          size: s * 0.65 * _breatheMid.value,
          color: colors[1],
          blurRadius: 16,
          opacity: 0.35,
        ),
        // Layer inti — fase 2/3 terlambat, paling jelas
        _OrbLayer(
          size: s * 0.35 * _breatheInner.value,
          color: colors[2],
          blurRadius: 10,
          opacity: 0.55,
        ),
      ],
    );
  }
}

/// Satu lapisan orb (blurred circle)
class _OrbLayer extends StatelessWidget {
  final double size;
  final Color color;
  final double blurRadius;
  final double opacity;

  const _OrbLayer({
    required this.size,
    required this.color,
    required this.blurRadius,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blurRadius,
        sigmaY: blurRadius,
        // clamp agar blur tidak "bocor" ke luar batas widget
        tileMode: TileMode.clamp,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

/// Helper: map insight severity ke AmbientMood
AmbientMood moodFromSeverity(String severity) {
  switch (severity.toLowerCase()) {
    case 'gentle':
    case 'positive':
      return AmbientMood.gentle;
    case 'notice':
    case 'warning':
    case 'critical':
      return AmbientMood.shifting;
    case 'info':
    default:
      return AmbientMood.focus;
  }
}
