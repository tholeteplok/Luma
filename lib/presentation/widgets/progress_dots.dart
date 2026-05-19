// lib/presentation/widgets/progress_dots.dart

import 'package:flutter/material.dart';
import 'package:luma/config/colors.dart';

class ProgressDots extends StatelessWidget {
  final int currentIndex;
  final int total;

  const ProgressDots({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) => _buildDot(index)),
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = index == currentIndex;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 20.0 : 6.0,
      height: 6.0,
      decoration: BoxDecoration(
        color: isActive ? LumaColors.accentPrimary : LumaColors.borderSubtle,
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}