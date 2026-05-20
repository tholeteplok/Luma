import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/colors.dart';

/// OutlinedGhostButton — Tombol outline minimal sesuai bahasa visual Luma.
/// Theme-aware via `context.luma`.
class OutlinedGhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  /// Jika false, tombol ditampilkan disabled (opacity redup, tidak bisa ditekan).
  /// Default true.
  final bool enabled;

  const OutlinedGhostButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    final isDisabled = !enabled || isLoading;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDisabled ? 0.4 : 1.0,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDisabled ? p.borderFaint : p.borderSubtle,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: p.bgSurface,
            foregroundColor: p.textPrimary,
          ),
          child: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: p.textTertiary,
                  ),
                )
              : Text(
                  text,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDisabled ? p.textTertiary : p.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
