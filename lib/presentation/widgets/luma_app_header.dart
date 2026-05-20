import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/themes/colors.dart';
import '../../core/utils/luma_l10n.dart';

/// LumaAppHeader — Header terpusat untuk semua screen Luma.
/// Theme-aware via `context.luma`.
class LumaAppHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final String? title;

  const LumaAppHeader({super.key, this.onSettingsTap, this.title});

  String _formatDate(BuildContext context) {
    final now = DateTime.now();
    final locale = context.isId ? 'id_ID' : 'en_US';
    try {
      return DateFormat('EEEE, d MMMM', locale).format(now);
    } catch (_) {
      return DateFormat('EEEE, d MMMM').format(now);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? 'Luma',
                  style: GoogleFonts.dmSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: p.textPrimary,
                    letterSpacing: 0,
                  ),
                ),
                if (onSettingsTap != null)
                  GestureDetector(
                    onTap: onSettingsTap,
                    child: Icon(
                      Icons.settings_outlined,
                      size: 20,
                      color: p.textTertiary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              _formatDate(context),
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: p.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
