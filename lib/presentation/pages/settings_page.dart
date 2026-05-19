import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/themes/colors.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/theme_bloc.dart';

/// SettingsPage — Pengaturan Luma
///
/// Langsung consume SettingsNotifier dan ThemeNotifier via Provider.
/// Tidak ada prop-drilling callback — semua toggle real-time dan persist.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer agar rebuild otomatis saat state berubah
    return Consumer2<SettingsNotifier, ThemeNotifier>(
      builder: (context, settings, theme, _) {
        final isId = settings.languageCode == 'id';

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            backgroundColor: AppColors.bgBase,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              color: AppColors.textSecondary,
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              isId ? 'Pengaturan' : 'Settings',
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
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
                    onChanged: (mode) => theme.setThemeMode(mode),
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

              // ─── CADANGAN EMOSIONAL ──────────────────────────────────
              _SectionHeader(isId ? 'CADANGAN' : 'BACKUP'),
              _BackupSection(settings: settings, isId: isId),
              const SizedBox(height: 40),

              // ─── VERSI ───────────────────────────────────────────────
              Center(
                child: Text(
                  'Luma v1.0.0',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textSubtle,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Personal Digital Behavior Intelligence',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppColors.textSubtle,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BACKUP SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _BackupSection extends StatefulWidget {
  final SettingsNotifier settings;
  final bool isId;

  const _BackupSection({required this.settings, required this.isId});

  @override
  State<_BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<_BackupSection> {
  String _formatBackupDate(DateTime? date) {
    if (date == null) {
      return widget.isId ? 'Belum pernah' : 'Never';
    }
    return DateFormat(widget.isId ? 'dd MMMM yyyy, HH:mm' : 'MMM d, yyyy h:mm a')
        .format(date);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    return _SettingsCard(
      children: [
        // Narasi emosional
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            widget.isId
                ? '"Jika ingin menjaga detail lebih lama, simpan salinan ke Google Drive.\n\nJika tidak, Luma akan merangkumnya seperti ingatan biasa."'
                : '"If you want to keep details longer, save a copy to Google Drive.\n\nIf not, Luma will summarize them like ordinary memory."',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 4),
        _Divider(),

        // Last backup info
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              const Icon(Icons.history, size: 14, color: AppColors.textSubtle),
              const SizedBox(width: 6),
              Text(
                _formatBackupDate(s.lastBackupDate),
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Cadangkan sekarang
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: _ActionButton(
              label: widget.isId ? 'Cadangkan Sekarang' : 'Backup Now',
              isLoading: s.isBackingUp,
              onPressed: s.isBackingUp
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final ok = await s.exportBackup();
                      if (!ok && mounted) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(s.error ??
                                (widget.isId
                                    ? 'Backup gagal'
                                    : 'Backup failed')),
                            backgroundColor: AppColors.bgElevated,
                          ),
                        );
                      }
                    },
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Pulihkan
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: _ActionButton(
              label: widget.isId ? 'Pulihkan dari Drive' : 'Restore from Drive',
              isLoading: s.isRestoring,
              isPrimary: false,
              onPressed: (s.isRestoring || s.lastBackupDate == null)
                  ? null
                  : () => _confirmRestore(context, s),
            ),
          ),
        ),
        const SizedBox(height: 4),
        _Divider(),

        // Auto-backup toggle
        _SwitchTile(
          title: widget.isId
              ? 'Cadangan otomatis tiap Minggu'
              : 'Auto-backup every Sunday',
          subtitle: widget.isId
              ? 'Hanya saat charging + WiFi'
              : 'Only when charging + WiFi',
          value: s.autoBackupEnabled,
          onChanged: (_) => s.toggleAutoBackup(),
        ),
      ],
    );
  }

  Future<void> _confirmRestore(
    BuildContext context,
    SettingsNotifier s,
  ) async {
    // Capture sebelum semua async gap
    final messenger = ScaffoldMessenger.of(context);

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isId ? 'Pulihkan dari Cadangan?' : 'Restore from Backup?',
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.isId
                  ? 'Ini akan mengganti data saat ini.\n\nCadangan: ${DateFormat('dd MMMM yyyy').format(s.lastBackupDate!)}'
                  : 'This will replace current data.\n\nBackup: ${DateFormat('MMMM d, yyyy').format(s.lastBackupDate!)}',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderSubtle),
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: Text(widget.isId ? 'Batal' : 'Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentMuted,
                      foregroundColor: AppColors.accentLight,
                    ),
                    child: Text(widget.isId ? 'Pulihkan' : 'Restore'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (confirm == true && mounted) {
      await s.importBackup();
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(widget.isId
                ? 'Pemulihan selesai'
                : 'Restore complete'),
            backgroundColor: AppColors.bgElevated,
          ),
        );
      }
    }
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 2),
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
          color: AppColors.textTertiary,
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
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
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: AppColors.textTertiary,
          height: 1.5,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.accentMuted,
      activeThumbColor: AppColors.accentLight,
      inactiveTrackColor: AppColors.bgElevated,
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.textSubtle,
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
              color: AppColors.textPrimary,
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentMuted : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.borderFaint,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppColors.accentLight : AppColors.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                color: selected ? AppColors.accentLight : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool isPrimary;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    this.isLoading = false,
    this.isPrimary = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppColors.accentLight,
            ),
          )
        : Text(label);

    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentMuted,
          foregroundColor: AppColors.accentLight,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: child,
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        side: const BorderSide(color: AppColors.borderSubtle),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: child,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.borderFaint);
  }
}
