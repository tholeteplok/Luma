import 'package:flutter/material.dart';
import '../core/themes/app_theme.dart';
import '../presentation/pages/onboarding_page.dart';
import '../presentation/pages/home_page.dart';

/// Main app widget dengan routing dan theme support
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // TODO: Check from SharedPreferences or AppPreferences
    // For now, default to false to show onboarding
    setState(() {
      _hasCompletedOnboarding = false;
    });
  }

  void _onOnboardingComplete() {
    setState(() {
      _hasCompletedOnboarding = true;
    });
    // TODO: Save to preferences
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default ke dark mode
      home: _hasCompletedOnboarding
          ? const HomePage()
          : OnboardingPage(onComplete: _onOnboardingComplete),
    );
  }
}
