import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/themes/colors.dart';
import '../widgets/theme_switcher.dart';

/// Settings page untuk mengelola preferensi user
class SettingsPage extends StatefulWidget {
  final String languageCode;
  final bool notificationsEnabled;
  final bool dataCollectionEnabled;
  final ThemeMode themeMode;
  final DateTime? lastBackupDate;
  final Function(String) onLanguageChanged;
  final Function(bool) onNotificationsToggled;
  final Function(bool) onDataCollectionToggled;
  final Function(ThemeMode) onThemeChanged;
  final Future<bool> Function() onExportBackup;
  final Future<bool> Function() onImportBackup;

  const SettingsPage({
    super.key,
    required this.languageCode,
    required this.notificationsEnabled,
    required this.dataCollectionEnabled,
    required this.themeMode,
    this.lastBackupDate,
    required this.onLanguageChanged,
    required this.onNotificationsToggled,
    required this.onDataCollectionToggled,
    required this.onThemeChanged,
    required this.onExportBackup,
    required this.onImportBackup,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isExporting = false;
  bool _isImporting = false;

  String _getBackupDateText() {
    if (widget.lastBackupDate == null) {
      return 'Belum pernah backup';
    }
    final formatter = DateFormat('dd MMMM yyyy, HH:mm', widget.languageCode);
    return 'Terakhir: ${formatter.format(widget.lastBackupDate!)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.languageCode == 'id' ? 'Pengaturan' : 'Settings',
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme section
          _buildSectionHeader(
            widget.languageCode == 'id' ? 'Tampilan' : 'Appearance',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.languageCode == 'id' ? 'Mode Tema' : 'Theme Mode',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ThemeSwitcher(
                    currentThemeMode: widget.themeMode,
                    onThemeChanged: widget.onThemeChanged,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Language section
          _buildSectionHeader(
            widget.languageCode == 'id' ? 'Bahasa' : 'Language',
          ),
          Card(
            child: ListTile(
              title: Text(
                widget.languageCode == 'id' ? 'Bahasa Aplikasi' : 'App Language',
              ),
              subtitle: Text(
                widget.languageCode == 'id' ? 'Bahasa Indonesia' : 'English',
              ),
              trailing: IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () {
                  widget.onLanguageChanged(
                    widget.languageCode == 'id' ? 'en' : 'id',
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Notifications section
          _buildSectionHeader(
            widget.languageCode == 'id' ? 'Notifikasi' : 'Notifications',
          ),
          Card(
            child: SwitchListTile(
              title: Text(
                widget.languageCode == 'id'
                    ? 'Notifikasi Insight'
                    : 'Insight Notifications',
              ),
              subtitle: Text(
                widget.languageCode == 'id'
                    ? 'Terima notifikasi untuk insight baru'
                    : 'Receive notifications for new insights',
              ),
              value: widget.notificationsEnabled,
              onChanged: widget.onNotificationsToggled,
              secondary: Icon(
                widget.notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: widget.notificationsEnabled
                    ? AppColors.primaryDark
                    : AppColors.textDarkSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Privacy section
          _buildSectionHeader(
            widget.languageCode == 'id' ? 'Privasi & Data' : 'Privacy & Data',
          ),
          Card(
            child: SwitchListTile(
              title: Text(
                widget.languageCode == 'id'
                    ? 'Koleksi Data'
                    : 'Data Collection',
              ),
              subtitle: Text(
                widget.languageCode == 'id'
                    ? 'Izinkan Luma mengamati pola penggunaan'
                    : 'Allow Luma to observe usage patterns',
              ),
              value: widget.dataCollectionEnabled,
              onChanged: widget.onDataCollectionToggled,
              secondary: Icon(
                widget.dataCollectionEnabled
                    ? Icons.analytics
                    : Icons.analytics_outlined,
                color: widget.dataCollectionEnabled
                    ? AppColors.primaryDark
                    : AppColors.textDarkSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Backup section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.backup,
                        color: AppColors.primaryDark,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.languageCode == 'id'
                                  ? 'Backup & Restore'
                                  : 'Backup & Restore',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getBackupDateText(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textDarkSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isImporting
                              ? null
                              : () async {
                                  setState(() => _isImporting = true);
                                  await widget.onImportBackup();
                                  setState(() => _isImporting = false);
                                },
                          icon: _isImporting
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryDark,
                                  ),
                                )
                              : const Icon(Icons.download, size: 16),
                          label: Text(
                            widget.languageCode == 'id'
                                ? 'Restore'
                                : 'Restore',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isExporting
                              ? null
                              : () async {
                                  setState(() => _isExporting = true);
                                  await widget.onExportBackup();
                                  setState(() => _isExporting = false);
                                },
                          icon: _isExporting
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.upload, size: 16),
                          label: Text(
                            widget.languageCode == 'id' ? 'Backup' : 'Backup',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.languageCode == 'id'
                        ? 'Data disimpan terenkripsi di Google Drive Anda'
                        : 'Data is stored encrypted in your Google Drive',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textDarkSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // About section
          Center(
            child: Text(
              'Luma v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textDarkSecondary,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              widget.languageCode == 'id'
                  ? 'Personal Digital Behavior Intelligence'
                  : 'Personal Digital Behavior Intelligence',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textDarkSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textDarkSecondary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
