import 'dart:core';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

import 'package:clock_app/settings/data/settings.dart';
import 'package:clock_app/theme/color_theme.dart';
import 'package:clock_app/theme/font.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/clock/data/timezone_database.dart';

setupDatabases() async {}

@pragma('vm:entry-point')
void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  Settings.initialize();
  await initializeDatabases();

  var alarms = await FlutterSystemRingtones.getAlarmSounds();

  // print(alarms);

  await AndroidAlarmManager.initialize();

  runApp(const App());

  for (int i = 35; i < 59; i++) {
    AndroidAlarmManager.oneShotAt(DateTime(2023, 1, 8, 19, i), i, printHello,
        allowWhileIdle: true,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true);
  }
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
