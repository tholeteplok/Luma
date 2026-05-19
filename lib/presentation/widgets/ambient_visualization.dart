// lib/presentation/widgets/ambient_visualization.dart

import 'package:flutter/material.dart';
import 'package:luma/config/colors.dart';

class AmbientVisualization extends StatelessWidget {
  final int variant;

  const AmbientVisualization({
    super.key,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: LumaColors.bgBase,
      ),
      child: Center(
        child: _buildAmbientCircles(),
      ),
    );
  }

  Widget _buildAmbientCircles() {
    switch (variant) {
      case 1:
        return _buildSingleCircle(LumaColors.accentMuted);
      case 2:
        return _buildTwoCircles();
      case 3:
        return _buildThreeCircles();
      default:
        return _buildSingleCircle(LumaColors.accentMuted);
    }
  }

  Widget _buildSingleCircle(Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1200),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildTwoCircles() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: LumaColors.accentMuted.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(width: 16),
        AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: LumaColors.accentMuted.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildThreeCircles() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: LumaColors.accentMuted.withValues(alpha: 0.15),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: LumaColors.accentMuted.withValues(alpha: 0.25),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: LumaColors.accentMuted.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}