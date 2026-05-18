/// Tipe event yang direkam oleh Luma
/// 
/// Note: File ini adalah duplikasi dari enum di raw_event.dart
/// untuk menghindari circular dependency. Sebaiknya gunakan
/// EventType dari raw_event.dart setelah generate build_runner.
enum EventType {
  app_usage,      // Penggunaan aplikasi
  screen_state,   // Screen ON/OFF
  notification,   // Notification received (future)
  unlock,         // Device unlocked (future)
}
