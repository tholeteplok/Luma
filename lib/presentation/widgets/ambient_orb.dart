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
/// Tiga lingkaran berlapis yang bernapas.
/// Tidak ada angka. Tidak ada label nilai.
/// Warna mencerminkan ritme, bukan performa.
class AmbientOrb extends StatefulWidget {
  final AmbientMood mood;
  final double size;

  const AmbientOrb({
    super.key,
    this.mood = AmbientMood.focus,
    this.size = 160,
  });

  @override
  State<AmbientOrb> createState() => _AmbientOrbState();
}

class _AmbientOrbState extends State<AmbientOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnim;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _breatheAnim = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
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
          Color(0xFF4A6A9A), // lapis luar
          Color(0xFF5A5A8A), // lapis tengah
          Color(0xFF6B6BCA), // lapis inti
        ];
      case AmbientMood.gentle:
        return const [
          Color(0xFF2E5A50),
          Color(0xFF3A6A60),
          Color(0xFF6BA896),
        ];
      case AmbientMood.shifting:
        return const [
          Color(0xFF4A3A6A),
          Color(0xFF5A4A7A),
          Color(0xFF8A6B8A),
        ];
      case AmbientMood.rest:
        return const [
          Color(0xFF12121E),
          Color(0xFF1A1A2E),
          Color(0xFF2A2A3E),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _moodColors(widget.mood);
    final s = widget.size;

    return SizedBox(
      width: s,
      height: s,
      child: AnimatedBuilder(
        animation: _breatheAnim,
        builder: (context, _) {
          final scale = _breatheAnim.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Lapis 1 — paling luar, paling transparan
              _OrbLayer(
                size: s * scale,
                color: colors[0],
                blurRadius: 20,
                opacity: 0.15,
              ),
              // Lapis 2 — tengah
              _OrbLayer(
                size: s * 0.65 * scale,
                color: colors[1],
                blurRadius: 14,
                opacity: 0.25,
              ),
              // Lapis 3 — inti, paling jelas
              _OrbLayer(
                size: s * 0.35 * scale,
                color: colors[2],
                blurRadius: 8,
                opacity: 0.4,
              ),
            ],
          );
        },
      ),
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
        tileMode: TileMode.decal,
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
