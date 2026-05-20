import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/colors.dart';

/// FirstInsightCard — Kartu khusus untuk insight pertama Luma (hari 1–3).
///
/// Berbeda dari InsightCard biasa:
/// - Tidak ada badge tipe / severity
/// - Tidak ada feedback buttons
/// - Tidak ada unread dot
/// - Footer khusus: mengundang, bukan menjelaskan
/// - Entry animation: slide 20px dari bawah + fade, 1000ms easeOut
/// - Left bar: gentle (hijau redup) — selalu, tidak tergantung severity
///
/// Ini adalah momen pertama user "dikenali" oleh Luma.
/// Harus terasa seperti perkenalan, bukan laporan.
class FirstInsightCard extends StatefulWidget {
  final String title;
  final String? subtitle;

  /// Delay sebelum animasi entry dimulai (default 300ms — beri waktu
  /// halaman selesai render dulu).
  final Duration entryDelay;

  const FirstInsightCard({
    super.key,
    required this.title,
    this.subtitle,
    this.entryDelay = const Duration(milliseconds: 300),
  });

  @override
  State<FirstInsightCard> createState() => _FirstInsightCardState();
}

class _FirstInsightCardState extends State<FirstInsightCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Slide dari 20px di bawah posisi akhir
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06), // ~20px pada layar 360px lebar
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Mulai animasi setelah delay
    Future.delayed(widget.entryDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: p.bgSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left bar — selalu gentle, tidak ada severity lain
                Container(
                  width: 2,
                  color: p.gentleInd,
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Insight title — lebih besar dari biasa, serif
                        Text(
                          widget.title,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 22,
                            fontStyle: FontStyle.normal,
                            color: p.textPrimary,
                            height: 1.5,
                          ),
                        ),
                        if (widget.subtitle != null &&
                            widget.subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.subtitle!,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: p.textSecondary,
                              height: 1.65,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        // Divider tipis
                        Container(height: 1, color: p.borderFaint),
                        const SizedBox(height: 14),
                        // Footer khusus first insight — mengundang, bukan menjelaskan
                        _FirstInsightFooter(),
                      ],
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
}

/// Footer khusus untuk first insight.
/// Tidak ada "Luma akan terus mengamati" — terlalu mekanis untuk momen pertama.
class _FirstInsightFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    // Deteksi bahasa dari locale atau fallback ke ID
    final isId = Localizations.localeOf(context).languageCode == 'id';

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: p.gentleInd.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            isId
                ? 'Ini baru permulaan. Luma akan semakin mengenalmu.'
                : 'This is just the beginning. Luma will come to know you.',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: p.textSubtle,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
