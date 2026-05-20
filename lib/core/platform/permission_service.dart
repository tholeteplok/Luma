import 'package:flutter/services.dart';

/// PermissionService — Komunikasi langsung dengan Android untuk permission.
///
/// Menggunakan MethodChannel `luma/permissions` yang diimplementasikan
/// di MainActivity.kt dengan AppOpsManager — lebih reliable dari
/// `usage_stats` package dan menghindari dialog "Aplikasi ditolak aksesnya"
/// dari OEM (Samsung, Xiaomi, dll).
///
/// Perbedaan kunci dari UsageStats.grantUsagePermission():
/// - Membuka Settings langsung ke entry Luma (bukan halaman umum)
/// - Menggunakan URI `package:com.tholteplok.luma` (Android 10+)
/// - Tidak memicu dialog Play Protect / OEM restriction
class PermissionService {
  static const _channel = MethodChannel('luma/permissions');

  /// Cek apakah PACKAGE_USAGE_STATS sudah di-grant.
  /// Menggunakan AppOpsManager di native — lebih akurat dari Flutter package.
  static Future<bool> hasUsageStatsPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasUsageStatsPermission');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      // Desktop/non-Android — tidak didukung
      return false;
    }
  }

  /// Buka Usage Access Settings langsung ke entry Luma.
  /// Tidak mengembalikan nilai — user harus grant manual di Settings.
  static Future<void> openUsageAccessSettings() async {
    try {
      await _channel.invokeMethod('openUsageAccessSettings');
    } on PlatformException {
      // Ignore — fallback sudah dihandle di native
    } on MissingPluginException {
      // Desktop — tidak ada yang perlu dilakukan
    }
  }
}
