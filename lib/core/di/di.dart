import 'package:get_it/get_it.dart';
import '../../data/db/database_service.dart';
import '../../data/encryption/encryption_service.dart';
import '../../data/sync/drive_key_manager.dart';
import '../../data/tracking/usage_stats_service.dart';
import '../../data/tracking/event_aggregator.dart';
import '../../core/platform/screen_state_listener.dart';
import '../../core/services/background_task_manager.dart';

/// Dependency Injection setup menggunakan GetIt
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core Services (Singletons)
  
  // Database Service
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());
  
  // Encryption Service
  sl.registerLazySingleton<EncryptionService>(() => EncryptionService());
  
  // Drive Key Manager
  sl.registerLazySingleton<DriveKeyManager>(() => DriveKeyManager());

  // Platform Services
  sl.registerLazySingleton<ScreenStateListener>(() => ScreenStateListener());

  // Tracking Services
  sl.registerLazySingleton<UsageStatsService>(() => UsageStatsService());
  
  // Event Aggregator (depends on Database, UsageStats, ScreenStateListener)
  sl.registerLazySingleton<EventAggregator>(
    () => EventAggregator(
      db: sl<DatabaseService>(),
      usageStats: sl<UsageStatsService>(),
      screenListener: sl<ScreenStateListener>(),
    ),
  );

  // Background Task Manager
  sl.registerLazySingleton(() => BackgroundTaskInitializer());

  // Initialize database
  await sl<DatabaseService>().init();

  print('✅ All dependencies registered');
}

/// Helper untuk reset semua dependencies (untuk testing/logout)
Future<void> resetDependencies() async {
  await sl.reset();
  await initDependencies();
}
