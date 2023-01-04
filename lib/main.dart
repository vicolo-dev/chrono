import 'dart:core';

import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as timezone_db;

import 'package:clock_app/screens/clock_screen.dart';
import 'package:clock_app/utility/timezones_database.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        backgroundColor: Colors.grey[300],
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          headline2: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          bodyText1: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      home: const ClockScreen(title: 'Clock'),
    );
  }
}
