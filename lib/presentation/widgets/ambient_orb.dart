import 'dart:math' as math;
import 'dart:ui' as ui;
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
  final Color fresnel;
  final double waveIntensity;
  final int wavePoints;
  final Duration breathDuration;
  final double blurSigma;

  const _OrbPalette({
    required this.core,
    required this.mid,
    required this.outer,
    required this.fresnel,
    required this.waveIntensity,
    required this.wavePoints,
    required this.breathDuration,
    required this.blurSigma,
  });
}

const _palettes = {
  OrbState.dawn: _OrbPalette(
    core:  Color(0xFF3D526B), // Muted ocean slate
    mid:   Color(0xFF253346), // Soft deep indigo-slate
    outer: Color(0xFF121B26), // Almost black blue
    fresnel: Color(0xFF48586E), // Very soft slate blue glow
    waveIntensity: 0.025,
    wavePoints: 7,
    breathDuration: Duration(milliseconds: 14000), // extremely slow breath
    blurSigma: 18.0,
  ),
  OrbState.calm: _OrbPalette(
    core:  Color(0xFF4E6D5F), // Muted soft sage
    mid:   Color(0xFF2C3E36), // Deep quiet forest-slate
    outer: Color(0xFF151F1B), // Very dark leaf green
    fresnel: Color(0xFF5D7D6F), // Muted light-green dew glow
    waveIntensity: 0.020,
    wavePoints: 8,
    breathDuration: Duration(milliseconds: 12000),
    blurSigma: 20.0,
  ),
  OrbState.wave: _OrbPalette(
    core:  Color(0xFF6E5676), // Muted quiet lavender-purple
    mid:   Color(0xFF3F3045), // Deep gray-purple
    outer: Color(0xFF1F1523), // Very dark night-purple
    fresnel: Color(0xFF7D6787), // Very soft lilac glow
    waveIntensity: 0.040,
    wavePoints: 11,
    breathDuration: Duration(milliseconds: 9000),
    blurSigma: 22.0,
  ),
  OrbState.mist: _OrbPalette(
    core:  Color(0xFF263230), // Muted quiet mist green
    mid:   Color(0xFF18201E),
    outer: Color(0xFF0E1312),
    fresnel: Color(0xFF2E3D3A),
    waveIntensity: 0.010,
    wavePoints: 6,
    breathDuration: Duration(milliseconds: 18000),
    blurSigma: 24.0,
  ),
};

