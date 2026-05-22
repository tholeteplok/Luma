import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/themes/colors.dart';
import '../bloc/settings_bloc.dart';

/// AboutPage — Filosofi, Misi, dan Kisah Brand Luma
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: try launching directly to bypass strict OS queries check
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal membuka tautan / Failed to open link',
              style: GoogleFonts.dmSans(fontSize: 12),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, settings, _) {
        final p = context.luma;
        final isId = settings.languageCode == 'id';

        return Scaffold(
          backgroundColor: p.bgBase,
          appBar: AppBar(
            backgroundColor: p.bgBase,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              color: p.textSecondary,
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              isId ? 'Tentang Aplikasi' : 'About App',
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: p.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              // ─── HERO SECTION (AMBIENT GLOW ORB) ────────────────────
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        p.accent.withValues(alpha: 0.95),
                        p.accent.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.65, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: p.accent.withValues(alpha: 0.45),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lens_blur,
                      size: 36,
                      color: p.accentLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Luma',
                  style: GoogleFonts.dmSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: p.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Center(
                child: Text(
                  isId ? 'Ritme Perilaku Digital Personal' : 'Personal Digital Behavior Rhythm',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: p.textTertiary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // ─── PERNYATAAN FILOSOFIS (EDITORIAL FEEL) ────────────────
              Center(
                child: Text(
                  isId ? 'FILOSOFIS' : 'PHILOSOPHY',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: p.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isId
                    ? '"Perhatian digital Anda tidak boleh ditambang atau diperdagangkan. Ia adalah bagian paling sakral dari kesadaran sadar Anda, layak diamati secara sunyi dan dirawat dengan penuh kelembutan."'
                    : '"Your digital attention should not be mined or traded. It is the most sacred part of your conscious life, deserving of quiet observation and gentle care."',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: p.textPrimary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // ─── 4 PRINSIP MINDFUL ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 2),
                child: Text(
                  isId ? '4 PILAR RITME LUMA' : '4 PILARS OF LUMA RHYTHM',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: p.textTertiary,
                  ),
                ),
              ),

              _PrincipleCard(
                icon: Icons.shield_outlined,
                title: isId ? '1. Kedaulatan Data Mutlak' : '1. Absolute Data Sovereignty',
                description: isId
                    ? 'Data penggunaan Anda dianalisis secara lokal di perangkat Anda (On-Device Processing). Luma tidak pernah menjual atau mentransmisikan data perilaku mentah Anda ke server awan luar.'
                    : 'Your usage data is analyzed locally on your device (On-Device Processing). Luma never sells or transmits your raw behavior data to external cloud servers.',
              ),
              const SizedBox(height: 12),

              _PrincipleCard(
                icon: Icons.access_time_outlined,
                title: isId ? '2. Keselarasan Sirkadian' : '2. Circadian Cohesion',
                description: isId
                    ? 'Luma membantu Anda mengenali ritme biologis harian Anda (pagi, siang, malam). Membantu menjaga fokus tetap alami, alih-alih memaksa Anda bekerja melewati batas toleransi biologis Anda.'
                    : 'Luma helps you recognize your daily biological rhythm (morning, day, night). Keeping focus natural, rather than forcing you to work past your biological limits.',
              ),
              const SizedBox(height: 12),

              _PrincipleCard(
                icon: Icons.remove_red_eye_outlined,
                title: isId ? '3. Perlindungan Fokus' : '3. Focus Safeguard',
                description: isId
                    ? 'Menghalau gempuran notifikasi dan jeratan ekonomi perhatian (*attention economy*). Luma bertindak sebagai perisai penyaring untuk menciptakan ruang hening yang melestarikan fokus terdalam Anda.'
                    : 'Defending against notifications and the attention economy trap. Luma acts as a filtering shield to create a silent space that preserves your deepest focus.',
              ),
              const SizedBox(height: 12),

              _PrincipleCard(
                icon: Icons.spa_outlined,
                title: isId ? '4. Interaksi Organik' : '4. Organic Interaction',
                description: isId
                    ? 'Bebas dari taktik manipulatif (dark patterns) yang adiktif. Luma dirancang dengan ketukan riak tenang, warna natural yang meredup, serta umpan balik haptic mikro untuk menyembuhkan hubungan Anda dengan layar.'
                    : 'Free from addictive manipulative tactics (dark patterns). Luma is designed with calm ripple effects, soothing gradients, and micro-haptic feedback to heal your relationship with your screen.',
              ),
              const SizedBox(height: 36),

              // ─── INFORMASI TIM & CERITA ──────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: p.bgSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isId ? 'KARYA DENGAN MAKSUD' : 'CRAFTED WITH INTENT',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: p.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isId
                          ? 'Luma dirancang secara kolaboratif sebagai eksperimen terbuka untuk menjelajahi keharmonisan hubungan manusia dengan teknologi digital.'
                          : 'Luma is collaboratively designed as an open experiment exploring the harmony of human relationships with digital technology.',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: p.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: p.bgElevated,
                          child: Icon(Icons.code, size: 14, color: p.accentLight),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Fabian Nuriel & Luma Team',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: p.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ─── TAUTAN EKSTERNAL ────────────────────────────────────
              _LinkTile(
                icon: Icons.code,
                label: isId ? 'Kode Sumber GitHub' : 'GitHub Source Code',
                onTap: () => _launchURL(context, 'https://github.com/tholeteplok/Luma'),
              ),
              const SizedBox(height: 8),
              _LinkTile(
                icon: Icons.language,
                label: isId ? 'Kunjungi Luma Web' : 'Visit Luma Web',
                onTap: () => _launchURL(context, 'https://tholeteplok.github.io/Luma/'),
              ),
              const SizedBox(height: 8),
              _LinkTile(
                icon: Icons.help_outline,
                label: isId ? 'Dokumentasi & Dukungan' : 'Documentation & Support',
                onTap: () => _launchURL(context, 'https://github.com/tholeteplok/Luma/wiki'),
              ),
              const SizedBox(height: 48),

              // ─── FOOTER ──────────────────────────────────────────────
              Center(
                child: Text(
                  'Luma v1.0.0',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: p.textSubtle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  isId
                      ? 'Dibuat dengan kesadaran penuh untuk mahluk digital yang mindful.'
                      : 'Crafted with intent for mindful digital beings.',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: p.textSubtle,
                  ),
                ),
              ),
              context.lumaBottomSpacer,
            ],
          ),
        );
      },
    );
  }
}

// ─── WIDGET PENDUKUNG INTERNAL ────────────────────────────────────────

class _PrincipleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrincipleCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.borderFaint.withValues(alpha: 0.5), width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: p.accentLight),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: p.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return Container(
      decoration: BoxDecoration(
        color: p.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.borderFaint, width: 0.5),
      ),
      child: ListTile(
        leading: Icon(icon, size: 18, color: p.textSecondary),
        title: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: p.textPrimary,
          ),
        ),
        trailing: Icon(Icons.open_in_new, size: 14, color: p.textSubtle),
        onTap: onTap,
        dense: true,
      ),
    );
  }
}
