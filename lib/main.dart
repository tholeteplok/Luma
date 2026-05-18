// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luma/config/colors.dart';
import 'package:luma/config/design_tokens.dart';
import 'package:luma/config/typography.dart';
import 'package:luma/presentation/pages/onboarding_page.dart';
import 'package:luma/core/di/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies (database, encryption, etc.)
  await di.initDependencies();
  
  runApp(
    const ProviderScope(
      child: LumaApp(),
    ),
  );
}

class LumaApp extends ConsumerWidget {
  const LumaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Luma',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: LumaColors.bgBase,
        textTheme: TextTheme(
          displayLarge: LumaTypography.displayLarge,
          displayMedium: LumaTypography.displayMedium,
          headlineLarge: LumaTypography.headlineLarge,
          headlineMedium: LumaTypography.headlineMedium,
          headlineSmall: LumaTypography.headlineSmall,
          bodyLarge: LumaTypography.bodyLarge,
          bodyMedium: LumaTypography.bodyMedium,
          bodySmall: LumaTypography.bodySmall,
        ),
        colorScheme: ColorScheme.dark(
          background: LumaColors.bgBase,
          surface: LumaColors.bgSurface,
          primary: LumaColors.accentPrimary,
        ),
        useMaterial3: true,
      ),
      home: const OnboardingPage(),
    );
  }
}