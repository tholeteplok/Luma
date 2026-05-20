import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/colors.dart';
import '../../core/utils/luma_l10n.dart';
import '../../core/platform/permission_service.dart';
import '../widgets/ambient_orb.dart';
import '../widgets/outlined_ghost_button.dart';

/// PermissionGatewayPage — Gerbang izin sebelum masuk ke home.
///
/// Permission yang diminta:
/// 1. App Usage (WAJIB) — buka Settings manual, polling auto-check
/// 2. Notifikasi (OPSIONAL) — dialog sistem standar Android 13+
///
/// Tombol LANJUT aktif hanya setelah App Usage granted.
/// Notifikasi bisa di-skip.
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
  bool _notificationGranted = false;
  bool _isPollingUsage = false;
  bool _isRequestingNotification = false;
  bool _notificationPermanentlyDenied = false;
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isPollingUsage) _startPollingUsage();
      // Re-check notifikasi saat kembali dari Settings (permanently denied case)
      if (_notificationPermanentlyDenied) _recheckNotification();
    }
  }

  Future<void> _checkExistingPermissions() async {
    final usageGranted = await PermissionService.hasUsageStatsPermission();
    final notifGranted = await PermissionService.hasNotificationPermission();
    if (mounted) {
      setState(() {
        _appUsageGranted = usageGranted;
        _notificationGranted = notifGranted;
      });
    }
  }

  // ── App Usage ──────────────────────────────────────────────────────────────

  Future<void> _requestAppUsagePermission() async {
    setState(() => _isPollingUsage = true);
    await PermissionService.openUsageAccessSettings();
    _startPollingUsage();
  }

  void _startPollingUsage() {
    _pollTimer?.cancel();
    int attempts = 0;
    _pollTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      attempts++;
      final granted = await PermissionService.hasUsageStatsPermission();
      if (granted && mounted) {
        timer.cancel();
        setState(() {
          _appUsageGranted = true;
          _isPollingUsage = false;
        });
      } else if (attempts >= 40) {
        timer.cancel();
        if (mounted) setState(() => _isPollingUsage = false);
      }
    });
  }

  // ── Notifications ──────────────────────────────────────────────────────────

  Future<void> _requestNotificationPermission() async {
    if (_notificationGranted) return;

    // Jika permanently denied → buka App Settings
    if (_notificationPermanentlyDenied) {
      await PermissionService.openSystemAppSettings();
      return;
    }

    setState(() => _isRequestingNotification = true);
    final granted = await PermissionService.requestNotificationPermission();
    final permanentlyDenied =
        !granted && await PermissionService.isNotificationPermanentlyDenied();

    if (mounted) {
      setState(() {
        _notificationGranted = granted;
        _notificationPermanentlyDenied = permanentlyDenied;
        _isRequestingNotification = false;
      });
    }
  }

  Future<void> _recheckNotification() async {
    final granted = await PermissionService.hasNotificationPermission();
    if (mounted && granted) {
      setState(() {
        _notificationGranted = true;
        _notificationPermanentlyDenied = false;
      });
    }
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
              height: screenH * 0.28,
              child: Center(
                child: AmbientOrb(
                  state: OrbState.dawn,
                  size: screenH * 0.18,
                ),
              ),
            ),

            // ── Konten ────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.permTitle,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: p.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.permSubtitle,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: p.textTertiary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Item 1: App Usage (wajib) ─────────────────────────────
                    _PermissionItem(
                      icon: Icons.phonelink_setup_outlined,
                      title: context.l10n.permUsageTitle,
                      subtitle: context.l10n.permUsageSubtitle,
                      isGranted: _appUsageGranted,
                      isLoading: _isPollingUsage && !_appUsageGranted,
                      isRequired: true,
                      onTap: _appUsageGranted ? null : _requestAppUsagePermission,
                    ),

                    const SizedBox(height: 14),

                    // ── Item 2: Notifikasi (opsional) ─────────────────────────
                    _PermissionItem(
                      icon: Icons.notifications_outlined,
                      title: context.l10n.permNotifTitle,
                      subtitle: _notificationPermanentlyDenied
                          ? context.l10n.permNotifDenied
                          : context.l10n.permNotifSubtitle,
                      isGranted: _notificationGranted,
                      isLoading: _isRequestingNotification,
                      isRequired: false,
                      actionLabel: _notificationPermanentlyDenied
                          ? context.l10n.permOpenSettings
                          : null,
                      onTap: _notificationGranted
                          ? null
                          : _requestNotificationPermission,
                    ),
                  ],
                ),
              ),
            ),

            // ── CTA ───────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
              child: Column(
                children: [
                  OutlinedGhostButton(
                    text: context.l10n.permContinue,
                    enabled: _canProceed,
                    onPressed: _canProceed ? widget.onPermissionsGranted : null,
                  ),
                  if (!_appUsageGranted) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: widget.onPermissionsGranted,
                      child: Text(
                        context.l10n.permSkip,
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
  final String? actionLabel; // override label arrow
  final VoidCallback? onTap;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isGranted,
    required this.isLoading,
    required this.isRequired,
    this.actionLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.luma;

    final borderColor = isGranted
        ? p.gentleInd.withValues(alpha: 0.5)
        : p.borderSubtle;
    final bgColor = isGranted ? p.gentleBadgeBg : Colors.transparent;

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
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isGranted ? p.gentleText : p.textPrimary,
                          ),
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
                            context.l10n.permRequired,
                            style: GoogleFonts.dmSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: p.accentLight,
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: p.bgElevated,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            context.l10n.permOptional,
                            style: GoogleFonts.dmSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: p.textTertiary,
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

            // ── Trailing ─────────────────────────────────────────────────────
            if (!isGranted && !isLoading) ...[
              const SizedBox(width: 8),
              actionLabel != null
                  ? Text(
                      actionLabel!,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: p.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Icon(Icons.arrow_forward_ios, size: 14, color: p.textSubtle),
            ],
          ],
        ),
      ),
    );
  }
}
