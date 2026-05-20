import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// PermissionService — Komunikasi dengan Android untuk semua permission Luma.
///
/// Dua jenis permission yang dikelola:
///
/// 1. PACKAGE_USAGE_STATS — restricted permission, harus grant manual di Settings.
///    Menggunakan MethodChannel 'luma/permissions' → AppOpsManager di native.
///    Menghindari dialog "Aplikasi ditolak aksesnya" dari OEM.
///
/// 2. POST_NOTIFICATIONS — runtime permission (Android 13+).
///    Menggunakan permission_handler — dialog sistem standar.
///    Android < 13: selalu granted (tidak perlu diminta).
class PermissionService {
  static const _channel = MethodChannel('luma/permissions');

  // ── Usage Stats (restricted permission) ────────────────────────────────────

  /// Cek apakah PACKAGE_USAGE_STATS sudah di-grant.
  /// Menggunakan AppOpsManager di native — lebih akurat dari Flutter package.
  static Future<bool> hasUsageStatsPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasUsageStatsPermission');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false; // Desktop/non-Android
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

  // ── Notifications (runtime permission) ─────────────────────────────────────

  /// Cek apakah POST_NOTIFICATIONS sudah di-grant.
  /// Android < 13: selalu true (permission tidak ada di versi lama).
  static Future<bool> hasNotificationPermission() async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return true;
      final status = await ph.Permission.notification.status;
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }

  /// Minta izin notifikasi — tampilkan dialog sistem standar Android.
  /// Return true jika granted, false jika denied.
  static Future<bool> requestNotificationPermission() async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return true;
      final status = await ph.Permission.notification.request();
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }

  /// Apakah user sudah pilih "Jangan tanya lagi" untuk notifikasi?
  static Future<bool> isNotificationPermanentlyDenied() async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return false;
      final status = await ph.Permission.notification.status;
      return status.isPermanentlyDenied;
    } catch (_) {
      return false;
    }
  }

  /// Buka App Settings (untuk kasus permanently denied).
  static Future<void> openSystemAppSettings() async {
    try {
      await ph.openAppSettings();
    } catch (_) {}
  }
}
