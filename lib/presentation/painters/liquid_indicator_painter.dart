import 'dart:math' as math;
import 'package:flutter/material.dart';

/// LiquidIndicatorPainter — CustomPainter untuk merender indikator tab aktif
/// berbentuk Mini Ambient Orb (gelembung air biologis kristal) di belakang ikon aktif.
///
/// Menyajikan pergerakan dinamis:
/// 1. "Icon Centered" - Terpusat secara presisi pada ikon navigasi.
/// 2. "Gravity Dip" - Melengkung vertikal ke bawah saat transisi meluncur horizontal.
/// 3. "Crescent Specular Glare" - Aksen pantulan kaca berbentuk sabit berkilau pada sudut kiri-atas bola.
class LiquidIndicatorPainter extends CustomPainter {
  /// Animasi perpindahan tab (0.0 hingga tabCount - 1.0)
  final double activeTabProgress;

  /// Nilai animasi gelombang berkelanjutan (0.0 hingga 1.0) untuk denyut permukaan air
  final double waveAnimationValue;

  /// Jumlah tab keseluruhan di navbar
  final int tabCount;

  /// Warna dasar aksen Luma
  final Color accentColor;

  /// Warna terang aksen Luma untuk pendaran bioluminescence
  final Color accentLightColor;

  const LiquidIndicatorPainter({
    required this.activeTabProgress,
    required this.waveAnimationValue,
    required this.tabCount,
    required this.accentColor,
    required this.accentLightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (tabCount <= 0) return;

    // 1. Hitung dimensi dasar tab & transisi horizontal
    final double tabWidth = size.width / tabCount;
    final double targetX = (activeTabProgress + 0.5) * tabWidth;

    // 2. Hitung efek Stretch & Squash berdasarkan sisa fraksional perpindahan (kecepatan pergerakan)
    final double rounded = activeTabProgress.roundToDouble();
    final double fraction = (activeTabProgress - rounded).abs();
    // stretch memuncak di 1.0 saat berada tepat di tengah-tengah antar tab
    final double stretch = 1.0 - (fraction * 2.0 - 1.0).abs();

    // 3. Hitung Dinamika Vertikal (Gravity Dip)
    // baseCenterY = 16.0 px (visual center di belakang ikon terangkat)
    // Di tengah pergerakan, orb air akan turun secara vertikal (sinking dip) ke level 24.0 px
    final double baseCenterY = 16.0;
    final double targetY = baseCenterY + stretch * 8.0;
    final Offset center = Offset(targetX, targetY);

    // 4. Penyelarasan Dimensi Bulat (Mini Orb Shape)
    // Diameter bola air disesuaikan menjadi bulat presisi (~32-34px) agar selaras membungkus ikon (diameter 22px)
    const double baseRadiusX = 16.5;
    const double baseRadiusY = 16.5;

    // Terapkan stretch (melebar horizontal) dan squash (memipih vertikal) saat meluncur cepat
    final double radiusX = baseRadiusX * (1.0 + stretch * 0.38); // melebar hingga +38%
    final double radiusY = baseRadiusY * (1.0 - stretch * 0.28); // memipih hingga -28%

    // 5. Bangun titik-titik polygon radial melingkar (12 titik) untuk getaran permukaan air
    final int pointsCount = 12;
    final double angleStep = (math.pi * 2) / pointsCount;
    final List<Offset> points = [];

    final double t = waveAnimationValue * math.pi * 2;
    // Gelombang permukaan air mengecil saat bergerak cepat untuk kestabilan visual
    final double waveIntensity = 0.06 * (1.0 - stretch * 0.5);

    for (int i = 0; i < pointsCount; i++) {
      final double angle = i * angleStep;

      // Modulasi matematika gelombang ganda untuk pergerakan air organik non-simetris
      final double wave = math.sin(t + i * 1.5) * math.cos(t * 0.7 - i * 0.9);
      
      // Hitung radius radial terdistorsi
      final double currentRadiusX = radiusX * (1.0 + wave * waveIntensity);
      final double currentRadiusY = radiusY * (1.0 + wave * waveIntensity * 0.85);

      final double px = center.dx + math.cos(angle) * currentRadiusX;
      final double py = center.dy + math.sin(angle) * currentRadiusY;
      points.add(Offset(px, py));
    }

    // 6. Hubungkan titik menggunakan spline bezier kuadratik tertutup
    final Path path = Path();
    path.moveTo(
      (points.last.dx + points.first.dx) / 2,
      (points.last.dy + points.first.dy) / 2,
    );
    for (int i = 0; i < pointsCount; i++) {
      final Offset curr = points[i];
      final Offset next = points[(i + 1) % pointsCount];
      final double midX = (curr.dx + next.dx) / 2;
      final double midY = (curr.dy + next.dy) / 2;
      path.quadraticBezierTo(curr.dx, curr.dy, midX, midY);
    }
    path.close();

    // 7. Gambar efek pendaran glow di latar belakang (Radial Glow)
    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          accentLightColor.withValues(alpha: 0.20),
          accentColor.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: radiusX * 1.5),
      );
    canvas.drawCircle(center, radiusX * 1.5, glowPaint);

    // 8. Gambar isi blob air utama (Fluid Fill)
    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          accentLightColor.withValues(alpha: 0.28),
          accentColor.withValues(alpha: 0.12),
          accentColor.withValues(alpha: 0.02),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: radiusX),
      );
    canvas.drawPath(path, fillPaint);

    // 9. Gambar tepian air refraktif bercahaya (Shimmering Rim)
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentLightColor.withValues(alpha: 0.45),
          accentColor.withValues(alpha: 0.15),
          accentLightColor.withValues(alpha: 0.25),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radiusX),
      );
    canvas.drawPath(path, strokePaint);

    // 10. Implementasi Crescent Specular Glare (Pantulan Kristal Sabit Kaca)
    // Melukis sabit runcing transparan di sudut kiri-atas bola, identik dengan AmbientOrb utama Luma
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 4); // Putar 45 derajat ke arah kiri-atas

    final double maxRadius = radiusX;
    final Rect outerRect = Rect.fromCircle(center: Offset.zero, radius: maxRadius * 0.90);
    final Rect innerRect = Rect.fromCircle(
      center: Offset(0, maxRadius * 0.05), // Geser sedikit ke bawah untuk membuat crescent runcing (taper)
      radius: maxRadius * 0.83,
    );

    final Path specularPath = Path()
      ..arcTo(outerRect, -math.pi * 0.85, math.pi * 0.70, true)
      ..arcTo(innerRect, -math.pi * 0.15, -math.pi * 0.70, false)
      ..close();

    final Paint specularPaint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-0.6, -0.9),
        end: const Alignment(0.6, -0.6),
        colors: [
          Colors.white.withValues(alpha: 0.35), // Terang di pusat pantulan
          Colors.white.withValues(alpha: 0.05), // Memudar anggun di ujung
        ],
      ).createShader(
        Rect.fromCircle(center: Offset.zero, radius: maxRadius),
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0); // Blur halus pembiasan cahaya

    canvas.drawPath(specularPath, specularPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LiquidIndicatorPainter oldDelegate) {
    return oldDelegate.activeTabProgress != activeTabProgress ||
        oldDelegate.waveAnimationValue != waveAnimationValue ||
        oldDelegate.tabCount != tabCount ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.accentLightColor != accentLightColor;
  }
}
