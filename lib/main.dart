import 'dart:core';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/notifications/logic/foreground_task.dart';
import 'package:clock_app/notifications/logic/notifications.dart';
import 'package:clock_app/settings/logic/initialize_settings.dart';
import 'package:clock_app/system/data/app_info.dart';
import 'package:clock_app/system/data/device_info.dart';
import 'package:clock_app/system/logic/background_service.dart';
import 'package:clock_app/system/logic/handle_boot.dart';
import 'package:clock_app/system/logic/initialize_isolate_ports.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot_receiver/flutter_boot_receiver.dart';
import 'package:flutter_show_when_locked/flutter_show_when_locked.dart';
import 'package:timezone/data/latest_all.dart';

void main() async {
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   logger.e(details.exception.toString(), stackTrace: details.stack,);
  // };

  WidgetsFlutterBinding.ensureInitialized();

  initializeTimeZones();
  final initializeData = [
    initializePackageInfo(),
    initializeAndroidInfo(),
    initializeAppDataDirectory(),
    initializeNotifications(),
    AndroidAlarmManager.initialize(),
    BootReceiver.initialize(handleBoot),
    RingtonePlayer.initialize(),
    initializeAudioSession(),
    FlutterShowWhenLocked().hide(),
  ];
  await Future.wait(initializeData);

  // These rely on initializeAppDataDirectory
  await initializeStorage();
  await initializeSettings();

  updateAlarms("Update Alarms on Start");
  updateTimers("Update Timers on Start");
  AppVisibility.initialize();
  initForegroundTask();
  initBackgroundService();
  initializeIsolatePorts();

  runApp(const App());

  registerHeadlessBackgroundService();
}
