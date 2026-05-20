import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/themes/colors.dart';
import '../bloc/settings_bloc.dart';

/// LumaAppHeader — Header terpusat untuk semua screen Luma.
/// Theme-aware via `context.luma`. Language-aware via SettingsNotifier.
class LumaAppHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final String? title;

  const LumaAppHeader({super.key, this.onSettingsTap, this.title});

  String _formatDate(bool isId) {
    final now = DateTime.now();
    final locale = isId ? 'id_ID' : 'en_US';
    try {
      return DateFormat('EEEE, d MMMM', locale).format(now);
    } catch (_) {
      // Fallback jika locale data belum di-load
      return DateFormat('EEEE, d MMMM').format(now);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    // Consumer agar rebuild saat bahasa berubah di Settings
    return Consumer<SettingsNotifier>(
      builder: (context, settings, _) {
        final isId = settings.languageCode == 'id';
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
                  _formatDate(isId),
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
      },
    );
  }
}
