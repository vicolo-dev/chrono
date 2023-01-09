import 'dart:core';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:clock_app/settings/logic/settings.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/clock/data/timezone_database.dart';

setupDatabases() async {}

@pragma('vm:entry-point')
void printHello() async {
  // var alarms = await FlutterSystemRingtones.getAlarmSounds();
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  // final player = AudioPlayer();
  // await player.setAudioSource(AudioSource.uri(Uri.parse(alarms[0].uri)));
  // player.play();
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  Settings.initialize();
  await initializeDatabases();

  // print(alarms);

  // await AndroidAlarmManager.initialize();

  runApp(const App());

  // for (int i = 26; i < 59; i++) {
  //   AndroidAlarmManager.oneShotAt(DateTime(2023, 1, 8, 22, i), i, printHello,
  //       allowWhileIdle: true,
  //       exact: true,
  //       wakeup: true,
  //       rescheduleOnReboot: true);
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
