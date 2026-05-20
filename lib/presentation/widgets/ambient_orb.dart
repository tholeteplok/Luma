import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:luma/domain/services/orb_state_engine.dart';

export 'package:luma/domain/services/orb_state_engine.dart' show OrbState;

// ─────────────────────────────────────────────────────────────────────────────
//  VISUAL SPEC PER STATE
// ─────────────────────────────────────────────────────────────────────────────
//
//  Dawn  — 1-2 layer, blur tinggi (σ=24-28), opacity 0.4-0.55, napas lambat 6s
//  Calm  — 3 layer konsentris, blur rendah (σ=10-16), opacity 0.55-0.75, stabil
//  Wave  — 3-4 layer tumpang tindih, blur medium (σ=14-20), ripple cepat 3.5s
//  Mist  — 2 layer, blur sangat tinggi (σ=28-36), opacity 0.30-0.40, napas 8s
//
// ─────────────────────────────────────────────────────────────────────────────

/// Konfigurasi visual satu state orb
class _OrbConfig {
  final List<_LayerSpec> layers;
  final Duration breathDuration;
  final double breathRangeOuter; // ± dari 1.0
  final double breathRangeMid;
  final double breathRangeInner;

  const _OrbConfig({
    required this.layers,
    required this.breathDuration,
    this.breathRangeOuter = 0.06,
    this.breathRangeMid = 0.04,
    this.breathRangeInner = 0.02,
  });
}

class _LayerSpec {
  final double sizeRatio;   // relatif terhadap orbSize
  final Color color;
  final double blurRadius;
  final double opacity;
  final Offset offset;      // untuk Wave: layer tumpang tindih

  const _LayerSpec({
    required this.sizeRatio,
    required this.color,
    required this.blurRadius,
    required this.opacity,
    this.offset = Offset.zero,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  AMBIENT ORB WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// AmbientOrb — Cermin visual ritme digital Luma.
///
/// Berevolusi perlahan berdasarkan pola perilaku:
///   Dawn → Calm → Wave → Mist
///
/// Tidak ada label. Tidak ada angka. Hanya kehadiran.
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
  late List<Animation<double>> _scaleAnims;
  late List<Animation<Offset>> _offsetAnims; // untuk Wave ripple

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _configFor(widget.state).breathDuration,
    );
    _buildAnimations(widget.state);
    if (!widget.reduceMotion) _controller.repeat();
  }

  @override
  void didUpdateWidget(AmbientOrb oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state != oldWidget.state) {
      final newConfig = _configFor(widget.state);
      _controller.duration = newConfig.breathDuration;
      _buildAnimations(widget.state);
      if (!widget.reduceMotion) _controller.repeat();
    }

