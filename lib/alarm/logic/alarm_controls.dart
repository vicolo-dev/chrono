import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/alarm/types/alarm_notification_manager.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

int ringingAlarmId = -1;

@pragma('vm:entry-point')
void triggerAlarm(int scheduleId, Map<String, dynamic> params) async {
  await initializeAppDataDirectory();
  await SettingsManager.initialize();

  // String appDataDirectory = getAppDataDirectoryPathSync();
  // String path = '$appDataDirectory/ringing-alarm.txt';
  // File file = File(path);
  // String encodedId = file.readAsStringSync();
  // if (encodedId.isNotEmpty) {
  //   try {
  //     int id = int.parse(encodedId);
  //     print("Canceling alarm: $id");
  //     AlarmNotificationManager.dismissAlarm(id);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  // file.writeAsStringSync("$num", mode: FileMode.writeOnly);

  // NotificationController.setListeners();

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

  print("Alarm triggered: $scheduleId");
  print("Alarm Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

  SettingsManager.preferences?.setBool("alarmRecentlyTriggered", true);

  print("ringingAlarmId: $ringingAlarmId");
  if (ringingAlarmId == -1) {
    await AlarmAudioPlayer.initialize();
    await initializeAudioSession();
    int ringtoneIndex = int.parse(params['ringtoneIndex']);
    AlarmAudioPlayer.play(ringtoneIndex);
  } else {
    await AlarmNotificationManager.dismissAlarm(ringingAlarmId, replace: true);
  }
  AlarmNotificationManager.showNotification(params);

  ringingAlarmId = scheduleId;
}

@pragma('vm:entry-point')
void stopAlarm() async {
  print("Alarm Stop Isolate: ${Service.getIsolateID(Isolate.current)}");
  AlarmAudioPlayer.stop();
  ringingAlarmId = -1;
}
