import 'package:flutter/material.dart';
import '../painters/fading_line_painter.dart';

// ─── FocusRing TELAH DIHAPUS ─────────────────────────────────────────────────
// Digantikan oleh AmbientOrb (lib/presentation/widgets/ambient_orb.dart)
// Alasan: FocusRing menampilkan angka % dan menilai fokus.
// AmbientOrb hanya mencerminkan ritme tanpa penilaian.
// ─────────────────────────────────────────────────────────────────────────────

/// TimelineVisualizer — Alias ke FadingLineChart (backward compat)
///
/// Widget ini dipertahankan agar tidak ada breaking import di tempat lain.
/// Secara internal mendelegasikan ke FadingLineChart.
@Deprecated('Gunakan FadingLineChart dari painters/fading_line_painter.dart')
class TimelineVisualizer extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;
  final double height;

  const TimelineVisualizer({
    super.key,
    required this.weeklyData,
    this.height = 72,
  });

  @override
  Widget build(BuildContext context) {
    return FadingLineChart(
      weeklyData: weeklyData,
      height: height,
    );
  }
}
