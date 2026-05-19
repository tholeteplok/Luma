// lib/presentation/widgets/outlined_ghost_button.dart

import 'package:flutter/material.dart';
import 'package:luma/config/colors.dart';
import 'package:luma/config/typography.dart';

class OutlinedGhostButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const OutlinedGhostButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0, // buttonHeight from design tokens
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isLoading 
                ? LumaColors.borderFaint 
                : LumaColors.borderSubtle,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // radiusMd
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(LumaColors.textSecondary),
                ),
              )
            : Text(
                text,
                style: LumaTypography.bodyMedium.copyWith(
                  color: isLoading 
                      ? LumaColors.textTertiary 
                      : LumaColors.textSecondary,
                ),
              ),
      ),
    );
  }
}