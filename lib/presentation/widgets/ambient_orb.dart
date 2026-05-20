import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:luma/domain/entities/ambience_profile.dart';
import 'package:luma/domain/services/orb_state_engine.dart';

export 'package:luma/domain/entities/ambience_profile.dart'
    show OrbVariant, BiologicalTimePhase, WeeklyRhythmState, AmbienceProfile;
export 'package:luma/domain/services/orb_state_engine.dart' show OrbState;

// ─────────────────────────────────────────────────────────────────────────────
//  PALETTE — Bioluminescence (Laut Dalam) + Adaptive Ambience variants
//
//  Palette: Emerald & Gold (#EEE8B2, #C18D52, #081B1B, #203B37, #5A8F76, #96CDB0)
//
//  dawn    → teal sangat gelap, seperti laut sebelum fajar
//  calm    → hijau laut dalam, stabil dan tenang
//  wave    → ungu-teal, gelisah (ungu valid untuk varian orb)
//  mist    → abu-abu kehijauan, kehadiran tanpa bentuk
//  dusk    → oranye redup, malam yang panjang
//  recover → hijau sage muda, mengembang pelan
//  stellar → krem-gold, denyut sangat pelan
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
    core:  Color(0xFF1A5A4A),
    mid:   Color(0xFF0F3A2E),
    outer: Color(0xFF081B1B),
    waveIntensity: 0.045,
    wavePoints: 7,
    breathDuration: Duration(milliseconds: 6500),
  ),
  OrbState.calm: _OrbPalette(
    core:  Color(0xFF5A8F76), // #5A8F76
    mid:   Color(0xFF203B37), // #203B37
    outer: Color(0xFF0F2626),
    waveIntensity: 0.030,
    wavePoints: 8,
    breathDuration: Duration(milliseconds: 5500),
  ),
  OrbState.wave: _OrbPalette(
    core:  Color(0xFF6B5A8A), // ungu-teal — gelisah
    mid:   Color(0xFF3A2A5A),
    outer: Color(0xFF1A0F2E),
    waveIntensity: 0.075,
    wavePoints: 11,
    breathDuration: Duration(milliseconds: 3800),
  ),
  OrbState.mist: _OrbPalette(
    core:  Color(0xFF1E2E2A),
    mid:   Color(0xFF141E1C),
    outer: Color(0xFF0A1412),
    waveIntensity: 0.018,
    wavePoints: 6,
    breathDuration: Duration(milliseconds: 9000),
  ),
};

/// Palette untuk varian baru (OrbVariant yang tidak ada di OrbState)
const _variantPalettes = <OrbVariant, _OrbPalette>{
  OrbVariant.dusk: _OrbPalette(
    core:  Color(0xFF5A3010), // oranye redup — malam yang panjang
    mid:   Color(0xFF3A1E08),
    outer: Color(0xFF1A0A04),
    waveIntensity: 0.025,
    wavePoints: 7,
    breathDuration: Duration(milliseconds: 8000),
  ),
  OrbVariant.recover: _OrbPalette(
    core:  Color(0xFF2A5A3A), // hijau sage muda — mengembang pelan
    mid:   Color(0xFF1A3A26),
    outer: Color(0xFF0C2018),
    waveIntensity: 0.022,
    wavePoints: 8,
    breathDuration: Duration(milliseconds: 7500),
  ),
  OrbVariant.stellar: _OrbPalette(
    core:  Color(0xFFEEE8B2), // #EEE8B2 — krem keemasan
    mid:   Color(0xFFC18D52), // #C18D52 — gold
    outer: Color(0xFF3A2A10),
    waveIntensity: 0.012, // hampir tidak bergerak
    wavePoints: 6,
    breathDuration: Duration(milliseconds: 11000), // denyut sangat pelan
  ),
};

/// Ambil palette dari OrbVariant — cek variantPalettes dulu, fallback ke _palettes
_OrbPalette _paletteForVariant(OrbVariant variant) {
  if (_variantPalettes.containsKey(variant)) {
    return _variantPalettes[variant]!;
  }
  // Map OrbVariant → OrbState untuk varian yang sama
  final stateMap = {
    OrbVariant.dawn: OrbState.dawn,
    OrbVariant.calm: OrbState.calm,
    OrbVariant.wave: OrbState.wave,
    OrbVariant.mist: OrbState.mist,
  };
  return _palettes[stateMap[variant] ?? OrbState.dawn]!;
}

// ─────────────────────────────────────────────────────────────────────────────
//  AMBIENT ORB WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// AmbientOrb — Cermin visual ritme digital Luma.
///
/// Menggunakan CustomPainter dengan bezier organik per titik.
/// Support dua mode:
/// - Legacy: `state` (OrbState) — backward compat
/// - Adaptive: `profile` (AmbienceProfile) — full adaptive ambience
class AmbientOrb extends StatefulWidget {
  /// Legacy: OrbState langsung (backward compat)
  final OrbState state;

  /// Adaptive: AmbienceProfile dari AdaptiveAmbienceEngine (opsional)
  /// Jika diberikan, mengoverride `state` dan menerapkan modifikasi BiologicalTimePhase + WeeklyRhythmState
  final AmbienceProfile? profile;

  final double size;
  final bool reduceMotion;

  /// Aktifkan NostalgiaEffect — aura gold tipis + napas lebih lambat
  final bool nostalgiaActive;

  const AmbientOrb({
    super.key,
    this.state = OrbState.dawn,
    this.profile,
    this.size = 160,
    this.reduceMotion = false,
    this.nostalgiaActive = false,
  });

  @override
  State<AmbientOrb> createState() => _AmbientOrbState();
}

