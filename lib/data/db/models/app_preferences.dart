import 'package:isar/isar.dart';

part 'app_preferences.g.dart';

@collection
class AppPreferences {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String key = 'app_settings';

  // User settings
  bool notificationsEnabled = true;
  bool dailySummaryEnabled = true;
  bool weeklyReportEnabled = true;

  // Privacy
  bool dataCollectionEnabled = true;
  bool analyticsEnabled = false;

  // UI preferences
  String languageCode = 'id'; // 'id' atau 'en'
  bool useDarkMode = true;

  // Onboarding
  bool onboardingCompleted = false;
  int? onboardingLastVersion;

  // Backup
  bool backupEnabled = false;
  DateTime? lastBackupDate;

  @Index()
  late DateTime lastUpdated;
}
