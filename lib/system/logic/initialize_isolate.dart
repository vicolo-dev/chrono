import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/notifications/logic/notifications.dart';
import 'package:clock_app/settings/logic/initialize_settings.dart';
import 'package:clock_app/system/data/device_info.dart';
import 'package:flutter/widgets.dart';

Future<void> initializeIsolate() async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  await initializeAndroidInfo();
  await initializeAppDataDirectory();
  await initializeStorage(false);
  await initializeSettings();
  await initializeNotifications();
  await initializeAudioSession();
  await AndroidAlarmManager.initialize();
  await RingtonePlayer.initialize();
}
