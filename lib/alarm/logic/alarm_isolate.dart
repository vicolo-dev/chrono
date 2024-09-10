import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/notifications/logic/alarm_notifications.dart';
import 'package:clock_app/system/logic/initialize_isolate.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter/foundation.dart';
import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/ringing_manager.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/alarm/utils/alarm_id.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:clock_app/timer/utils/timer_id.dart';

const String stopAlarmPortName = "stopAlarmPort";
const String updatePortName = "updatePort";
const String setAlarmVolumePortName = "setAlarmVolumePort";

@pragma('vm:entry-point')
void triggerScheduledNotification(int scheduleId, Json params) async {
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.f("Error in triggerScheduledNotification isolate: ${details.exception.toString()}");
  };

  logger.i(
      "Alarm isolate triggered $scheduleId, isolate: ${Service.getIsolateId(Isolate.current)}");
  // print("Alarm Trigger Isolate: ${Service.getIsolateID(Isolate.current)}");
  if (params == null) {
    logger.e("Params was null when triggering alarm");
    return;
  }

  if (params['type'] == null) {
    logger.e("Params Type was null when triggering alarm");
    return;
  }

  await initializeIsolate();

  ScheduledNotificationType notificationType =
      ScheduledNotificationType.values.byName(params['type']);

  // This code listens for a message from the main isolate to stop the notification
  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.removePortNameMapping(stopAlarmPortName);
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, stopAlarmPortName);
  receivePort.listen((message) {
    logger.d("Received message: $message");
    stopScheduledNotification(message);
  });

  // Isolate.current.addOnExitListener(receivePort.sendPort);

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

  logger.i(
      "Alarm stop triggered $scheduleId, isolate: ${Service.getIsolateId(Isolate.current)}");
}

void triggerAlarm(int scheduleId, Json params) async {
  logger.i("Alarm triggered $scheduleId");
  if (params == null) {
    logger.e("Params was null when triggering alarm");
    return;
  }

  Alarm? alarm = getAlarmById(scheduleId);
  DateTime now = DateTime.now();

  // Note: this won't effect the variable `alarm` as we have already retrieved that
  await updateAlarms("triggerAlarm(): Updating all alarms on trigger");

  // Skip the alarm in the following cases:
  if (alarm == null) {
    logger.i("Skipping alarm $scheduleId because it doesn't exist");
    return;
  }
  if (alarm.isEnabled == false) {
    logger.i("Skipping alarm $scheduleId because it is disabled");
    return;
  }
  if (alarm.shouldSkipNextAlarm) {
    logger.i(
        "Skipping alarm $scheduleId because it is set to skip the next alarm");
    return;
  }
  if (alarm.currentScheduleDateTime == null) {
    logger.i("Skipping alarm $scheduleId because it has no scheduled date");
    return;
  }
  if (now.millisecondsSinceEpoch <
      alarm.currentScheduleDateTime!.millisecondsSinceEpoch) {
    logger.i(
        "Skipping alarm $scheduleId because it is set to ring in the future. Current time: $now, Scheduled time: ${alarm.currentScheduleDateTime}");
    return;
  }
  if (now.millisecondsSinceEpoch >
      alarm.currentScheduleDateTime!.millisecondsSinceEpoch + 1000 * 60 * 60) {
    logger.i(
        "Skipping alarm $scheduleId because it was set to ring more than an hour ago. Current time: $now, Scheduled time: ${alarm.currentScheduleDateTime}");
    return;
  }

  // Pause any currently ringing timers. We will continue them after the alarm
  // is dismissed
  if (RingingManager.isTimerRinging) {
    RingtonePlayer.pause();
  }

  // Remove any existing alarm notifications
  if (RingingManager.isAlarmRinging) {
    await removeAlarmNotification(ScheduledNotificationType.alarm);
  }

  RingtonePlayer.playAlarm(alarm);
  RingingManager.ringAlarm(scheduleId);

  /*
  Ports to set the volume of the alarm. As the RingtonePlayer only.
  As the RingtonePlayer only exists in this isolate, when other isolate
  (e.g the main UI isolate) want to change the alarm volumen, they have to send
  message over a port.
  In this case, this is used by the AlarmNotificationScreen to lower the volume
  of alarm while solving tasks.
  */
  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.removePortNameMapping(setAlarmVolumePortName);
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, setAlarmVolumePortName);
  receivePort.listen((message) {
    setVolume(message[0]);
  });

  String timeFormatString = await loadTextFile("time_format_string");
  String title = alarm.label.isEmpty ? "Alarm Ringing..." : alarm.label;

  showAlarmNotification(
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

void setVolume(double volume) {
  RingtonePlayer.setVolume(volume / 100);
}

void stopAlarm(int scheduleId, AlarmStopAction action) async {
  logger.i("Stopping alarm $scheduleId with action: ${action.name}");
  if (action == AlarmStopAction.snooze) {
    await updateAlarmById(scheduleId, (alarm) async => await alarm.snooze());
    // await createSnoozeNotification(scheduleId);
  } else if (action == AlarmStopAction.dismiss) {
    // If there was a timer ringing when the alarm was triggered, resume it now
    if (RingingManager.isTimerRinging) {
      ClockTimer? timer = getTimerById(RingingManager.activeTimerId);
      if (timer != null) {
        RingtonePlayer.playTimer(timer);
      }
    }
    await updateAlarmById(scheduleId, (alarm) async => alarm.handleDismiss());
  }
  RingingManager.stopAlarm();
}

void triggerTimer(int scheduleId, Json params) async {
  logger.i("Timer triggered $scheduleId");
  ClockTimer? timer = getTimerById(scheduleId);

  if (timer == null || !timer.isRunning) {
    await updateTimers("triggerTimer(): Updating all timers on trigger");
    return;
  }

  await updateTimers("triggerTimer(): Updating all timers on trigger");

  // Pause any currently ringing alarms. We will continue them after the timer
  // is dismissed
  if (RingingManager.isAlarmRinging) {
    // RingtonePlayer.pause();
  }

  // Remove any existing timer notifications
  if (RingingManager.isTimerRinging) {
    await removeAlarmNotification(ScheduledNotificationType.timer);
  }

  RingtonePlayer.playTimer(timer);
  RingingManager.ringTimer(scheduleId);

  showAlarmNotification(
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
  logger.i("Stopping timer $scheduleId with action: ${action.name}");
  ClockTimer? timer = getTimerById(scheduleId);
  if (timer == null) return;
  if (action == AlarmStopAction.snooze) {
    updateTimerById(scheduleId, (timer) async {
      await timer.snooze();
    });
  } else if (action == AlarmStopAction.dismiss) {
    // If there was an alarm already ringing when the timer was triggered, we
    // need to resume it now
    if (RingingManager.isAlarmRinging) {
      Alarm? alarm = getAlarmById(RingingManager.ringingAlarmId);
      if (alarm != null) {
        RingtonePlayer.playAlarm(alarm);
      }
    }
  }
  RingingManager.stopAllTimers();
}
