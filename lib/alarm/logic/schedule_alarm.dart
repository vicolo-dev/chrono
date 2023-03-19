import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';

enum ScheduledNotificationType {
  alarm,
  timer,
}

Future<bool> scheduleAlarm(
  int scheduleId,
  DateTime startDate, {
  ScheduledNotificationType type = ScheduledNotificationType.alarm,
}) async {
  if (startDate.isBefore(DateTime.now())) {
    throw Exception('Attempted to schedule alarm in the past ($startDate)');
  }
  await cancelAlarm(scheduleId);

  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    return AndroidAlarmManager.oneShotAtTime(
      startDate,
      scheduleId,
      triggerScheduledNotification,
      allowWhileIdle: true,
      alarmClock: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: <String, String>{
        'scheduleId': scheduleId.toString(),
        'timeOfDay': startDate.toTimeOfDay().encode(),
        'type': type.name,
      },
    );
  } else {
    return true;
  }
}

Future<void> cancelAlarm(int scheduleId) async {
  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    await AndroidAlarmManager.cancel(scheduleId);
  }
}

enum AlarmStopAction {
  dismiss,
  snooze,
}

Future<void> scheduleSnoozeAlarm(
    int scheduleId, Duration delay, ScheduledNotificationType type) async {
  await scheduleAlarm(scheduleId, DateTime.now().add(delay), type: type);
}