    if (widget.reduceMotion != oldWidget.reduceMotion) {
      if (widget.reduceMotion) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
    }
  }

  void _buildAnimations(OrbState state) {
    final cfg = _configFor(state);
    final ranges = [cfg.breathRangeOuter, cfg.breathRangeMid, cfg.breathRangeInner];
    final phaseOffsets = [0.0, 1 / 3, 2 / 3];

    _scaleAnims = List.generate(
      cfg.layers.length.clamp(1, 4),
      (i) {
        final range = i < ranges.length ? ranges[i] : cfg.breathRangeInner;
        final phase = i < phaseOffsets.length ? phaseOffsets[i] : 0.0;
        return _buildScaleAnim(range: range, phaseOffset: phase);
      },
    );

    // Wave: layer ke-3 dan ke-4 punya offset horizontal yang berosilasi
    if (state == OrbState.wave) {
      _offsetAnims = [
        _buildOffsetAnim(Offset.zero),
        _buildOffsetAnim(Offset.zero),
        _buildOffsetAnim(const Offset(0.12, 0.0)),  // bergeser kanan
        _buildOffsetAnim(const Offset(-0.10, 0.06)), // bergeser kiri-bawah
      ];
    } else {
      _offsetAnims = List.generate(
        cfg.layers.length,
        (_) => _buildOffsetAnim(Offset.zero),
      );
    }
  }

  Animation<double> _buildScaleAnim({
    required double range,
    required double phaseOffset,
  }) {
    final startVal = 1.0 - range + range * 2 *
        (0.5 + 0.5 * math.sin(phaseOffset * 2 * math.pi));

    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: startVal, end: 1.0 + range),
        weight: (1.0 - phaseOffset) * 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0 + range, end: 1.0 - range),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0 - range, end: startVal),
        weight: phaseOffset * 50,
      ),
    ]).animate(_controller);
  }

  Animation<Offset> _buildOffsetAnim(Offset maxOffset) {
    if (maxOffset == Offset.zero) {
      return ConstantTween<Offset>(Offset.zero).animate(_controller);
    }
    return TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: maxOffset),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: maxOffset, end: Offset.zero),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    // Canvas harus cukup besar untuk blur terbesar (σ=36 → butuh ~108px padding)
    // Rumus: padding = blurRadius * 3 (agar blur tidak terpotong di tepi)
    final maxBlur = _configFor(widget.state).layers
        .map((l) => l.blurRadius)
        .reduce((a, b) => a > b ? a : b);
    final canvasSize = s + maxBlur * 3;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: child,
      ),
      child: RepaintBoundary(
        key: ValueKey(widget.state),
        child: SizedBox(
          width: canvasSize,
          height: canvasSize,
          child: widget.reduceMotion
              ? _buildStatic(s)
              : AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) => _buildAnimated(s),
                ),
        ),
      ),
    );
  }

  Widget _buildStatic(double s) {
    final cfg = _configFor(widget.state);
    return Stack(
      alignment: Alignment.center,
      children: cfg.layers.map((layer) {
        return _OrbLayer(
          size: s * layer.sizeRatio,
          color: layer.color,
          blurRadius: layer.blurRadius,
          opacity: layer.opacity,
          offset: Offset.zero,
        );
      }).toList(),
    );
  }

  Widget _buildAnimated(double s) {
    final cfg = _configFor(widget.state);
    return Stack(
      alignment: Alignment.center,
      children: List.generate(cfg.layers.length, (i) {
        final layer = cfg.layers[i];
        final scale = i < _scaleAnims.length ? _scaleAnims[i].value : 1.0;
        final offset = i < _offsetAnims.length
            ? _offsetAnims[i].value * s
            : Offset.zero;
        return _OrbLayer(
          size: s * layer.sizeRatio * scale,
          color: layer.color,
          blurRadius: layer.blurRadius,
          opacity: layer.opacity,
          offset: offset,
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  LAYER WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class _OrbLayer extends StatelessWidget {
  final double size;
  final Color color;
  final double blurRadius;
  final double opacity;
  final Offset offset;

  const _OrbLayer({
    required this.size,
    required this.color,
    required this.blurRadius,
    required this.opacity,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Transform.translate(
        offset: offset,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: blurRadius,
            sigmaY: blurRadius,
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
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  VISUAL CONFIG PER STATE
// ─────────────────────────────────────────────────────────────────────────────

_OrbConfig _configFor(OrbState state) {
  return switch (state) {
    // ── Dawn: 2 layer, blur tinggi, napas lambat 6s ──────────────────────────
    OrbState.dawn => const _OrbConfig(
        breathDuration: Duration(milliseconds: 6000),
        breathRangeOuter: 0.07,
        breathRangeMid: 0.04,
        breathRangeInner: 0.02,
        layers: [
          _LayerSpec(
            sizeRatio: 0.90,
            color: Color(0xFF2A2A5A), // indigo redup
            blurRadius: 28,
            opacity: 0.40,
          ),
          _LayerSpec(
            sizeRatio: 0.45,
            color: Color(0xFF3A3A7A), // indigo sedikit lebih terang
            blurRadius: 20,
            opacity: 0.50,
          ),
        ],
      ),

    // ── Calm: 3 layer konsentris, blur rendah, stabil ────────────────────────
    OrbState.calm => const _OrbConfig(
        breathDuration: Duration(milliseconds: 5000),
        breathRangeOuter: 0.05,
        breathRangeMid: 0.03,
        breathRangeInner: 0.02,
        layers: [
          _LayerSpec(
            sizeRatio: 1.00,
            color: Color(0xFF3A5A8A), // biru dalam
            blurRadius: 16,
            opacity: 0.55,
          ),
          _LayerSpec(
            sizeRatio: 0.65,
            color: Color(0xFF5050A0), // indigo
            blurRadius: 12,
            opacity: 0.65,
          ),
          _LayerSpec(
            sizeRatio: 0.35,
            color: Color(0xFF7070D0), // biru-ungu terang
            blurRadius: 8,
            opacity: 0.75,
          ),
        ],
      ),

    // ── Wave: 4 layer tumpang tindih, ripple cepat 3.5s ─────────────────────
    OrbState.wave => const _OrbConfig(
        breathDuration: Duration(milliseconds: 3500),
        breathRangeOuter: 0.08,
        breathRangeMid: 0.06,
        breathRangeInner: 0.05,
        layers: [
          _LayerSpec(
            sizeRatio: 0.90,
            color: Color(0xFF3A2A5A), // ungu tua
            blurRadius: 20,
            opacity: 0.45,
          ),
          _LayerSpec(
            sizeRatio: 0.65,
            color: Color(0xFF5A3A7A), // ungu medium
            blurRadius: 16,
            opacity: 0.50,
          ),
          _LayerSpec(
            sizeRatio: 0.50,
            color: Color(0xFF7A4A9A), // ungu lebih terang
            blurRadius: 14,
            opacity: 0.45,
            offset: Offset(0.12, 0.0), // tumpang tindih kanan
          ),
          _LayerSpec(
            sizeRatio: 0.40,
            color: Color(0xFF9A6AAA), // lavender
            blurRadius: 12,
            opacity: 0.40,
            offset: Offset(-0.10, 0.06), // tumpang tindih kiri-bawah
          ),
        ],
      ),

    // ── Mist: 2 layer, blur sangat tinggi, napas sangat lambat 8s ───────────
    OrbState.mist => const _OrbConfig(
        breathDuration: Duration(milliseconds: 8000),
        breathRangeOuter: 0.03,
        breathRangeMid: 0.02,
        breathRangeInner: 0.01,
        layers: [
          _LayerSpec(
            sizeRatio: 1.00,
            color: Color(0xFF4A4A6A), // abu-abu kebiruan
            blurRadius: 36,
            opacity: 0.30,
          ),
          _LayerSpec(
            sizeRatio: 0.55,
            color: Color(0xFF5A5A7A), // sedikit lebih terang
            blurRadius: 28,
            opacity: 0.38,
          ),
        ],
      ),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  LEGACY COMPAT — untuk kode yang masih pakai AmbientMood
// ─────────────────────────────────────────────────────────────────────────────

/// @deprecated Gunakan OrbState langsung.
/// Dipertahankan agar tidak ada breaking change di kode lain.
@Deprecated('Gunakan OrbState. AmbientMood akan dihapus di versi berikutnya.')
enum AmbientMood { focus, gentle, shifting, rest }

/// @deprecated
@Deprecated('Gunakan OrbState langsung.')
OrbState orbStateFromMood(AmbientMood mood) {
  return switch (mood) {
    AmbientMood.focus => OrbState.calm,
    AmbientMood.gentle => OrbState.dawn,
    AmbientMood.shifting => OrbState.wave,
    AmbientMood.rest => OrbState.mist,
  };
}

/// Helper: map insight severity ke OrbState (untuk fallback saat engine belum siap)
OrbState orbStateFromSeverity(String severity) {
  return switch (severity.toLowerCase()) {
    'gentle' || 'positive' => OrbState.calm,
    'notice' || 'warning' || 'critical' => OrbState.wave,
    _ => OrbState.calm,
  };
}
