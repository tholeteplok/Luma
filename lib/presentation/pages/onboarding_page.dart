// lib/presentation/pages/onboarding_page.dart

import 'package:flutter/material.dart';
import '../widgets/ambient_visualization.dart';
import '../widgets/progress_dots.dart';
import '../widgets/outlined_ghost_button.dart';
import '../../core/themes/colors.dart';

class OnboardingPage extends StatefulWidget {
  final VoidCallback onComplete;
  
  const OnboardingPage({super.key, required this.onComplete});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          // You can perform actions on page change here if needed.
        },
        children: [
          _OnboardingScreen1(onComplete: widget.onComplete),
          const _OnboardingScreen2(),
          _OnboardingScreen3(onComplete: widget.onComplete),
        ],
      ),
    );
  }
}

class _OnboardingScreen1 extends StatelessWidget {
  final VoidCallback? onComplete;
  
  const _OnboardingScreen1({this.onComplete});

  @override
  Widget build(BuildContext context) {
    return _buildOnboardingScreen(
      context,
      ambientVariant: 1,
      displayText: 'Luma belum mengenal\nritmemu.',
      subText: 'Tidak ada form. Tidak ada target.',
      progressDotIndex: 0,
      buttonText: 'Lanjut',
      onButtonPressed: () {},
    );
  }
}

class _OnboardingScreen2 extends StatelessWidget {
  const _OnboardingScreen2();

  @override
  Widget build(BuildContext context) {
    return _buildOnboardingScreen(
      context,
      ambientVariant: 2,
      displayText: 'Luma mengamati.\nBukan menghakimi.',
      subText: 'Semua data hanya ada di perangkatmu.\nKami tidak bisa melihatnya.',
      progressDotIndex: 1,
      showPrivacyTag: true,
      buttonText: 'Aku percaya.',
      onButtonPressed: () {},
    );
  }
}

class _OnboardingScreen3 extends StatelessWidget {
  final VoidCallback? onComplete;
  
  const _OnboardingScreen3({this.onComplete});

  @override
  Widget build(BuildContext context) {
    return _buildOnboardingScreen(
      context,
      ambientVariant: 3,
      displayText: 'Beberapa hari ke depan,\nLuma akan menyapamu.',
      subText: 'Tidak ada yang perlu dilakukan.\nHanya... gunakan perangkatmu.',
      progressDotIndex: 2,
      showExpectedTimeline: true,
      buttonText: 'Mulai Gunakan',
      onButtonPressed: onComplete ?? () {},
    );
  }
}

Widget _buildOnboardingScreen(
  BuildContext context, {
  required int ambientVariant,
  required String displayText,
  required String subText,
  required int progressDotIndex,
  bool showPrivacyTag = false,
  bool showExpectedTimeline = false,
  required String buttonText,
  required VoidCallback onButtonPressed,
}) {
  final state = context.findAncestorStateOfType<_OnboardingPageState>();
  final pageController = state?._pageController;
  
  return Container(
    color: AppColors.backgroundDark,
    child: SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: AmbientVisualization(variant: ambientVariant),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              displayText,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDarkSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          if (showPrivacyTag) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.positive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 16, color: AppColors.positive),
                  const SizedBox(width: 8),
                  Text(
                    'Zero-knowledge encryption',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textDarkSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
          if (showExpectedTimeline) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildTimelineItem(context, 'Hari 1-2', 'Mengamati...'),
                  const SizedBox(height: 8),
                  _buildTimelineItem(context, 'Hari 3', 'Sapaan pertama'),
                  const SizedBox(height: 8),
                  _buildTimelineItem(context, 'Hari 7', 'Refleksi mingguan'),
                ],
              ),
            ),
          ],
          const Spacer(),
          ProgressDots(currentIndex: progressDotIndex, total: 3),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: OutlinedGhostButton(
              text: buttonText,
              onPressed: () {
                if (progressDotIndex < 2 && pageController != null) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  onButtonPressed();
                }
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

Widget _buildTimelineItem(BuildContext context, String label, String description) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: AppColors.primaryDark.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textDarkSecondary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textDarkSecondary,
                  ),
            ),
          ],
        ),
      ),
    ],
  );
}
