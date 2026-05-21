// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'core/di/di.dart' as di;
import 'presentation/bloc/home_bloc.dart';
import 'presentation/bloc/theme_bloc.dart';
import 'presentation/bloc/settings_bloc.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Aktifkan penggambaran layar penuh (Edge-to-Edge) di Android/iOS
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize locale data untuk DateFormat (intl package).
  // Tanpa ini, DateFormat('EEEE, d MMMM', 'id_ID') fallback ke English.
  await initializeDateFormatting('id_ID');
  await initializeDateFormatting('en_US');

  // Initialize dependencies (database, encryption, etc.)
  await di.initDependencies();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(
          create: (_) => SettingsNotifier()..loadSettings(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}