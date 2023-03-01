import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';

enum ScheduledNotificationType {
  alarm,
  timer,
}

Future<void> scheduleAlarm(
  int scheduleId,
  DateTime startDate, {
  Duration repeatInterval = Duration.zero,
  ScheduledNotificationType type = ScheduledNotificationType.alarm,
}) async {
  await cancelAlarm(scheduleId);

  AndroidAlarmManager.oneShotAtTime(
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
}

Future<void> cancelAlarm(int scheduleId) async {
  await AndroidAlarmManager.cancel(scheduleId);
}

enum AlarmStopAction {
  dismiss,
  snooze,
}

Future<void> scheduleSnoozeAlarm(
    int scheduleId, Duration delay, ScheduledNotificationType type) async {
  await scheduleAlarm(scheduleId, DateTime.now().add(delay), type: type);
}
