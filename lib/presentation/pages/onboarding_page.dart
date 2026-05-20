import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/colors.dart';
import '../widgets/ambient_orb.dart';
import '../widgets/progress_dots.dart';

/// OnboardingPage — 3 slide perkenalan Luma.
///
/// Setiap slide punya AmbientOrb yang hidup (bukan lingkaran solid).
/// Transisi antar slide: slide horizontal + fade.
/// Teks menggunakan warna dari LumaPalette agar terbaca di dark & light mode.
class OnboardingPage extends StatefulWidget {
  final Future<void> Function() onComplete;

  const OnboardingPage({super.key, required this.onComplete});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _completing = false;

  static const _slides = [
    _SlideData(
      orbState: OrbState.dawn,
      title: 'Luma belum mengenal\nritmemu.',
      subtitle: 'Tidak ada form. Tidak ada target.\nLuma belajar kapan pagimu dimulai — bisa jam 6 pagi, bisa jam 10 malam.',
      buttonLabel: 'Lanjut',
    ),
    _SlideData(
      orbState: OrbState.calm,
      title: 'Luma mengamati.\nBukan menghakimi.',
      subtitle: 'Semua data hanya ada di perangkatmu.\nKami tidak bisa melihatnya.',
      buttonLabel: 'Aku percaya.',
      showPrivacyTag: true,
    ),
    _SlideData(
      orbState: OrbState.dawn,
      title: 'Beberapa hari ke depan,\nLuma akan menyapamu.',
      subtitle: 'Tidak ada yang perlu dilakukan.\nHanya... gunakan perangkatmu.',
      buttonLabel: 'Mulai Gunakan',
      showTimeline: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_completing) return;
    setState(() => _completing = true);
    await widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return Scaffold(
      backgroundColor: p.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            // ── Orb area — 45% tinggi layar ──────────────────────────────────
            Expanded(
              flex: 45,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (context, i) {
                  return _OrbSlide(
                    orbState: _slides[i].orbState,
                    // Orb aktif hanya di halaman yang terlihat
                    isActive: i == _currentPage,
                  );
                },
              ),
            ),

            // ── Teks + konten ─────────────────────────────────────────────────
            Expanded(
              flex: 55,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (context, i) {
                  return _SlideContent(
                    slide: _slides[i],
                    onNext: _next,
                    isLast: i == _slides.length - 1,
                    isCompleting: _completing,
                  );
                },
              ),
            ),

            // ── Progress dots ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProgressDots(
                currentIndex: _currentPage,
                total: _slides.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DATA
// ─────────────────────────────────────────────────────────────────────────────

class _SlideData {
  final OrbState orbState;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final bool showPrivacyTag;
  final bool showTimeline;

  const _SlideData({
    required this.orbState,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    this.showPrivacyTag = false,
    this.showTimeline = false,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  ORB SLIDE — hanya orb, di-isolasi agar tidak rebuild teks
// ─────────────────────────────────────────────────────────────────────────────

class _OrbSlide extends StatelessWidget {
  final OrbState orbState;
  final bool isActive;

  const _OrbSlide({required this.orbState, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width * 0.55;
    return Center(
      child: AmbientOrb(
        state: orbState,
        size: size,
        reduceMotion: !isActive, // hemat resource saat tidak aktif
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SLIDE CONTENT — teks + tombol
// ─────────────────────────────────────────────────────────────────────────────

class _SlideContent extends StatelessWidget {
  final _SlideData slide;
  final VoidCallback onNext;
  final bool isLast;
  final bool isCompleting;

  const _SlideContent({
    required this.slide,
    required this.onNext,
    required this.isLast,
    required this.isCompleting,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),

          // ── Judul ──────────────────────────────────────────────────────────
          Text(
            slide.title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: p.textPrimary,   // selalu terbaca
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // ── Subtitle ───────────────────────────────────────────────────────
          Text(
            slide.subtitle,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: p.textSecondary, // sedikit lebih redup dari judul
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          // ── Privacy tag (slide 2) ──────────────────────────────────────────
          if (slide.showPrivacyTag) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: p.gentleBadgeBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: p.gentleInd.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 15, color: p.gentleText),
                  const SizedBox(width: 8),
                  Text(
                    'Zero-knowledge encryption',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: p.gentleText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Timeline (slide 3) ─────────────────────────────────────────────
          if (slide.showTimeline) ...[
            const SizedBox(height: 24),
            _TimelineItems(p: p),
          ],

          const Spacer(),

          // ── Tombol ─────────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: _OnboardingButton(
              label: slide.buttonLabel,
              isLoading: isLast && isCompleting,
              onPressed: onNext,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TIMELINE ITEMS
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineItems extends StatelessWidget {
  final LumaPalette p;
  const _TimelineItems({required this.p});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Hari 1–2', 'Mengamati...'),
      ('Hari 3', 'Sapaan pertama'),
      ('Hari 7', 'Refleksi mingguan'),
    ];

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: p.accent.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                item.$1,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: p.textTertiary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.$2,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: p.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TOMBOL ONBOARDING
// ─────────────────────────────────────────────────────────────────────────────

class _OnboardingButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _OnboardingButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: p.borderSubtle,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: p.bgSurface,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: p.accent,
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: p.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
