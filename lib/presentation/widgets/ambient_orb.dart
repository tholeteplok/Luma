import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:luma/domain/services/orb_state_engine.dart';

export 'package:luma/domain/services/orb_state_engine.dart' show OrbState;

// ─────────────────────────────────────────────────────────────────────────────
//  PALETTE — Bioluminescence (Laut Dalam)
//
//  Palette: Emerald & Gold (#EEE8B2, #C18D52, #081B1B, #203B37, #5A8F76, #96CDB0)
//
//  Dawn  → teal sangat gelap, seperti laut sebelum fajar
//  Calm  → hijau laut dalam, stabil dan tenang
//  Wave  → teal-biru bergerak, seperti ombak malam
//  Mist  → abu-abu kehijauan, kehadiran tanpa bentuk
// ─────────────────────────────────────────────────────────────────────────────

class _OrbPalette {
  final Color core;
  final Color mid;
  final Color outer;
  final double waveIntensity;
  final int wavePoints;
  final Duration breathDuration;

  const _OrbPalette({
    required this.core,
    required this.mid,
    required this.outer,
    required this.waveIntensity,
    required this.wavePoints,
    required this.breathDuration,
  });
}

const _palettes = {
  OrbState.dawn: _OrbPalette(
    core:  Color(0xFF1A5A4A), // teal redup — belum sepenuhnya terbentuk
    mid:   Color(0xFF0F3A2E),
    outer: Color(0xFF081B1B), // #081B1B
    waveIntensity: 0.045,
    wavePoints: 7,
    breathDuration: Duration(milliseconds: 6500),
  ),
  OrbState.calm: _OrbPalette(
    core:  Color(0xFF5A8F76), // #5A8F76 — hijau laut dalam
    mid:   Color(0xFF203B37), // #203B37
    outer: Color(0xFF0F2626),
    waveIntensity: 0.030,
    wavePoints: 8,
    breathDuration: Duration(milliseconds: 5500),
  ),
  OrbState.wave: _OrbPalette(
    core:  Color(0xFF3A6A5A), // teal bergerak
    mid:   Color(0xFF1E4A3A),
    outer: Color(0xFF0F2E24),
    waveIntensity: 0.075,
    wavePoints: 11,
    breathDuration: Duration(milliseconds: 3800),
  ),
  OrbState.mist: _OrbPalette(
    core:  Color(0xFF1E2E2A), // abu-abu kehijauan — hadir tanpa bentuk
    mid:   Color(0xFF141E1C),
    outer: Color(0xFF0A1412),
    waveIntensity: 0.018,
    wavePoints: 6,
    breathDuration: Duration(milliseconds: 9000),
  ),
};

// ─────────────────────────────────────────────────────────────────────────────
//  AMBIENT ORB WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// AmbientOrb — Cermin visual ritme digital Luma.
///
/// Menggunakan CustomPainter dengan bezier organik per titik —
/// bukan ScaleTransition yang mekanis.
/// Setiap layer bergerak dengan fase sinus berbeda (staggered),
/// menciptakan ilusi cairan yang bernapas.
class AmbientOrb extends StatefulWidget {
  final OrbState state;
  final double size;
  final bool reduceMotion;

  const AmbientOrb({
    super.key,
    this.state = OrbState.dawn,
    this.size = 160,
    this.reduceMotion = false,
  });

  @override
  State<AmbientOrb> createState() => _AmbientOrbState();
}

