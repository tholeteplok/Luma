import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/themes/colors.dart';

/// LumaAppHeader — Header terpusat untuk semua screen Luma
///
/// Layout:
/// ```
/// Luma                          ⚙  (gear opsional)
/// Sabtu, 16 Mei
/// ```
///
/// Tidak menggunakan AppBar Material agar bisa fully custom.
/// Gunakan widget ini di dalam Column/CustomScrollView.
class LumaAppHeader extends StatelessWidget {
  /// Callback saat icon settings ditekan. Jika null, icon disembunyikan
  /// (mis. saat settings sudah jadi tab tersendiri).
  final VoidCallback? onSettingsTap;

  /// Override label kiri (default: "Luma").
  final String? title;

  const LumaAppHeader({
    super.key,
    this.onSettingsTap,
    this.title,
  });

  String _formatDate() {
    final now = DateTime.now();
    final locale = 'id_ID';
    try {
      return DateFormat('EEEE, d MMMM', locale).format(now);
    } catch (_) {
      return DateFormat('EEEE, d MMMM').format(now);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // Logo Luma (atau judul tab)
                Text(
                  title ?? 'Luma',
                  style: GoogleFonts.dmSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    letterSpacing: 0,
                  ),
                ),
                // Settings icon — hanya muncul jika callback diberikan
                if (onSettingsTap != null)
                  GestureDetector(
                    onTap: onSettingsTap,
                    child: Icon(
                      Icons.settings_outlined,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            // Tanggal hari ini — orientasi waktu tanpa angka berlebihan
            Text(
              _formatDate(),
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
