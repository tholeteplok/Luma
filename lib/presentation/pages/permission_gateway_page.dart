import 'package:flutter/material.dart';
import 'package:luma/core/themes/colors.dart';
import 'package:luma/presentation/widgets/ambient_visualization.dart';
import 'package:luma/presentation/widgets/outlined_ghost_button.dart';
import 'package:luma/core/services/background_task_manager.dart';

/// PermissionGatewayPage — Halaman onboarding permission bergaya Luma.
///
/// Ditampilkan saat user belum memberikan akses Usage Stats.
/// Tidak memaksa — hanya mengundang.
///
/// Filosofi: "Luma mengamati hanya jika kamu mengizinkan."
class PermissionGatewayPage extends StatefulWidget {
  /// Dipanggil saat user memberi izin ATAU memilih untuk melewati
  final VoidCallback onContinue;

  const PermissionGatewayPage({super.key, required this.onContinue});

  @override
  State<PermissionGatewayPage> createState() => _PermissionGatewayPageState();
}

class _PermissionGatewayPageState extends State<PermissionGatewayPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;
  bool _isWaitingReturn = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _openUsageSettings() async {
    setState(() => _isWaitingReturn = true);
    // Buka Android Usage Access Settings
    await BackgroundTaskManager.openUsageAccessSettings();
  }

  Future<void> _onReturnFromSettings() async {
    // Cek ulang apakah permission sudah granted
    final granted = await BackgroundTaskManager.hasUsageStatsPermission();
    if (mounted) {
      if (granted) {
        widget.onContinue();
      } else {
        setState(() => _isWaitingReturn = false);
        // Tampilkan hint singkat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Belum diizinkan — kamu bisa mengubahnya kapan saja di pengaturan.',
              style: TextStyle(fontFamily: 'Cormorant'),
            ),
            backgroundColor: AppColors.bgElevated,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Visual ambient — sama dengan onboarding
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const AmbientVisualization(variant: 2),
                  // Pulse ring di sekitar orb
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (context, _) {
                      return Container(
                        width: 80 + (_pulseAnim.value * 20),
                        height: 80 + (_pulseAnim.value * 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryDark.withValues(
                              alpha: (1 - _pulseAnim.value) * 0.4,
                            ),
                            width: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Narasi utama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _isWaitingReturn
                    ? 'Kembali ke Luma\nsetelah mengatur izin.'
                    : 'Untuk mengamati ritmu,\nLuma perlu sedikit akses.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      height: 1.35,
                    ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // Sub teks — filosofi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _isWaitingReturn
                    ? 'Di halaman pengaturan, ketuk nama Luma\nlalu aktifkan akses penggunaan.'
                    : 'Tidak ada yang dinilai.\nSemua data hanya ada di perangkatmu.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDarkSecondary,
                      height: 1.6,
                    ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            // Privacy badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.positive.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.positive.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: AppColors.positive.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Data tidak pernah meninggalkan perangkatmu',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textDarkSecondary,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // CTA Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (_isWaitingReturn) ...[
                    // Sudah kembali dari settings
                    OutlinedGhostButton(
                      text: 'Sudah diizinkan',
                      onPressed: _onReturnFromSettings,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: widget.onContinue,
                      child: Text(
                        'Lewati untuk sekarang',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textDarkSecondary,
                            ),
                      ),
                    ),
                  ] else ...[
                    // Belum buka settings
                    OutlinedGhostButton(
                      text: 'Izinkan Luma Mengamati',
                      onPressed: _openUsageSettings,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: widget.onContinue,
                      child: Text(
                        'Lewati dulu',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textDarkSecondary,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
