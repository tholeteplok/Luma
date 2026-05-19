// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/di.dart' as di;
import 'presentation/bloc/home_bloc.dart';
import 'presentation/bloc/theme_bloc.dart';
import 'presentation/bloc/settings_bloc.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies (database, encryption, etc.)
  await di.initDependencies();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => SettingsNotifier()),
      ],
      child: const MainApp(),
    ),
  );
}