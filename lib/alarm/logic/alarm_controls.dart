import 'dart:developer';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/alarm/types/alarm_notification_manager.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

@pragma('vm:entry-point')
void triggerAlarm(int num, Map<String, dynamic> params) async {
  await initializeAppDataDirectory();
  await SettingsManager.initialize();
  await initializeAudioSession();
  await AlarmAudioPlayer.initialize();

  // NotificationController.setListeners();

  int ringtoneIndex = int.parse(params['ringtoneIndex']);
  AlarmAudioPlayer.play(ringtoneIndex);

  int scheduleId = int.parse(params['scheduleId']);

  List<Alarm> alarms = loadList("alarms");
  int alarmIndex =
      alarms.indexWhere((alarm) => alarm.activeSchedule.hasId(scheduleId));

  // print('scheduleId: $scheduleId');
  // print('alarms: ${encodeList(alarms)}');
  // print('alarmIndex: $alarmIndex');
  Alarm alarm = alarms[alarmIndex];

  if (alarm.isRepeating) {
    alarm.schedule();
  } else {
    alarm.disable();
  }

  alarms[alarmIndex] = alarm;
  saveList("alarms", alarms);

  print("Alarm triggered: $num");

  print("Alarm Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

  SettingsManager.preferences?.setBool("alarmRecentlyTriggered", true);

  AlarmNotificationManager.showNotification(params);
}

@pragma('vm:entry-point')
void stopAlarm() {
  print("Alarm Stop Isolate: ${Service.getIsolateID(Isolate.current)}");

  AlarmAudioPlayer.stop();
}
