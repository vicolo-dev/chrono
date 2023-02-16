import 'dart:developer';
import 'dart:isolate';

import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/alarm/types/alarm_notification_manager.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

int ringingAlarmId = -1;

@pragma('vm:entry-point')
void triggerAlarm(int scheduleId, Map<String, dynamic> params) async {
  await initializeAppDataDirectory();
  await SettingsManager.initialize();
  await RingtoneManager.initialize();

  var updateStatus = updateAlarms();

  print("Alarm triggered: $scheduleId");
  print("Alarm Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

  SettingsManager.preferences?.setBool("alarmRecentlyTriggered", true);

  print("ringingAlarmId: $ringingAlarmId");
  if (ringingAlarmId == -1) {
    await AlarmAudioPlayer.initialize();
    await initializeAudioSession();
    Alarm alarm = getAlarmByScheduleId(scheduleId);
    AlarmAudioPlayer.play(alarm.ringtoneUri, vibrate: alarm.vibrate);
  } else {
    await AlarmNotificationManager.removeNotification();
  }
  await updateStatus;
  AlarmNotificationManager.showNotification(
      scheduleId, TimeOfDayUtils.decode(params['timeOfDay']));

  ringingAlarmId = scheduleId;
}

@pragma('vm:entry-point')
void stopAlarm(int scheduleId, Map<String, dynamic> params) async {
  print("Alarm Stop Isolate: ${Service.getIsolateID(Isolate.current)}");
  AlarmAudioPlayer.stop();
  ringingAlarmId = -1;

  if (params['action'] == AlarmStopAction.snooze.toString()) {
    Alarm alarm = getAlarmByScheduleId(scheduleId);
    Duration snoozeDuration = Duration(minutes: alarm.snoozeLength.floor());
    scheduleSnoozeAlarm(scheduleId, snoozeDuration);
  } else {
    updateAlarms();
  }
}
