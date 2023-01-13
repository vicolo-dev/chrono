import 'dart:core';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audio_session/audio_session.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/clock/logic/timezone_database.dart';
import 'package:clock_app/alarm/screens/alarm_notification_screen.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/alarm/data/alarm_notification_data.dart';
import 'package:clock_app/alarm/data/alarm_notification_route.dart';
import 'package:clock_app/alarm/logic/alarm_storage.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  SettingsManager.initialize();
  await initializeDatabases();
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration(
    androidAudioAttributes: AndroidAudioAttributes(
      flags: AndroidAudioFlags.audibilityEnforced,
      usage: AndroidAudioUsage.alarm,
    ),
  ));
  AwesomeNotifications().isNotificationAllowed().then((allowed) {
    if (!allowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          // NotificationPermission.Sound,
          NotificationPermission.Alert,
          NotificationPermission.FullScreenIntent,
        ],
      );
    }
  });
  await AndroidAlarmManager.initialize();
  await AlarmAudioPlayer.initialize();

  await AwesomeNotifications().initialize(null, [alarmNotificationChannel],
      channelGroups: [alarmNotificationChannelGroup], debug: kDebugMode);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    NotificationController.setListeners();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Clock',
      theme: theme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const NavScaffold());

          case alarmNotificationRoute:
            return MaterialPageRoute(
              builder: (context) {
                final ReceivedAction receivedAction =
                    settings.arguments as ReceivedAction;
                int scheduleId =
                    int.parse((receivedAction.payload?['scheduleId'])!);
                return AlarmNotificationScreen(
                    alarm: getAlarmByScheduleId(scheduleId));
              },
            );

          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
    );
  }
}
