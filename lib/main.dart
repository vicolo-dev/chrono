import 'dart:core';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_isolate.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/notifications/logic/foreground_task.dart';
import 'package:clock_app/notifications/logic/notifications.dart';
import 'package:clock_app/settings/logic/initialize_settings.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:clock_app/system/data/app_info.dart';
import 'package:clock_app/system/data/device_info.dart';
import 'package:clock_app/system/logic/handle_boot.dart';
import 'package:clock_app/system/logic/quick_actions.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot_receiver/flutter_boot_receiver.dart';
import 'package:flutter_show_when_locked/flutter_show_when_locked.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:timezone/data/latest_all.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.f(details.exception.toString());
  };

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

  await updateAlarms("Update Alarms on Start");
  await updateTimers("Update Timers on Start");
  AppVisibility.initialize();
  initForegroundTask();

  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.removePortNameMapping(updatePortName);
  IsolateNameServer.registerPortWithName(receivePort.sendPort, updatePortName);
  printIsolateInfo();
  receivePort.listen((message) {
    if (message == "updateAlarms") {
      ListenerManager.notifyListeners("alarms");
    } else if (message == "updateTimers") {
      ListenerManager.notifyListeners("timers");
    } else if (message == "updateStopwatches") {
      ListenerManager.notifyListeners("stopwatch");
    }
  });

  runApp(const App());
}
