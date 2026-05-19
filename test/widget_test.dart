// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:luma/main_app.dart';
import 'package:luma/presentation/bloc/home_bloc.dart';
import 'package:luma/presentation/bloc/theme_bloc.dart';
import 'package:luma/presentation/bloc/settings_bloc.dart';

void main() {
  testWidgets('Luma onboarding smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeNotifier()),
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(create: (_) => SettingsNotifier()),
        ],
        child: const MainApp(),
      ),
    );

    // Verify that onboarding page displays introductory content
    expect(find.textContaining('Luma'), findsWidgets);
  });
}
