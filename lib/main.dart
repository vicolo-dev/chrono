import 'dart:core';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:clock_app/settings/logic/settings.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/clock/data/timezone_database.dart';

setupDatabases() async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  Settings.initialize();
  await initializeDatabases();
  await AndroidAlarmManager.initialize();

  runApp(const App());

  // for (int i = 26; i < 59; i++) {

  // }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme,
      home: const AppScaffold(title: 'Clock'),
    );
  }
}