/// Palette untuk varian baru (OrbVariant yang tidak ada di OrbState)
const _variantPalettes = <OrbVariant, _OrbPalette>{
  OrbVariant.dusk: _OrbPalette(
    core:  Color(0xFF6B4D3A), // Muted quiet copper
    mid:   Color(0xFF3D2A1F),
    outer: Color(0xFF1E130D),
    fresnel: Color(0xFF7D5F4A),
    waveIntensity: 0.015,
    wavePoints: 7,
    breathDuration: Duration(milliseconds: 16000),
    blurSigma: 22.0,
  ),
  OrbVariant.recover: _OrbPalette(
    core:  Color(0xFF466956), // Muted sage-mint
    mid:   Color(0xFF283D32),
    outer: Color(0xFF121E18),
    fresnel: Color(0xFF5B7E6B),
    waveIntensity: 0.018,
    wavePoints: 8,
    breathDuration: Duration(milliseconds: 13000),
    blurSigma: 20.0,
  ),
  OrbVariant.stellar: _OrbPalette(
    core:  Color(0xFF807A65), // Muted quiet gold
    mid:   Color(0xFF4F4B3C),
    outer: Color(0xFF26241D),
    fresnel: Color(0xFF96907C),
    waveIntensity: 0.008,
    wavePoints: 6,
    breathDuration: Duration(milliseconds: 20000),
    blurSigma: 26.0,
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
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _waveController;

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
      fresnel: base.fresnel,
      waveIntensity: waveIntensity,
      wavePoints: wavePoints,
      breathDuration: Duration(milliseconds: breathMs.round()),
      blurSigma: base.blurSigma,
    );
  }

  /// Key untuk AnimatedSwitcher — berubah saat variant atau state berubah
  Object get _switcherKey =>
      widget.profile?.orbVariant ?? widget.state;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: _activePalette.breathDuration,
    );
    _waveController = AnimationController(
      vsync: this,
      duration: _getWaveDuration(_activePalette),
    );

    if (!widget.reduceMotion) {
      _breathController.repeat(reverse: true);
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(AmbientOrb oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Cek apakah variant/state berubah
    final variantChanged = widget.profile?.orbVariant != oldWidget.profile?.orbVariant;
    final stateChanged = widget.state != oldWidget.state;
    final nostalgiaChanged = widget.nostalgiaActive != oldWidget.nostalgiaActive;

    if (variantChanged || stateChanged || nostalgiaChanged) {
      _breathController.duration = _activePalette.breathDuration;
      _waveController.duration = _getWaveDuration(_activePalette);

      if (!widget.reduceMotion) {
        if (!_breathController.isAnimating) _breathController.repeat(reverse: true);
        if (!_waveController.isAnimating) _waveController.repeat();
      }
    }

    if (widget.reduceMotion != oldWidget.reduceMotion) {
      if (widget.reduceMotion) {
        _breathController.stop();
        _waveController.stop();
      } else {
        _breathController.repeat(reverse: true);
        _waveController.repeat();
      }
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _activePalette;
    final canvasSize = widget.size * 1.9;

    return AnimatedSwitcher(
      // 3000ms untuk transisi antar variant (lambat & halus)
      duration: const Duration(milliseconds: 3000),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: RepaintBoundary(
        key: ValueKey(_switcherKey),
        child: ScaleTransition(
          scale: widget.reduceMotion
              ? const AlwaysStoppedAnimation(1.0)
              : Tween<double>(begin: 0.95, end: 1.05).animate(
                  CurvedAnimation(
                    parent: _breathController,
                    curve: Curves.easeInOut,
                  ),
                ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── 1. Liquid core dinamis (Blurred) ─────────────────────────────
              ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: palette.blurSigma,
                  sigmaY: palette.blurSigma,
                ),
                child: SizedBox(
                  width: canvasSize,
                  height: canvasSize,
                  child: widget.reduceMotion
                      ? CustomPaint(
                          painter: _LiquidPainter(
                            progress: 0.0,
                            palette: palette,
                            orbSize: widget.size,
                            centerOffsetY: _centerOffsetY,
                          ),
                        )
                      : AnimatedBuilder(
                          animation: _waveController,
                          builder: (_, child) => CustomPaint(
                            painter: _LiquidPainter(
                              progress: _waveController.value,
                              palette: palette,
                              orbSize: widget.size,
                              centerOffsetY: _centerOffsetY,
                            ),
                          ),
                        ),
                ),
              ),

              // ── 2. Glass Specular & Outline (Sharp) ──────────────────────────
              SizedBox(
                width: canvasSize,
                height: canvasSize,
                child: CustomPaint(
                  painter: _GlassOverlayPainter(
                    orbSize: widget.size,
                    fresnelColor: palette.fresnel,
                    nostalgiaActive: widget.nostalgiaActive,
                    centerOffsetY: _centerOffsetY,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dapatkan durasi putaran gelombang linear yang teramat lambat
  Duration _getWaveDuration(_OrbPalette palette) {
    if (palette.waveIntensity > 0.03) {
      return const Duration(milliseconds: 22000); // wave (slow wave)
    } else if (palette.waveIntensity < 0.015) {
      return const Duration(milliseconds: 50000); // mist/stellar (extremely slow)
    }
    return const Duration(milliseconds: 32000); // default
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
//  LIQUID PAINTER — Shifting fluid blobs (blurred)
// ─────────────────────────────────────────────────────────────────────────────

class _LiquidPainter extends CustomPainter {
  final double progress;
  final _OrbPalette palette;
  final double orbSize;
  final double centerOffsetY;

  const _LiquidPainter({
    required this.progress,
    required this.palette,
    required this.orbSize,
    this.centerOffsetY = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + centerOffsetY);
    final maxRadius = orbSize / 2;
    final t = progress * math.pi * 2;

    // ── Layer 0: Aura pendaran latar belakang ────────────────────────────────
    _paintAura(canvas, center, maxRadius);

    // ── Layer 1–3: Blob organik lambat dengan fase berbeda ───────────────────
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
        phaseOffset: math.pi * 0.7,
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

    // ── Layer 4: Titik cahaya pusat halus ───────────────────────────────────
    _paintCoreHighlight(canvas, center, maxRadius);
  }

  void _paintAura(Canvas canvas, Offset center, double maxRadius) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.mid.withValues(alpha: 0.15),
          palette.outer.withValues(alpha: 0.05),
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
      // Amplitudo ganda non-periodik yang dirotasi lambat
      final wave = math.sin(t * cfg.speedMultiplier + cfg.phaseOffset + i * 1.3) *
          math.cos(t * cfg.speedMultiplier * 0.6 + i * 0.9 + cfg.phaseOffset * 0.5);

      final r = maxRadius * cfg.radiusRatio * (1.0 + wave * palette.waveIntensity);
      points.add(Offset(
        center.dx + math.cos(angle) * r,
        center.dy + math.sin(angle) * r,
      ));
    }

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

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..shader = RadialGradient(
        colors: [
          cfg.color.withValues(alpha: cfg.opacity),
          cfg.color.withValues(alpha: cfg.opacity * 0.6),
          cfg.color.withValues(alpha: cfg.opacity * 0.15),
          cfg.color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.4, 0.8, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: maxRadius * cfg.radiusRatio),
      );

    canvas.drawPath(path, paint);
  }

  void _paintCoreHighlight(Canvas canvas, Offset center, double maxRadius) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.core.withValues(alpha: 0.35),
          palette.core.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: maxRadius * 0.18),
      );
    canvas.drawCircle(center, maxRadius * 0.18, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter old) =>
      old.progress != progress ||
      old.palette != palette ||
      old.orbSize != orbSize ||
      old.centerOffsetY != centerOffsetY;
}

// ─────────────────────────────────────────────────────────────────────────────
//  GLASS OVERLAY PAINTER — Specular, Rim, & Fresnel bounce (sharp & crisp)
// ─────────────────────────────────────────────────────────────────────────────

class _GlassOverlayPainter extends CustomPainter {
  final double orbSize;
  final Color fresnelColor;
  final bool nostalgiaActive;
  final double centerOffsetY;

  const _GlassOverlayPainter({
    required this.orbSize,
    required this.fresnelColor,
    required this.nostalgiaActive,
    required this.centerOffsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + centerOffsetY);
    final maxRadius = orbSize / 2;

    // ── 1. Fresnel Bottom-Right Bounce Light (Diperluas & Diperkaya) ─────────
    final fresnelPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          fresnelColor.withValues(alpha: 0.12), // Sedikit lebih kaya untuk efek kedalaman
          fresnelColor.withValues(alpha: 0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(center.dx + maxRadius * 0.45, center.dy + maxRadius * 0.45),
          radius: maxRadius * 0.85, // Area pendaran lebih luas
        ),
      );
    canvas.drawCircle(
      Offset(center.dx + maxRadius * 0.45, center.dy + maxRadius * 0.45),
      maxRadius * 0.85,
      fresnelPaint,
    );

    // ── 2. Specular Glare (Crescent Organik, Tapered & Soft Edge Blur) ───────
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 4); // Putar 45 derajat ke atas-kiri

    // Membuat path berbentuk sabit (crescent) yang meruncing di kedua ujungnya
    final outerRect = Rect.fromCircle(center: Offset.zero, radius: maxRadius * 0.93);
    final innerRect = Rect.fromCircle(
      center: Offset(0, maxRadius * 0.04), // Geser sedikit ke bawah untuk membuat taper (lancip di ujung)
      radius: maxRadius * 0.88,
    );

    final specularPath = Path()
      ..arcTo(outerRect, -math.pi * 0.85, math.pi * 0.70, true)
      ..arcTo(innerRect, -math.pi * 0.15, -math.pi * 0.70, false)
      ..close();

    final specularPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(-maxRadius * 0.6, -maxRadius * 0.9),
        Offset(maxRadius * 0.6, -maxRadius * 0.6),
        [
          Colors.white.withValues(alpha: 0.28), // Lebih terang di pusat refleksi
          Colors.white.withValues(alpha: 0.05), // Memudar anggun di tepian
        ],
      )
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 1.2); // Membuat tepian sangat lembut/blur alami

    canvas.drawPath(specularPath, specularPaint);
    canvas.restore();

    // ── 3. Dual-Tone Glass Rim (Outline Pembiasan) ───────────────────────────
    // A. Rim Terang (Top-Left dominant) - Dibuat Lebih Tebal & Nyata
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 // Dipertebal dari 0.65
      ..shader = ui.Gradient.linear(
        Offset(center.dx - maxRadius, center.dy - maxRadius),
        Offset(center.dx + maxRadius, center.dy + maxRadius),
        [
          Colors.white.withValues(alpha: 0.28), // Opacity ditingkatkan agar terlihat anggun di light mode
          Colors.white.withValues(alpha: 0.04),
        ],
        const [0.0, 1.0],
      );
    canvas.drawCircle(center, maxRadius, rimPaint);

    // B. Rim Gelap Refraktif (Bottom-Right dominant) - Memberikan kontras luar biasa di light mode
    final darkRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = ui.Gradient.linear(
        Offset(center.dx - maxRadius, center.dy - maxRadius),
        Offset(center.dx + maxRadius, center.dy + maxRadius),
        [
          Colors.black.withValues(alpha: 0.0),
          Colors.black.withValues(alpha: 0.08), // Sangat tipis, menyatu dengan shadow
        ],
        const [0.0, 1.0],
      );
    canvas.drawCircle(center, maxRadius, darkRimPaint);

    // ── 4. Nostalgia Gold Rim Aura ───────────────────────────────────────────
    if (nostalgiaActive) {
      const goldColor = Color(0xFFC18D52);
      final goldPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.80 // Dipertebal proporsional
        ..shader = ui.Gradient.linear(
          Offset(center.dx - maxRadius, center.dy - maxRadius),
          Offset(center.dx + maxRadius, center.dy + maxRadius),
          [
            goldColor.withValues(alpha: 0.12),
            goldColor.withValues(alpha: 0.02),
          ],
        );
      canvas.drawCircle(center, maxRadius + 3.0, goldPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlassOverlayPainter old) =>
      old.orbSize != orbSize ||
      old.fresnelColor != fresnelColor ||
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