class _AmbientOrbState extends State<AmbientOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// Palette aktif — dihitung dari profile atau state
  _OrbPalette get _activePalette {
    if (widget.profile != null) {
      return _applyAmbienceModifiers(
        _paletteForVariant(widget.profile!.orbVariant),
        widget.profile!,
      );
    }
    return _palettes[widget.state]!;
  }

  /// Terapkan modifikasi dari BiologicalTimePhase dan WeeklyRhythmState
  _OrbPalette _applyAmbienceModifiers(_OrbPalette base, AmbienceProfile profile) {
    double breathMs = base.breathDuration.inMilliseconds.toDouble();
    double waveIntensity = base.waveIntensity;
    int wavePoints = base.wavePoints;

    // BiologicalTimePhase modifikasi
    switch (profile.timePhase) {
      case BiologicalTimePhase.personalMorning:
        breathMs *= 1.2; // napas lebih lambat di pagi
      case BiologicalTimePhase.personalNight:
        breathMs *= 1.3;
        waveIntensity *= 0.8; // lebih tenang di malam
      case BiologicalTimePhase.personalEvening:
      case BiologicalTimePhase.personalMidday:
        break; // default
    }

    // WeeklyRhythmState modifikasi
    switch (profile.rhythmState) {
      case WeeklyRhythmState.clear:
        wavePoints = wavePoints.clamp(1, 8);
        waveIntensity = waveIntensity.clamp(0.0, 0.035);
      case WeeklyRhythmState.dim:
        wavePoints = wavePoints.clamp(10, 16);
        waveIntensity = waveIntensity.clamp(0.060, 1.0);
      case WeeklyRhythmState.stable:
      case WeeklyRhythmState.undulating:
        break;
    }

    // NostalgiaEffect: napas lebih lambat
    if (widget.nostalgiaActive) {
      breathMs *= 1.25;
    }

    return _OrbPalette(
      core: base.core,
      mid: base.mid,
      outer: base.outer,
      waveIntensity: waveIntensity,
      wavePoints: wavePoints,
      breathDuration: Duration(milliseconds: breathMs.round()),
    );
  }

  /// Key untuk AnimatedSwitcher — berubah saat variant atau state berubah
  Object get _switcherKey =>
      widget.profile?.orbVariant ?? widget.state;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _activePalette.breathDuration,
    );
    if (!widget.reduceMotion) _controller.repeat();
  }

  @override
  void didUpdateWidget(AmbientOrb oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Cek apakah variant/state berubah
    final variantChanged = widget.profile?.orbVariant != oldWidget.profile?.orbVariant;
    final stateChanged = widget.state != oldWidget.state;
    final nostalgiaChanged = widget.nostalgiaActive != oldWidget.nostalgiaActive;

    if (variantChanged || stateChanged || nostalgiaChanged) {
      _controller.duration = _activePalette.breathDuration;
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
    final palette = _activePalette;
    final canvasSize = widget.size * 1.9;

    return AnimatedSwitcher(
      // 3000ms untuk transisi antar variant (lebih lambat = lebih halus)
      duration: const Duration(milliseconds: 3000),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: RepaintBoundary(
        key: ValueKey(_switcherKey),
        child: SizedBox(
          width: canvasSize,
          height: canvasSize,
          child: widget.reduceMotion
              ? CustomPaint(
                  painter: _OrbPainter(
                    progress: 0.0,
                    palette: palette,
                    orbSize: widget.size,
                    nostalgiaActive: widget.nostalgiaActive,
                    // personalEvening: geser pusat ke bawah
                    centerOffsetY: _centerOffsetY,
                  ),
                )
              : AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) => CustomPaint(
                    painter: _OrbPainter(
                      progress: _controller.value,
                      palette: palette,
                      orbSize: widget.size,
                      nostalgiaActive: widget.nostalgiaActive,
                      centerOffsetY: _centerOffsetY,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  /// Offset vertikal pusat orb untuk personalEvening (8% dari orbSize)
  double get _centerOffsetY {
    if (widget.profile?.timePhase == BiologicalTimePhase.personalEvening) {
      return widget.size * 0.08;
    }
    return 0.0;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ORB PAINTER — bezier organik multi-layer
// ─────────────────────────────────────────────────────────────────────────────

class _OrbPainter extends CustomPainter {
  final double progress;
  final _OrbPalette palette;
  final double orbSize;
  final bool nostalgiaActive;
  final double centerOffsetY;

  const _OrbPainter({
    required this.progress,
    required this.palette,
    required this.orbSize,
    this.nostalgiaActive = false,
    this.centerOffsetY = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Terapkan centerOffsetY untuk personalEvening (pusat bergeser ke bawah)
    final center = Offset(size.width / 2, size.height / 2 + centerOffsetY);
    final maxRadius = orbSize / 2;
    final t = progress * math.pi * 2;

    // ── Layer 0: Aura luar + NostalgiaEffect ─────────────────────────────────
    _paintAura(canvas, center, maxRadius);
    if (nostalgiaActive) {
      _paintNostalgiaGlow(canvas, center, maxRadius);
    }

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
          Colors.transparent,        ],
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

  /// NostalgiaEffect — aura gold tipis di sekitar orb
  /// Muncul saat user membuka insight >30 hari lalu
  void _paintNostalgiaGlow(Canvas canvas, Offset center, double maxRadius) {
    const goldColor = Color(0xFFC18D52); // #C18D52
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          goldColor.withValues(alpha: 0.08),
          goldColor.withValues(alpha: 0.15),
          goldColor.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 0.70, 0.85, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: maxRadius * 1.6),
      );
    canvas.drawCircle(center, maxRadius * 1.6, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter old) =>
      old.progress != progress ||
      old.palette != palette ||
      old.orbSize != orbSize ||
      old.nostalgiaActive != nostalgiaActive ||
      old.centerOffsetY != centerOffsetY;
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
