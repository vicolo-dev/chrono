import 'dart:core';

import 'package:alarm/alarm.dart';
import 'package:clock_app/data/settings.dart';
import 'package:clock_app/theme/color_theme.dart';
import 'package:clock_app/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:clock_app/screens/app_scaffold.dart';
import 'package:clock_app/data/database.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

setupDatabases() async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  Settings.initialize();
  await initializeDatabases();

  var alarms = await FlutterSystemRingtones.getAlarmSounds();

  print(alarms);

  Alarm.init();

  Alarm.set(
    alarmDateTime: DateTime(2023, 1, 8, 15, 10),
    assetAudio: alarms[0].uri,
    onRing: () => print("ringing"),
    notifTitle: 'Alarm notification',
    notifBody: 'Your alarm is ringing',
  );

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
