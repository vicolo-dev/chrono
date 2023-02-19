import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:intl/intl.dart';

enum AlarmType {
  alarm,
  timer,
}

Future<void> scheduleAlarm(
  int scheduleId,
  DateTime startDate, {
  Duration repeatInterval = Duration.zero,
  AlarmType type = AlarmType.alarm,
}) async {
  await cancelAlarm(scheduleId);

  AndroidAlarmManager.oneShotAtTime(
    startDate,
    scheduleId,
    triggerAlarm,
    allowWhileIdle: true,
    alarmClock: true,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
    params: <String, String>{
      'scheduleId': scheduleId.toString(),
      'timeOfDay': startDate.toTimeOfDay().encode(),
      'type': type.toString(),
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

Future<void> scheduleStopAlarm(int scheduleId, AlarmStopAction alarmStopAction,
    {AlarmType type = AlarmType.alarm}) async {
  await AndroidAlarmManager.oneShotAfterDelay(
    const Duration(seconds: 0),
    scheduleId,
    stopAlarm,
    exact: true,
    useRTC: true,
    alarmClock: true,
    params: <String, String>{
      'action': alarmStopAction.toString(),
      'type': type.toString(),
    },
  );
}

Future<void> scheduleSnoozeAlarm(
    int scheduleId, Duration delay, AlarmType type) async {
  await scheduleAlarm(scheduleId, DateTime.now().add(delay), type: type);
}