class _AmbientOrbState extends State<AmbientOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _palettes[widget.state]!.breathDuration,
    );
    if (!widget.reduceMotion) _controller.repeat();
  }

  @override
  void didUpdateWidget(AmbientOrb oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state != oldWidget.state) {
      _controller.duration = _palettes[widget.state]!.breathDuration;
      if (!widget.reduceMotion) _controller.repeat();
    }

    if (widget.reduceMotion != oldWidget.reduceMotion) {
      widget.reduceMotion ? _controller.stop() : _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palettes[widget.state]!;
    // Canvas lebih besar agar aura luar tidak terpotong
    // Aura spread = size * 0.4, jadi padding = size * 0.45 di setiap sisi
    final canvasSize = widget.size * 1.9;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: RepaintBoundary(
        key: ValueKey(widget.state),
        child: SizedBox(
          width: canvasSize,
          height: canvasSize,
          child: widget.reduceMotion
              ? CustomPaint(
                  painter: _OrbPainter(
                    progress: 0.0,
                    palette: palette,
                    orbSize: widget.size,
                  ),
                )
              : AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) => CustomPaint(
                    painter: _OrbPainter(
                      progress: _controller.value,
                      palette: palette,
                      orbSize: widget.size,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ORB PAINTER — bezier organik multi-layer
// ─────────────────────────────────────────────────────────────────────────────

class _OrbPainter extends CustomPainter {
  final double progress;
  final _OrbPalette palette;
  final double orbSize;

  const _OrbPainter({
    required this.progress,
    required this.palette,
    required this.orbSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = orbSize / 2;
    final t = progress * math.pi * 2; // waktu dalam radian

    // ── Layer 0: Aura luar — pendaran ambient statis ──────────────────────────
    // Tidak bergerak, hanya memberikan "kedalaman" di sekitar orb
    _paintAura(canvas, center, maxRadius);

    // ── Layer 1–3: Blob organik dengan fase berbeda ───────────────────────────
    // Layer terluar → terdalam, opacity naik, ukuran turun
    final layerConfigs = [
      _LayerConfig(
        radiusRatio: 0.88,
        color: palette.outer,
        opacity: 0.55,
        phaseOffset: 0.0,
        speedMultiplier: 1.0,
      ),
      _LayerConfig(
        radiusRatio: 0.70,
        color: palette.mid,
        opacity: 0.70,
        phaseOffset: math.pi * 0.7,  // fase berbeda — tidak sinkron
        speedMultiplier: 1.15,
      ),
      _LayerConfig(
        radiusRatio: 0.50,
        color: palette.core,
        opacity: 0.85,
        phaseOffset: math.pi * 1.4,
        speedMultiplier: 0.85,
      ),
    ];

    for (final cfg in layerConfigs) {
      _paintBlob(canvas, center, maxRadius, t, cfg);
    }

    // ── Layer 4: Highlight kecil di tengah — titik cahaya ────────────────────
    _paintCoreHighlight(canvas, center, maxRadius);
  }

  void _paintAura(Canvas canvas, Offset center, double maxRadius) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.mid.withValues(alpha: 0.18),
          palette.outer.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: maxRadius * 1.8),
      );
    canvas.drawCircle(center, maxRadius * 1.8, paint);
  }

  void _paintBlob(
    Canvas canvas,
    Offset center,
    double maxRadius,
    double t,
    _LayerConfig cfg,
  ) {
    final n = palette.wavePoints;
    final angleStep = (math.pi * 2) / n;
    final points = <Offset>[];

    for (int i = 0; i < n; i++) {
      final angle = i * angleStep;
      // Harmoni sinus ganda — menghasilkan modulasi tidak periodik sempurna
      // sehingga terasa acak seperti cairan, bukan mekanis
      final wave = math.sin(t * cfg.speedMultiplier + cfg.phaseOffset + i * 1.3) *
          math.cos(t * cfg.speedMultiplier * 0.6 + i * 0.9 + cfg.phaseOffset * 0.5);

      final r = maxRadius * cfg.radiusRatio * (1.0 + wave * palette.waveIntensity);
      points.add(Offset(
        center.dx + math.cos(angle) * r,
        center.dy + math.sin(angle) * r,
      ));
    }

    // Hubungkan titik dengan quadratic bezier — kurva halus, bukan garis lurus
    final path = Path();
    path.moveTo(
      (points.last.dx + points.first.dx) / 2,
      (points.last.dy + points.first.dy) / 2,
    );
    for (int i = 0; i < n; i++) {
      final curr = points[i];
      final next = points[(i + 1) % n];
      final midX = (curr.dx + next.dx) / 2;
      final midY = (curr.dy + next.dy) / 2;
      path.quadraticBezierTo(curr.dx, curr.dy, midX, midY);
    }
    path.close();

    // Gradient radial dari inti ke tepi — memberikan kedalaman volumetrik
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..shader = RadialGradient(
        colors: [
          cfg.color.withValues(alpha: cfg.opacity),
          cfg.color.withValues(alpha: cfg.opacity * 0.5),
          cfg.color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: maxRadius * cfg.radiusRatio),
      );

    canvas.drawPath(path, paint);
  }

  void _paintCoreHighlight(Canvas canvas, Offset center, double maxRadius) {
    // Titik cahaya kecil di tengah — seperti bioluminescence yang paling terang
    // Tidak bergerak, memberikan "pusat gravitasi" visual
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.core.withValues(alpha: 0.45),
          palette.core.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: maxRadius * 0.18),
      );
    canvas.drawCircle(center, maxRadius * 0.18, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter old) =>
      old.progress != progress ||
      old.palette != palette ||
      old.orbSize != orbSize;
}

// ─────────────────────────────────────────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _LayerConfig {
  final double radiusRatio;
  final Color color;
  final double opacity;
  final double phaseOffset;
  final double speedMultiplier;

  const _LayerConfig({
    required this.radiusRatio,
    required this.color,
    required this.opacity,
    required this.phaseOffset,
    required this.speedMultiplier,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  LEGACY COMPAT
// ─────────────────────────────────────────────────────────────────────────────

@Deprecated('Gunakan OrbState. AmbientMood akan dihapus.')
enum AmbientMood { focus, gentle, shifting, rest }

@Deprecated('Gunakan OrbState langsung.')
OrbState orbStateFromMood(AmbientMood mood) => switch (mood) {
      AmbientMood.focus => OrbState.calm,
      AmbientMood.gentle => OrbState.dawn,
      AmbientMood.shifting => OrbState.wave,
      AmbientMood.rest => OrbState.mist,
    };

OrbState orbStateFromSeverity(String severity) => switch (severity.toLowerCase()) {
      'gentle' || 'positive' => OrbState.calm,
      'notice' || 'warning' || 'critical' => OrbState.wave,
      _ => OrbState.calm,
    };
