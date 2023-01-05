import 'dart:core';

import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:clock_app/screens/clock_screen.dart';
import 'package:clock_app/data/timezones_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  await initializeDatabase();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          displayMedium: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
          displaySmall: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black),
          bodyLarge: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan)
            .copyWith(background: Colors.grey[300]),
      ),
      home: const ClockScreen(title: 'Clock'),
    );
  }
}
