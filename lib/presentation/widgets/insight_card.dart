import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/colors.dart';
import '../../core/utils/fade_granularity.dart';
import '../../core/utils/luma_l10n.dart';

/// InsightCard — Kartu insight dengan tone observasional.
/// Sepenuhnya theme-aware via [LumaPalette] / `context.luma`.
class InsightCard extends StatelessWidget {
  final String id;
  final String title;
  final String message;
  final String severity;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  /// Aktifkan NostalgiaEffect — glow gold tipis di sekitar card
  final bool nostalgiaActive;

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
    this.nostalgiaActive = false,
  });

  Color _indicatorColor(LumaPalette p) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return p.warnInd;
      case 'notice':
        return p.noticeInd;
      case 'gentle':
      case 'positive':
        return p.gentleInd;
      default:
        return p.infoInd;
    }
  }

  Color _badgeTextColor(LumaPalette p) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return p.warnText;
      case 'notice':
        return p.noticeText;
      case 'gentle':
      case 'positive':
        return p.gentleText;
      default:
        return p.infoText;
    }
  }

  Color _badgeBg(LumaPalette p) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return p.warnBadgeBg;
      case 'notice':
        return p.noticeBadgeBg;
      case 'gentle':
      case 'positive':
        return p.gentleBadgeBg;
      default:
        return p.infoBadgeBg;
    }
  }

  String _badgeLabel(LumaStrings l) {
    final timeStr = _relativeTimeShort(l);
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return '$timeStr • ${l.badgeWarning}';
      case 'notice':
        return '$timeStr • ${l.badgeNotice}';
      case 'gentle':
      case 'positive':
        return '$timeStr • ${l.badgePattern}';
      default:
        return '$timeStr • ${l.badgeInfo}';
    }
  }

  String _relativeTimeShort(LumaStrings l) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays == 0) return l.timeJustNow;
    if (diff.inDays == 1) return l.timeYesterday;
    if (diff.inDays < 7) return l.daysAgo(diff.inDays);
    return l.timeLastWeek;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    final l = context.l10n;
    final daysOld = DateTime.now().difference(timestamp).inDays;
    final opacity = FadeGranularity.getOpacity(daysOld);
    final blurSigma = FadeGranularity.getBlurSigma(daysOld);
    final italic = FadeGranularity.isItalic(daysOld);
    final indicatorColor = _indicatorColor(p);

    return Opacity(
      opacity: isRead ? opacity * 0.7 : opacity,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onDismiss,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: p.bgSurface,
            borderRadius: BorderRadius.circular(16),
            // NostalgiaEffect: glow gold tipis
            boxShadow: nostalgiaActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFC18D52).withValues(alpha: 0.08),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left indicator bar
                Container(width: 2, color: indicatorColor),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _badgeBg(p),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _badgeLabel(l),
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.6,
                              color: _badgeTextColor(p),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Title — italic jika >28 hari
                        _buildText(
                          text: title,
                          fontSize: 20,
                          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                          color: p.textPrimary,
                          blurSigma: blurSigma,
                          lineHeight: 1.5,
                        ),
                        if (message.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          _buildText(
                            text: message,
                            fontSize: 15,
                            fontStyle: FontStyle.italic, // message selalu italic
                            color: p.textTertiary,
                            blurSigma: blurSigma,
                            lineHeight: 1.65,
                          ),
                        ],
                        const SizedBox(height: 14),
                        Container(height: 1, color: p.borderFaint),
                        const SizedBox(height: 10),
                        Text(
                          l.insightFooter,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: p.textSubtle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Unread dot
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

  Widget _buildText({
    required String text,
    required double fontSize,
    required FontStyle fontStyle,
    required Color color,
    required double blurSigma,
    double lineHeight = 1.5,
  }) {
    Widget w = Text(
      text,
      style: GoogleFonts.cormorantGaramond(
        fontSize: fontSize,
        fontStyle: fontStyle,
        color: color,
        height: lineHeight,
      ),
    );
    if (blurSigma > 0) {
      w = ImageFiltered(
        imageFilter: dart_ui.ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
          tileMode: dart_ui.TileMode.decal,
        ),
        child: w,
      );
    }
    return w;
  }
}
