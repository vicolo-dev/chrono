import 'dart:core';

import 'package:clock_app/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:clock_app/screens/clock_screen.dart';
import 'package:clock_app/data/database.dart';

setupDatabases() async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  await initializeDatabases();
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.clear();
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
              color: Colors.black),
          titleSmall: TextStyle(
              fontSize: 12,
              fontVariations: FontVariations.semiBold,
              color: Colors.black),
          displayLarge: TextStyle(
              fontSize: 72,
              fontVariations: FontVariations.bold,
              color: Colors.black),
          displayMedium: TextStyle(
              fontSize: 28,
              fontVariations: FontVariations.bold,
              color: Colors.black),
          displaySmall: TextStyle(
              fontSize: 16,
              fontVariations: FontVariations.bold,
              color: Colors.black),
          bodyLarge: TextStyle(
              fontSize: 16,
              fontVariations: FontVariations.medium,
              color: Colors.black),
          bodyMedium: TextStyle(
              fontSize: 12,
              fontVariations: FontVariations.medium,
              color: Colors.black),
          bodySmall: TextStyle(
              fontSize: 10,
              fontVariations: FontVariations.medium,
              color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan)
            .copyWith(background: Colors.grey[300]),
      ),
      home: const ClockScreen(title: 'Clock'),
    );
  }
}
