import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/themes/app_theme.dart';
import '../presentation/bloc/theme_bloc.dart';
import '../presentation/pages/onboarding_page.dart';
import '../presentation/pages/main_shell.dart';

/// Main app widget dengan routing dan theme support.
///
/// Tema reaktif terhadap [ThemeNotifier]: toggle di Settings akan langsung
/// memperbarui MaterialApp tanpa restart.
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
    final theme = context.watch<ThemeNotifier>();

    return MaterialApp(
      title: 'Luma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme.themeMode,
      home: _hasCompletedOnboarding
          ? const MainShell()
          : OnboardingPage(onComplete: _onOnboardingComplete),
    );
  }
}
