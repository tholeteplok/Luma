import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../../core/themes/colors.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/theme_bloc.dart';
import 'about_page.dart';
import 'backup_page.dart';

/// SettingsPage — Pengaturan Luma
///
/// Langsung consume SettingsNotifier dan ThemeNotifier via Provider.
/// Tidak ada prop-drilling callback — semua toggle real-time dan persist.
class SettingsPage extends StatelessWidget {
  /// Saat false, AppBar tidak menampilkan tombol kembali.
  /// Dipakai ketika halaman ini berada di dalam BottomNav (root tab).
  final bool showBackButton;

  const SettingsPage({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    // Consumer agar rebuild otomatis saat state berubah
    return Consumer2<SettingsNotifier, ThemeNotifier>(
      builder: (context, settings, theme, _) {
        final p = context.luma;
        final isId = settings.languageCode == 'id';

        return Scaffold(
          backgroundColor: p.bgBase,
          appBar: AppBar(
            backgroundColor: p.bgBase,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: showBackButton,
            leading: showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: p.textSecondary,
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            title: Text(
              isId ? 'Pengaturan' : 'Settings',
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: p.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // ─── TAMPILAN ───────────────────────────────────────────
              _SectionHeader(isId ? 'TAMPILAN' : 'APPEARANCE'),
              _SettingsCard(
                children: [
                  _ThemeTile(
                    label: isId ? 'Mode Tema' : 'Theme Mode',
                    currentMode: theme.themeMode,
                    onChanged: (mode) {
                      // Update keduanya: ThemeNotifier (live MaterialApp)
                      // + SettingsNotifier (untuk persist ke Isar/backup).
                      theme.setThemeMode(mode);
                      settings.setThemeMode(mode);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ─── AKSESIBILITAS ──────────────────────────────────────
              _SectionHeader(isId ? 'AKSESIBILITAS' : 'ACCESSIBILITY'),
              _SettingsCard(
                children: [
                  _SwitchTile(
                    title: isId ? 'Kurangi Animasi' : 'Reduce Motion',
                    subtitle: isId
                        ? 'Matikan animasi bernafas pada timeline'
                        : 'Disable breathing animations on timeline',
                    value: settings.reduceMotion,
                    onChanged: (_) => settings.toggleReduceMotion(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ─── BAHASA ────────────────────────────────────────────
              _SectionHeader(isId ? 'BAHASA' : 'LANGUAGE'),
              _SettingsCard(
                children: [
                  _TapTile(
                    title: isId ? 'Bahasa Aplikasi' : 'App Language',
                    value: settings.languageCode == 'id'
                        ? 'Bahasa Indonesia'
                        : 'English',
                    onTap: () => settings.setLanguage(
                      settings.languageCode == 'id' ? 'en' : 'id',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ─── NOTIFIKASI ─────────────────────────────────────────
              _SectionHeader(isId ? 'NOTIFIKASI' : 'NOTIFICATIONS'),
              _SettingsCard(
                children: [
                  _SwitchTile(
                    title: isId ? 'Notifikasi Insight' : 'Insight Notifications',
                    subtitle: isId
                        ? 'Luma memberi tahu saat ada pola baru'
                        : 'Luma notifies when new patterns emerge',
                    value: settings.notificationsEnabled,
                    onChanged: (_) => settings.toggleNotifications(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ─── PRIVASI & DATA ──────────────────────────────────────
              _SectionHeader(isId ? 'PRIVASI & DATA' : 'PRIVACY & DATA'),
              _SettingsCard(
                children: [
                  _SwitchTile(
                    title: isId ? 'Amati Pola Penggunaan' : 'Observe Usage Patterns',
                    subtitle: isId
                        ? 'Izinkan Luma mengamati ritme harianmu'
                        : 'Allow Luma to observe your daily rhythm',
                    value: settings.dataCollectionEnabled,
                    onChanged: (_) => settings.toggleDataCollection(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ─── CADANGAN & TENTANG LUMA ─────────────────────────────
              _SectionHeader(isId ? 'LAINNYA' : 'OTHER'),
              _SettingsCard(
                children: [
                  _TapTile(
                    title: isId ? 'Cadangan & Pemulihan' : 'Backup & Restore',
                    value: settings.lastBackupDate != null
                        ? (isId ? 'Aktif' : 'Active')
                        : (isId ? 'Belum dicadangkan' : 'Not backed up'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BackupPage()),
                    ),
                  ),
                  _Divider(),
                  _TapTile(
                    title: isId ? 'Tentang Aplikasi' : 'About App',
                    value: 'Luma v1.0.0',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ─── VERSI ───────────────────────────────────────────────
              Center(
                child: Text(
                  'Luma v1.0.0',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: p.textSubtle,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Personal Digital Behavior Intelligence',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: p.textSubtle,
                  ),
                ),
              ),
              context.lumaBottomSpacer,
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 2),
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
          color: p.textTertiary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return Container(
      decoration: BoxDecoration(
        color: p.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: p.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: p.textTertiary,
          height: 1.5,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeTrackColor: p.accentMuted,
      activeThumbColor: p.accentLight,
      inactiveTrackColor: p.bgElevated,
    );
  }
}

class _TapTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _TapTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: p.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: p.textTertiary,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: p.textSubtle,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final String label;
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeTile({
    required this.label,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ThemePill(
                icon: Icons.brightness_auto,
                label: 'Auto',
                selected: currentMode == ThemeMode.system,
                onTap: () => onChanged(ThemeMode.system),
              ),
              const SizedBox(width: 8),
              _ThemePill(
                icon: Icons.brightness_2,
                label: 'Gelap',
                selected: currentMode == ThemeMode.dark,
                onTap: () => onChanged(ThemeMode.dark),
              ),
              const SizedBox(width: 8),
              _ThemePill(
                icon: Icons.brightness_high,
                label: 'Terang',
                selected: currentMode == ThemeMode.light,
                onTap: () => onChanged(ThemeMode.light),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemePill({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? p.accentMuted : p.bgElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? p.accent : p.borderFaint,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? p.accentLight : p.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                color: selected ? p.accentLight : p.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    return Container(height: 1, color: p.borderFaint);
  }
}
