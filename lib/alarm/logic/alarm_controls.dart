import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/ringing_manager.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/notifications/types/fullscreen_notification_manager.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:clock_app/timer/utils/timer_id.dart';

const String stopAlarmPortName = "stopAlarmPort";
const String updatePortName = "updatePort";

@pragma('vm:entry-point')
void triggerScheduledNotification(int scheduleId, Json params) async {
  if (kDebugMode) {
    print("Alarm triggered: $scheduleId");
  }
  // print("Alarm Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");
  if (params == null) {
    if (kDebugMode) {
      print("Params was null when triggering alarm");
    }
    return;
  }

  if (params['type'] == null) {
    if (kDebugMode) {
      print("Params Type was null when triggering alarm");
    }
    return;
  }

  ScheduledNotificationType notificationType =
      ScheduledNotificationType.values.byName(params['type']);

  // This code listens for a message from the main isolate to stop the notification
  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.removePortNameMapping(stopAlarmPortName);
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, stopAlarmPortName);
  receivePort.listen((message) {
    stopScheduledNotification(message);
  });

  await initializeAppDataDirectory();
  await GetStorage.init();
  // await RingtoneManager.initialize();
  await RingtonePlayer.initialize();

  if (notificationType == ScheduledNotificationType.alarm) {
    triggerAlarm(scheduleId, params);
  } else if (notificationType == ScheduledNotificationType.timer) {
    triggerTimer(scheduleId, params);
  }
}

void stopScheduledNotification(List<dynamic> message) {
  int scheduleId = message[0];
  RingtonePlayer.stop();
  AlarmStopAction action = AlarmStopAction.values.byName(message[2]);

  ScheduledNotificationType notificationType =
      ScheduledNotificationType.values.byName(message[1]);

  if (notificationType == ScheduledNotificationType.alarm) {
    stopAlarm(scheduleId, action);
  } else if (notificationType == ScheduledNotificationType.timer) {
    stopTimer(scheduleId, action);
  }
}

void triggerAlarm(int scheduleId, Json params) async {
  if (params == null) {
    if (kDebugMode) {
      print("Params was null when triggering alarm");
    }
    return;
  }

  Alarm alarm = getAlarmByScheduleId(scheduleId);

  await updateAlarms();

  if (alarm.shouldSkipNextAlarm) {
    alarm.cancelSkip();
    return;
  }

  GetStorage().write("fullScreenNotificationRecentlyShown", true);

  // Pause any currently ringing timers. We will continue them after the alarm
  // is dismissed
  if (RingingManager.isTimerRinging) {
    RingtonePlayer.pause();
  }

  // Remove any existing alarm notifications
  if (RingingManager.isAlarmRinging) {
    await AlarmNotificationManager.removeNotification(
        ScheduledNotificationType.alarm);
  }

  RingtonePlayer.playAlarm(alarm);
  RingingManager.ringAlarm(scheduleId);

  String timeFormatString = await loadTextFile("time_format_string");
  String title = alarm.label.isEmpty ? "Alarm Ringing..." : alarm.label;

  AlarmNotificationManager.showFullScreenNotification(
    type: ScheduledNotificationType.alarm,
    scheduleIds: [scheduleId],
    title: title,
    body: TimeOfDayUtils.decode(params['timeOfDay'])
        .formatToString(timeFormatString),
    showSnoozeButton: alarm.canBeSnoozed,
    tasksRequired: alarm.tasks.isNotEmpty,
    snoozeActionLabel: "Snooze",
    dismissActionLabel: "Dismiss",
  );
}

void stopAlarm(int scheduleId, AlarmStopAction action) async {
  if (action == AlarmStopAction.snooze) {
    await updateAlarmById(scheduleId, (alarm) => alarm.snooze());
  } else if (action == AlarmStopAction.dismiss) {
    // If there was a timer ringing when the alarm was triggered, resume it now
    if (RingingManager.isTimerRinging) {
      RingtonePlayer.playTimer(getTimerById(RingingManager.activeTimerId));
    }
  }
  RingingManager.stopAlarm();
}

void triggerTimer(int scheduleId, Json params) async {
  await updateTimers();
  // Notify the front-end to update the timers

  GetStorage().write("fullScreenNotificationRecentlyShown", true);

  // Pause any currently ringing alarms. We will continue them after the timer
  // is dismissed
  if (RingingManager.isAlarmRinging) {
    RingtonePlayer.pause();
  }

  // Remove any existing timer notifications
  if (RingingManager.isTimerRinging) {
    await AlarmNotificationManager.removeNotification(
        ScheduledNotificationType.timer);
  }

  ClockTimer timer = getTimerById(scheduleId);

  RingtonePlayer.playTimer(timer);
  RingingManager.ringTimer(scheduleId);

  AlarmNotificationManager.showFullScreenNotification(
    type: ScheduledNotificationType.timer,
    scheduleIds: RingingManager.ringingTimerIds,
    snoozeActionLabel: '+${timer.addLength.floor()}:00',
    dismissActionLabel: 'Stop',
    title: "Time's Up!",
    body:
        "${RingingManager.ringingTimerIds.length} Timer${RingingManager.ringingTimerIds.length > 1 ? 's' : ''}",
  );
}

void stopTimer(int scheduleId, AlarmStopAction action) async {
  ClockTimer timer = getTimerById(scheduleId);
  if (action == AlarmStopAction.snooze) {
    scheduleSnoozeAlarm(
      scheduleId,
      Duration(minutes: timer.addLength.floor()),
      ScheduledNotificationType.timer,
    );
    updateTimerById(scheduleId, (timer) {
      timer.setTime(const TimeDuration(minutes: 1));
      timer.start();
    });
  } else if (action == AlarmStopAction.dismiss) {
    // If there was an alarm already ringing when the timer was triggered, we
    // need to resume it now
    if (RingingManager.isAlarmRinging) {
      RingtonePlayer.playAlarm(
          getAlarmByScheduleId(RingingManager.ringingAlarmId));
    }
  }
  RingingManager.stopAllTimers();
}
