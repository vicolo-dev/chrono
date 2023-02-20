import 'dart:developer';
import 'dart:isolate';

import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/utils/timer_id.dart';

int ringingAlarmId = -1;
bool isAlarmUpdating = false;
bool isTimerUpdating = false;

@pragma('vm:entry-point')
void triggerAlarm(int scheduleId, Map<String, dynamic> params) async {
  print("ringingAlarmId: $ringingAlarmId");
  print("Alarm triggered: $scheduleId");
  print("Alarm Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");

  AlarmType alarmType = AlarmType.values.firstWhere(
    (element) => element.toString() == params['type'],
  );

  await initializeAppDataDirectory();
  await SettingsManager.initialize();
  await RingtoneManager.initialize();

  if (alarmType == AlarmType.alarm) {
    if (!isAlarmUpdating) {
      isAlarmUpdating = true;
      await updateAlarms();
      isAlarmUpdating = false;
    }
  } else if (alarmType == AlarmType.timer) {
    if (!isTimerUpdating) {
      isTimerUpdating = true;
      await updateTimers();
      isTimerUpdating = false;
    }
  }

  SettingsManager.preferences
      ?.setBool("fullScreenNotificationRecentlyShown", true);

  if (ringingAlarmId == -1) {
    await RingtonePlayer.initialize();
    await initializeAudioSession();

    String ringtoneUri = '';
    bool vibrate = false;
    if (alarmType == AlarmType.alarm) {
      Alarm alarm = getAlarmByScheduleId(scheduleId);
      ringtoneUri = alarm.ringtoneUri;
      vibrate = alarm.vibrate;
    } else if (alarmType == AlarmType.timer) {
      ClockTimer timer = getTimerById(scheduleId);
      ringtoneUri = RingtoneManager.ringtones[0].uri;
      vibrate = true;
    }
    RingtonePlayer.play(ringtoneUri, vibrate: vibrate);
  } else {
    await AlarmNotificationManager.removeNotification(alarmType);
  }

  AlarmNotificationManager.showFullScreenNotification(
    alarmType,
    scheduleId,
    TimeOfDayUtils.decode(params['timeOfDay']).formatToString('h:mm a'),
  );

  ringingAlarmId = scheduleId;
}

@pragma('vm:entry-point')
void stopAlarm(int scheduleId, Map<String, dynamic> params) async {
  print("Alarm Stop Isolate: ${Service.getIsolateID(Isolate.current)}");
  RingtonePlayer.stop();

  AlarmType type = AlarmType.values.firstWhere(
    (element) => element.toString() == params['type'],
  );

  if (params['action'] == AlarmStopAction.snooze.toString()) {
    Duration snoozeDuration = const Duration(minutes: 1);
    if (type == AlarmType.alarm) {
      Alarm alarm = getAlarmByScheduleId(scheduleId);
      snoozeDuration = Duration(minutes: alarm.snoozeLength.floor());
    }

    scheduleSnoozeAlarm(scheduleId, snoozeDuration, type);
  } else {
    if (type == AlarmType.alarm) {
      updateAlarms();
    } else if (type == AlarmType.timer) {
      updateTimers();
    }
  }
  ringingAlarmId = -1;
}
