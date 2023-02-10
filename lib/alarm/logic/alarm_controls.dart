import 'dart:developer';
import 'dart:isolate';

import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/alarm/types/alarm_notification_manager.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

int ringingAlarmId = -1;

void handleAlarmScheduleOnTrigger(int scheduleId) {
  List<Alarm> alarms = loadList("alarms");
  int alarmIndex =
      alarms.indexWhere((alarm) => alarm.activeSchedule.hasId(scheduleId));

  Alarm alarm = alarms[alarmIndex];

  if (alarm.isRepeating) {
    alarm.schedule();
  } else {
    alarm.disable();
  }

  alarms[alarmIndex] = alarm;
  saveList("alarms", alarms);
}

@pragma('vm:entry-point')
void triggerAlarm(int scheduleId, Map<String, dynamic> params) async {
  await initializeAppDataDirectory();
  await SettingsManager.initialize();
  await RingtoneManager.initialize();

  handleAlarmScheduleOnTrigger(scheduleId);

  print("Alarm triggered: $scheduleId");
  print("Alarm Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

  SettingsManager.preferences?.setBool("alarmRecentlyTriggered", true);

  print("ringingAlarmId: $ringingAlarmId");
  if (ringingAlarmId == -1) {
    await AlarmAudioPlayer.initialize();
    await initializeAudioSession();
    AlarmAudioPlayer.play(params['ringtoneUri']);
  } else {
    await AlarmNotificationManager.dismissAlarm(ringingAlarmId, replace: true);
  }
  AlarmNotificationManager.showNotification(params);

  ringingAlarmId = scheduleId;
}

@pragma('vm:entry-point')
void stopAlarm(int scheduleId) async {
  print("Alarm Stop Isolate: ${Service.getIsolateID(Isolate.current)}");
  AlarmAudioPlayer.stop();
  ringingAlarmId = -1;

  handleAlarmScheduleOnTrigger(scheduleId);
}
