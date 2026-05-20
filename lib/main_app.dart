import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/themes/app_theme.dart';
import '../presentation/bloc/theme_bloc.dart';
import '../presentation/pages/onboarding_page.dart';
import '../presentation/pages/main_shell.dart';

/// Main app widget dengan routing dan theme support.
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // null = masih loading dari prefs
  bool? _hasCompletedOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _hasCompletedOnboarding =
            prefs.getBool('onboarding_completed') ?? false;
      });
    }
  }

  Future<void> _onOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      setState(() => _hasCompletedOnboarding = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();

    // Tampilkan layar kosong saat masih membaca prefs
    // (biasanya < 50ms, tidak terlihat user)
    if (_hasCompletedOnboarding == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: theme.themeMode,
        home: const Scaffold(
          backgroundColor: Color(0xFF0C0C14),
          body: SizedBox.shrink(),
        ),
      );
    }

    return MaterialApp(
      title: 'Luma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme.themeMode,
      home: _hasCompletedOnboarding!
          ? const MainShell()
          : OnboardingPage(onComplete: _onOnboardingComplete),
    );
  }
}
