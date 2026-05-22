import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/themes/colors.dart';
import '../../data/backup/drive_backup_manager.dart';
import '../bloc/settings_bloc.dart';

/// BackupPage — Manajemen Pencadangan Awan Luma
class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  Future<List<BackupEntry>>? _backupsFuture;
  int _localSizeEstimate = 0;

  @override
  void initState() {
    super.initState();
    _refreshBackups();
    _estimateLocalSize();
  }

  void _refreshBackups() {
    setState(() {
      _backupsFuture = Provider.of<SettingsNotifier>(context, listen: false).listBackups();
    });
  }

  Future<void> _estimateLocalSize() async {
    final size = await Provider.of<SettingsNotifier>(context, listen: false).estimateBackupSize();
    if (mounted) {
      setState(() {
        _localSizeEstimate = size;
      });
    }
  }

  String _formatBackupDate(DateTime? date, bool isId) {
    if (date == null) {
      return isId ? 'Belum pernah' : 'Never';
    }
    return DateFormat(isId ? 'dd MMMM yyyy, HH:mm' : 'MMM d, yyyy h:mm a')
        .format(date);
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required bool isSuccess,
    required bool isId,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isSuccess
            ? const Color(0xFF1E4A38)
            : const Color(0xFF3A1A10),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 4),
        action: isSuccess
            ? null
            : SnackBarAction(
                label: 'OK',
                textColor: const Color(0xFFEEE8B2),
                onPressed: () => messenger.clearSnackBars(),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, settings, _) {
        final p = context.luma;
        final isId = settings.languageCode == 'id';

        return Scaffold(
          backgroundColor: p.bgBase,
          appBar: AppBar(
            backgroundColor: p.bgBase,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              color: p.textSecondary,
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              isId ? 'Cadangan & Pemulihan' : 'Backup & Restore',
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: p.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              _refreshBackups();
              await _estimateLocalSize();
            },
            color: p.accent,
            backgroundColor: p.bgSurface,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                // ─── KARTU UTAMA CADANGAN ─────────────────────────────
                _BackupCard(
                  children: [
                    // Kutipan emosional
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Text(
                        isId
                            ? '"Jika ingin menjaga detail lebih lama, simpan salinan ke Google Drive.\n\nJika tidak, Luma akan merangkumnya seperti ingatan biasa."'
                            : '"If you want to keep details longer, save a copy to Google Drive.\n\nIf not, Luma will summarize them like ordinary memory."',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: p.textSecondary,
                          height: 1.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _Divider(),

                    // Status akun terhubung
                    if (settings.connectedEmail != null) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: [
                            Icon(Icons.account_circle_outlined, size: 14, color: p.gentleText),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                settings.connectedEmail!,
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: p.gentleText,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Waktu cadangan terakhir
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                      child: Row(
                        children: [
                          Icon(Icons.history, size: 14, color: p.textSubtle),
                          const SizedBox(width: 6),
                          Text(
                            isId ? 'Terakhir: ' : 'Last: ',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: p.textSubtle,
                            ),
                          ),
                          Text(
                            _formatBackupDate(settings.lastBackupDate, isId),
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: settings.lastBackupDate != null ? p.textSecondary : p.textSubtle,
                              fontWeight: settings.lastBackupDate != null
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Estimasi ukuran data lokal
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: Row(
                        children: [
                          Icon(Icons.data_usage, size: 14, color: p.textSubtle),
                          const SizedBox(width: 6),
                          Text(
                            isId ? 'Ukuran Data Lokal: ' : 'Local Data Size: ',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: p.textSubtle,
                            ),
                          ),
                          Text(
                            _formatSize(_localSizeEstimate),
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: p.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tombol Cadangkan Sekarang
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: _ActionButton(
                          label: isId ? 'Cadangkan Sekarang' : 'Backup Now',
                          isLoading: settings.isBackingUp,
                          onPressed: settings.isBackingUp
                              ? null
                              : () async {
                                  final ok = await settings.exportBackup();
                                  if (context.mounted) {
                                    _showSnackBar(
                                      context,
                                      ok
                                          ? (isId ? 'Cadangan berhasil disimpan.' : 'Backup saved successfully.')
                                          : (settings.error ?? (isId ? 'Backup gagal.' : 'Backup failed.')),
                                      isSuccess: ok,
                                      isId: isId,
                                    );
                                    if (ok) {
                                      _refreshBackups();
                                    }
                                  }
                                },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Divider(),

                    // Auto-backup toggle
                    _SwitchTile(
                      title: isId ? 'Cadangan otomatis tiap Minggu' : 'Auto-backup every Sunday',
                      subtitle: isId ? 'Hanya saat charging + WiFi' : 'Only when charging + WiFi',
                      value: settings.autoBackupEnabled,
                      onChanged: (_) => settings.toggleAutoBackup(),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ─── SEKSI RIWAYAT CADANGAN ────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 2),
                  child: Text(
                    isId ? 'RIWAYAT CADANGAN DI AWAN' : 'CLOUD BACKUP HISTORY',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      color: p.textTertiary,
                    ),
                  ),
                ),

                FutureBuilder<List<BackupEntry>>(
                  future: _backupsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: p.bgSurface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: p.accent,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: p.bgSurface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          isId
                              ? 'Gagal memuat riwayat cadangan.'
                              : 'Failed to load backup history.',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: p.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final backups = snapshot.data ?? [];
                    if (backups.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: p.bgSurface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.cloud_off, size: 28, color: p.textSubtle),
                            const SizedBox(height: 12),
                            Text(
                              isId
                                  ? 'Penyimpanan awan masih kosong.'
                                  : 'No cloud backups found.',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: p.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isId
                                  ? 'Lakukan cadangan pertama untuk menyimpan ingatan Luma Anda.'
                                  : 'Perform your first backup to preserve your Luma memories.',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: p.textTertiary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: p.bgSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: backups.length,
                        separatorBuilder: (context, index) => _Divider(),
                        itemBuilder: (context, index) {
                          final backup = backups[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              _formatBackupDate(backup.createdAt.toLocal(), isId),
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: p.textPrimary,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${isId ? 'Ukuran: ' : 'Size: '}${_formatSize(backup.sizeBytes)}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: p.textTertiary,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tombol Pulihkan
                                IconButton(
                                  icon: const Icon(Icons.settings_backup_restore, size: 20),
                                  color: p.accentLight,
                                  tooltip: isId ? 'Pulihkan' : 'Restore',
                                  onPressed: settings.isRestoring
                                      ? null
                                      : () => _confirmRestore(context, settings, backup, isId),
                                ),
                                // Tombol Hapus
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20),
                                  color: const Color(0xFFEF5350).withValues(alpha: 0.8),
                                  tooltip: isId ? 'Hapus' : 'Delete',
                                  onPressed: settings.isLoading
                                      ? null
                                      : () => _confirmDelete(context, settings, backup, isId),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                context.lumaBottomSpacer,
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmRestore(
    BuildContext context,
    SettingsNotifier s,
    BackupEntry backup,
    bool isId,
  ) async {
    final p = context.luma;

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: p.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final pp = ctx.luma;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isId ? 'Pulihkan dari Cadangan?' : 'Restore from Backup?',
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: pp.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isId
                    ? 'Ini akan mengganti data saat ini secara permanen.\n\nCadangan tanggal: ${DateFormat('dd MMMM yyyy, HH:mm').format(backup.createdAt.toLocal())}'
                    : 'This will permanently replace your current data.\n\nBackup date: ${DateFormat('MMMM d, yyyy h:mm a').format(backup.createdAt.toLocal())}',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: pp.textSecondary,
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
                        side: BorderSide(color: pp.borderSubtle),
                        foregroundColor: pp.textSecondary,
                      ),
                      child: Text(isId ? 'Batal' : 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pp.accentMuted,
                        foregroundColor: pp.accentLight,
                      ),
                      child: Text(isId ? 'Pulihkan' : 'Restore'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (confirm == true && context.mounted) {
      final ok = await s.importBackup(backup.fileId);
      if (context.mounted) {
        _showSnackBar(
          context,
          ok
              ? (isId ? 'Pemulihan selesai dengan sukses.' : 'Restore completed successfully.')
              : (s.error ?? (isId ? 'Pemulihan gagal.' : 'Restore failed.')),
          isSuccess: ok,
          isId: isId,
        );
      }
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SettingsNotifier s,
    BackupEntry backup,
    bool isId,
  ) async {
    final p = context.luma;

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: p.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final pp = ctx.luma;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isId ? 'Hapus Cadangan Ini?' : 'Delete This Backup?',
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEF5350),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isId
                    ? 'Tindakan ini akan menghapus file cadangan ini secara permanen dari Google Drive Anda.\n\nCadangan tanggal: ${DateFormat('dd MMMM yyyy, HH:mm').format(backup.createdAt.toLocal())}'
                    : 'This action will permanently delete this backup file from your Google Drive.\n\nBackup date: ${DateFormat('MMMM d, yyyy h:mm a').format(backup.createdAt.toLocal())}',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: pp.textSecondary,
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
                        side: BorderSide(color: pp.borderSubtle),
                        foregroundColor: pp.textSecondary,
                      ),
                      child: Text(isId ? 'Batal' : 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF5350).withValues(alpha: 0.15),
                        foregroundColor: const Color(0xFFEF5350),
                        elevation: 0,
                      ),
                      child: Text(isId ? 'Hapus' : 'Delete'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (confirm == true && context.mounted) {
      final ok = await s.deleteBackup(backup.fileId);
      if (context.mounted) {
        _showSnackBar(
          context,
          ok
              ? (isId ? 'Cadangan berhasil dihapus.' : 'Backup deleted successfully.')
              : (s.error ?? (isId ? 'Gagal menghapus.' : 'Deletion failed.')),
          isSuccess: ok,
          isId: isId,
        );
        if (ok) {
          _refreshBackups();
        }
      }
    }
  }
}

// ─── WIDGET PENDUKUNG INTERNAL ────────────────────────────────────────

class _BackupCard extends StatelessWidget {
  final List<Widget> children;
  const _BackupCard({required this.children});

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

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    final child = isLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: p.accentLight,
            ),
          )
        : Text(label);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: p.accentMuted,
        foregroundColor: p.accentLight,
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: child,
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
