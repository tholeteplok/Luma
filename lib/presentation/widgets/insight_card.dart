import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/colors.dart';
import '../../core/utils/fade_granularity.dart';

/// InsightCard — Kartu insight dengan tone observasional
///
/// Anatomi (sesuai visual_prototype_dark.html):
/// ```
/// │▌  [BADGE TIPE]
/// │   Teks insight utama dalam serif
/// │   Sub-teks lembut dalam serif italic
/// │   ───────────────────────────
/// │   hint pasif bawah
/// ```
///
/// Tidak ada angka nilai.
/// Tidak ada tombol dismiss mencolok.
/// Warna left bar hanya sebagai penanda tipe, bukan penilaian.
class InsightCard extends StatelessWidget {
  final String id;
  final String title;
  final String message;
  final String severity;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const InsightCard({
    super.key,
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
    this.onTap,
    this.onDismiss,
  });

  /// Warna indicator bar kiri — sesuai prototype semantic colors
  Color _indicatorColor() {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return AppColors.warnInd;
      case 'notice':
        return AppColors.noticeInd;
      case 'gentle':
      case 'positive':
        return AppColors.gentleInd;
      case 'info':
      default:
        return AppColors.infoInd;
    }
  }

  /// Warna teks badge — pasangan dari indicator
  Color _badgeTextColor() {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return AppColors.warnText;
      case 'notice':
        return AppColors.noticeText;
      case 'gentle':
      case 'positive':
        return AppColors.gentleText;
      case 'info':
      default:
        return AppColors.infoText;
    }
  }

  /// Background badge — sangat redup, tidak mencolok
  Color _badgeBg() {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return const Color(0xFF1E1010);
      case 'notice':
        return const Color(0xFF1A1008);
      case 'gentle':
      case 'positive':
        return const Color(0xFF101E1B);
      case 'info':
      default:
        return const Color(0xFF0E1420);
    }
  }

  /// Label badge — singkat, observasional, uppercase
  String _badgeLabel() {
    final timeStr = _relativeTimeShort();
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return '$timeStr • PERHATIAN';
      case 'notice':
        return '$timeStr • CATATAN';
      case 'gentle':
      case 'positive':
        return '$timeStr • POLA';
      case 'info':
      default:
        return '$timeStr • INFO';
    }
  }

  String _relativeTimeShort() {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays == 0) return 'BARU SAJA';
    if (diff.inDays == 1) return 'KEMARIN';
    if (diff.inDays < 7) return '${diff.inDays}H LALU';
    return 'MINGGU LALU';
  }

  @override
  Widget build(BuildContext context) {
    final daysOld = DateTime.now().difference(timestamp).inDays;
    final opacity = FadeGranularity.getOpacity(daysOld);
    final blurSigma = FadeGranularity.getBlurSigma(daysOld);
    final indicatorColor = _indicatorColor();

    return Opacity(
      opacity: isRead ? opacity * 0.7 : opacity,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onDismiss,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left indicator bar (2px) ───────────────────────
                Container(
                  width: 2,
                  color: indicatorColor,
                ),
                // ── Content ───────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _badgeBg(),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _badgeLabel(),
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.6,
                              color: _badgeTextColor(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Insight title — Cormorant Garamond serif
                        _buildText(
                          text: title,
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          color: AppColors.textPrimary,
                          blurSigma: blurSigma,
                          lineHeight: 1.5,
                        ),
                        if (message.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          // Insight message — serif italic, tertiary
                          _buildText(
                            text: message,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textTertiary,
                            blurSigma: blurSigma,
                            lineHeight: 1.65,
                          ),
                        ],
                        const SizedBox(height: 14),
                        // Divider tipis
                        Container(
                          height: 1,
                          color: AppColors.borderFaint,
                        ),
                        const SizedBox(height: 10),
                        // Footer hint — pasif, tidak mendesak
                        Text(
                          'Luma akan terus mengamati. '
                          'Pola biasanya muncul setelah beberapa hari.',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppColors.textSubtle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Unread dot — sangat subtle, di pojok kanan
                if (!isRead)
                  Padding(
                    padding: const EdgeInsets.only(top: 18, right: 14),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indicatorColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bangun teks dengan optional blur (FadeGranularity)
  Widget _buildText({
    required String text,
    required double fontSize,
    required FontStyle fontStyle,
    required Color color,
    required double blurSigma,
    double lineHeight = 1.5,
  }) {
    Widget textWidget = Text(
      text,
      style: GoogleFonts.cormorantGaramond(
        fontSize: fontSize,
        fontStyle: fontStyle,
        color: color,
        height: lineHeight,
      ),
    );

    if (blurSigma > 0) {
      textWidget = ImageFiltered(
        imageFilter: dart_ui.ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
          tileMode: dart_ui.TileMode.decal,
        ),
        child: textWidget,
      );
    }

    return textWidget;
  }
}
