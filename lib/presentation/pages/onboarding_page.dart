// lib/presentation/pages/onboarding_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luma/config/colors.dart';
import 'package:luma/config/design_tokens.dart';
import 'package:luma/config/typography.dart';
import 'package:luma/presentation/widgets/ambient_visualization.dart';
import 'package:luma/presentation/widgets/progress_dots.dart';
import 'package:luma/presentation/widgets/outlined_ghost_button.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _currentPage = 0;
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
          setState(() {
            _currentPage = index;
          });
        },
        children: const [
          _OnboardingScreen1(),
          _OnboardingScreen2(),
          _OnboardingScreen3(),
        ],
      ),
    );
  }
}

class _OnboardingScreen1 extends ConsumerWidget {
  const _OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildOnboardingScreen(
      context,
      ambientVariant: 1,
      displayText: 'Luma belum mengenal\nritmemu.',
      subText: 'Tidak ada form. Tidak ada target.',
      progressDotIndex: 0,
    );
  }
}

class _OnboardingScreen2 extends ConsumerWidget {
  const _OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildOnboardingScreen(
      context,
      ambientVariant: 2,
      displayText: 'Luma mengamati.\nBukan menghakimi.',
      subText: 'Semua data hanya ada di perangkatmu.\nKami tidak bisa melihatnya.',
      progressDotIndex: 1,
      showPrivacyTag: true,
    );
  }
}

class _OnboardingScreen3 extends ConsumerWidget {
  const _OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildOnboardingScreen(
      context,
      ambientVariant: 3,
      displayText: 'Beberapa hari ke depan,\nLuma akan menyapamu.',
      subText: 'Tidak ada yang perlu dilakukan.\nHanya... gunakan perangkatmu.',
      progressDotIndex: 2,
      showExpectedTimeline: true,
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
}) {
  return Container(
    color: LumaColors.bgBase,
    child: SafeArea(
      child: Column(
        children: [
          // Ambient Visualization
          Expanded(
            flex: 3,
            child: AmbientVisualization(variant: ambientVariant),
          ),
          // Display Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: LumaTokens.spaceXxl),
            child: Text(
              displayText,
              style: LumaTypography.displayMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: LumaTokens.spaceSm),
          // Sub Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: LumaTokens.spaceXxl),
            child: Text(
              subText,
              style: LumaTypography.bodyMedium,
              color: LumaColors.textTertiary,
              textAlign: TextAlign.center,
            ),
          ),
          if (showPrivacyTag) ...[
            const SizedBox(height: LumaTokens.spaceMd),
            // Privacy Tag
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: LumaTokens.spaceLg,
                vertical: LumaTokens.spaceXs,
              ),
              decoration: BoxDecoration(
                color: LumaColors.gentleBg,
                borderRadius: BorderRadius.circular(LumaTokens.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: LumaTokens.iconMd,
                    color: LumaColors.gentleText,
                  ),
                  const SizedBox(width: LumaTokens.spaceXs),
                  Text(
                    'Zero-knowledge encryption',
                    style: LumaTypography.bodySmall.copyWith(
                      color: LumaColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (showExpectedTimeline) ...[
            const SizedBox(height: LumaTokens.spaceLg),
            // Expected Timeline
            Padding(
              padding: EdgeInsets.symmetric(horizontal: LumaTokens.spaceXxl),
              child: Column(
                children: [
                  _buildTimelineItem('Hari 1-2', 'Mengamati...'),
                  const SizedBox(height: LumaTokens.spaceSm),
                  _buildTimelineItem('Hari 3', 'Sapaan pertama'),
                  const SizedBox(height: LumaTokens.spaceSm),
                  _buildTimelineItem('Hari 7', 'Refleksi mingguan'),
                ],
              ),
            ),
          ],
          const Spacer(),
          // Progress Dots
          ProgressDots(
            currentIndex: progressDotIndex,
            total: 3,
          ),
          const SizedBox(height: LumaTokens.spaceLg),
          // Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: LumaTokens.spaceXxl),
            child: OutlinedGhostButton(
              text: _getButtonText(progressDotIndex),
              onPressed: _getButtonAction(progressDotIndex),
            ),
          ),
          const SizedBox(height: LumaTokens.spaceLg),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String label, String description) {
    return Row(
      children: [
        Container(
          width: LumaTokens.iconSm,
          height: LumaTokens.iconSm,
          decoration: BoxDecoration(
            color: LumaColors.accentMuted,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: LumaTokens.spaceSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: LumaTypography.dataSmall.copyWith(
                  color: LumaColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: LumaTypography.bodySmall.copyWith(
                  color: LumaColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getButtonText(int index) {
    switch (index) {
      case 0:
        return 'Lanjut';
      case 1:
        return 'Aku percaya.';
      case 2:
        return 'Aku tunggu.';
      default:
        return '';
    }
  }

  VoidCallback _getButtonAction(int index) {
    switch (index) {
      case 0:
      case 1:
        return () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        };
      case 2:
        return () {
          // Navigate to home screen
          // TODO: Implement navigation to home
        };
      default:
        return () {};
    }
  }
}