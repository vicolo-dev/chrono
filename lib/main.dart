import 'dart:core';

import 'package:clock_app/data/preferences.dart';
import 'package:clock_app/theme/color_theme.dart';
import 'package:clock_app/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:clock_app/screens/app_scaffold.dart';
import 'package:clock_app/data/database.dart';

setupDatabases() async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  Preferences.initialize();
  await initializeDatabases();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 20,
            fontVariations: FontVariations.semiBold,
            color: ColorTheme.textColor,
          ),
          titleSmall: TextStyle(
            fontSize: 12,
            fontVariations: FontVariations.semiBold,
            color: ColorTheme.textColor,
          ),
          displayLarge: TextStyle(
            fontSize: 72,
            fontVariations: FontVariations.bold,
            color: ColorTheme.textColor,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontVariations: FontVariations.bold,
            color: ColorTheme.textColor,
          ),
          displaySmall: TextStyle(
            fontSize: 16,
            fontVariations: FontVariations.bold,
            color: ColorTheme.textColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontVariations: FontVariations.medium,
            color: ColorTheme.textColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 12,
            fontVariations: FontVariations.medium,
            color: ColorTheme.textColor,
          ),
          bodySmall: TextStyle(
            fontSize: 10,
            fontVariations: FontVariations.medium,
            color: ColorTheme.textColor,
          ),
        ),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.cyan).copyWith(
          background: Colors.grey[400],
        ),
      ),
      home: const AppScaffold(title: 'Clock'),
    );
  }
}
