import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/colors.dart';
import '../../core/platform/permission_service.dart';
import '../widgets/ambient_orb.dart';
import '../widgets/outlined_ghost_button.dart';

/// PermissionGatewayPage — Gerbang izin sebelum masuk ke home.
///
/// Flow:
/// 1. Cek permission yang sudah ada saat init
/// 2. User tap item → buka Settings Android
/// 3. App polling hasUsageStatsPermission() setiap 500ms saat kembali
/// 4. Checkbox auto-check saat permission terdeteksi
/// 5. Tombol LANJUT aktif saat app usage granted (Drive opsional)
///
/// Ini adalah blocage yang necessary — tanpa app usage permission,
/// Luma tidak bisa melihat apapun.
class PermissionGatewayPage extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionGatewayPage({
    super.key,
    required this.onPermissionsGranted,
  });

  @override
  State<PermissionGatewayPage> createState() => _PermissionGatewayPageState();
}

class _PermissionGatewayPageState extends State<PermissionGatewayPage>
    with WidgetsBindingObserver {
  bool _appUsageGranted = false;
  bool _driveBackupGranted = false; // opsional
  bool _isPolling = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkExistingPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    super.dispose();
  }

  /// Dipanggil saat app kembali ke foreground (dari Settings)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isPolling) {
      _startPolling();
    }
  }

  /// Cek permission yang sudah ada saat pertama buka
  Future<void> _checkExistingPermissions() async {
    final granted = await PermissionService.hasUsageStatsPermission();
    if (mounted) {
      setState(() => _appUsageGranted = granted);
    }
  }

  /// User tap checkbox app usage → buka Settings
  Future<void> _requestAppUsagePermission() async {
    setState(() => _isPolling = true);
    await PermissionService.openUsageAccessSettings();
    // Polling dimulai saat app kembali ke foreground (via didChangeAppLifecycleState)
    _startPolling();
  }

  /// Poll setiap 500ms sampai permission granted atau max 20 detik
  void _startPolling() {
    _pollTimer?.cancel();
    int attempts = 0;
    _pollTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      attempts++;
      final granted = await PermissionService.hasUsageStatsPermission();
      if (granted && mounted) {
        timer.cancel();
        setState(() {
          _appUsageGranted = true;
          _isPolling = false;
        });
      } else if (attempts >= 40) {
        timer.cancel();
        if (mounted) setState(() => _isPolling = false);
      }
    });
  }

  bool get _canProceed => _appUsageGranted;

  @override
  Widget build(BuildContext context) {
    final p = context.luma;
    final screenH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: p.bgBase,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Orb visual ────────────────────────────────────────────────────
            SizedBox(
              height: screenH * 0.30,
              child: Center(
                child: AmbientOrb(
                  state: OrbState.dawn,
                  size: screenH * 0.20,
                  reduceMotion: false,
                ),
              ),
            ),

            // ── Konten ────────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Luma butuh izin\nuntuk bekerja.',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: p.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tidak ada yang dinilai. Semua data hanya ada di perangkatmu.',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: p.textTertiary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Permission item 1: App Usage (wajib) ─────────────────
                    _PermissionItem(
                      icon: Icons.phonelink_setup_outlined,
                      title: 'Akses ke daftar aplikasi',
                      subtitle: 'Luma melihat app apa saja yang kamu buka — '
                          'ini satu-satunya cara Luma bisa mengamati.',
                      isGranted: _appUsageGranted,
                      isLoading: _isPolling && !_appUsageGranted,
                      isRequired: true,
                      onTap: _appUsageGranted ? null : _requestAppUsagePermission,
                    ),

                    const SizedBox(height: 16),

                    // ── Permission item 2: Google Drive (opsional) ───────────
                    _PermissionItem(
                      icon: Icons.cloud_upload_outlined,
                      title: 'Cadangan di Google Drive',
                      subtitle: 'Opsional — untuk backup insight dan pola kamu.',
                      isGranted: _driveBackupGranted,
                      isLoading: false,
                      isRequired: false,
                      onTap: _driveBackupGranted
                          ? null
                          : () {
                              // Drive permission dihandle saat user tap backup
                              // di Settings — tidak perlu diminta di sini
                              setState(() => _driveBackupGranted = true);
                            },
                    ),
                  ],
                ),
              ),
            ),

            // ── CTA ───────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
              child: Column(
                children: [
                  OutlinedGhostButton(
                    text: 'Lanjut',
                    enabled: _canProceed,
                    onPressed: _canProceed ? widget.onPermissionsGranted : null,
                  ),
                  if (!_appUsageGranted) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: widget.onPermissionsGranted,
                      child: Text(
                        'Lewati dulu',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: p.textSubtle,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PERMISSION ITEM WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGranted;
  final bool isLoading;
  final bool isRequired;
  final VoidCallback? onTap;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isGranted,
    required this.isLoading,
    required this.isRequired,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;

    final borderColor = isGranted
        ? p.gentleInd.withValues(alpha: 0.5)
        : p.borderSubtle;
    final bgColor = isGranted
        ? p.gentleBadgeBg
        : Colors.transparent;

    return GestureDetector(
      onTap: isGranted ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Checkbox circle ──────────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isGranted ? p.gentleInd : Colors.transparent,
                border: Border.all(
                  color: isGranted ? p.gentleInd : p.textTertiary,
                  width: 1.5,
                ),
              ),
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(4),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: p.textTertiary,
                      ),
                    )
                  : isGranted
                      ? Icon(Icons.check, size: 14, color: p.bgBase)
                      : null,
            ),

            const SizedBox(width: 14),

            // ── Text ─────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isGranted ? p.gentleText : p.textPrimary,
                        ),
                      ),
                      if (isRequired) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: p.accentMuted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'WAJIB',
                            style: GoogleFonts.dmSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: p.accentLight,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: p.textTertiary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // ── Arrow (hanya saat belum granted) ─────────────────────────────
            if (!isGranted && !isLoading) ...[
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 14, color: p.textSubtle),
            ],
          ],
        ),
      ),
    );
  }
}
