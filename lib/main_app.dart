import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/themes/app_theme.dart';
import '../presentation/bloc/theme_bloc.dart';
import '../presentation/pages/onboarding_page.dart';
import '../presentation/pages/permission_gateway_page.dart';
import '../presentation/pages/main_shell.dart';

/// Main app widget dengan routing dan theme support.
///
/// Priority routing:
///   1. PermissionGate — harus pertama, tanpa app usage Luma tidak bisa bekerja
///   2. Onboarding — perkenalan untuk user baru
///   3. MainShell — home screen
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // null = masih loading dari prefs
  bool? _hasCompletedPermissionGate;
  bool? _hasCompletedOnboarding;

  @override
  void initState() {
    super.initState();
    _checkStatuses();
  }

  Future<void> _checkStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _hasCompletedPermissionGate =
            prefs.getBool('permission_gate_completed') ?? false;
        _hasCompletedOnboarding =
            prefs.getBool('onboarding_completed') ?? false;
      });
    }
  }

  Future<void> _onPermissionsGranted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permission_gate_completed', true);
    if (mounted) {
      setState(() => _hasCompletedPermissionGate = true);
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

    // Tentukan brightness berdasarkan tema aktif untuk menyelaraskan icon navigasi sistem
    final isDark = theme.themeMode == ThemeMode.dark ||
        (theme.themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final systemUiStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );

    // Loading state — layar kosong < 50ms
    if (_hasCompletedPermissionGate == null ||
        _hasCompletedOnboarding == null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiStyle,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: theme.themeMode,
          home: const Scaffold(
            backgroundColor: Color(0xFF081B1B),
            body: SizedBox.shrink(),
          ),
        ),
      );
    }

    // Routing priority: PermissionGate > Onboarding > Home
    Widget home;
    if (!_hasCompletedPermissionGate!) {
      home = PermissionGatewayPage(
        onPermissionsGranted: _onPermissionsGranted,
      );
    } else if (!_hasCompletedOnboarding!) {
      home = OnboardingPage(onComplete: _onOnboardingComplete);
    } else {
      home = const MainShell();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiStyle,
      child: MaterialApp(
        title: 'Luma',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: theme.themeMode,
        home: home,
      ),
    );
  }
}
