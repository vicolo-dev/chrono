import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/types/schedule_id.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/time_of_day.dart';

Future<bool> scheduleAlarm(
  int scheduleId,
  DateTime startDate,
  String description, {
  ScheduledNotificationType type = ScheduledNotificationType.alarm,
}) async {
  if (startDate.isBefore(DateTime.now())) {
    throw Exception('Attempted to schedule alarm in the past ($startDate)');
  }

  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    await cancelAlarm(scheduleId, type);
    List<AlarmEvent> alarmEvents = await loadList<AlarmEvent>('alarm_events');
    alarmEvents.insert(
        0,
        AlarmEvent(
          // type: AlarmEventType.schedule,
          scheduleId: scheduleId,
          description: description,
          startDate: startDate,
          eventTime: DateTime.now(),
          notificationType: type,
          isActive: true,
        ));
    await saveList<AlarmEvent>('alarm_events', alarmEvents);

    String name = type == ScheduledNotificationType.alarm
        ? 'alarm_schedule_ids'
        : 'timer_schedule_ids';
    List<ScheduleId> scheduleIds = await loadList<ScheduleId>(name);
    scheduleIds.add(ScheduleId(id: scheduleId));
    await saveList<ScheduleId>(name, scheduleIds);

    return AndroidAlarmManager.oneShotAt(
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

Future<void> cancelAlarm(int scheduleId, ScheduledNotificationType type) async {
  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    List<AlarmEvent> alarmEvents = await loadList<AlarmEvent>('alarm_events');
    for (var event in alarmEvents) {
      if (event.scheduleId == scheduleId) {
        event.isActive = false;
      }
    }
    await saveList<AlarmEvent>('alarm_events', alarmEvents);

    String name = type == ScheduledNotificationType.alarm
        ? 'alarm_schedule_ids'
        : 'timer_schedule_ids';
    List<ScheduleId> scheduleIds = await loadList<ScheduleId>(name);
    scheduleIds.removeWhere((id) => id.id == scheduleId);
    await saveList<ScheduleId>(name, scheduleIds);

    await AndroidAlarmManager.cancel(scheduleId);
  }
}

enum AlarmStopAction {
  dismiss,
  snooze,
}

Future<void> scheduleSnoozeAlarm(int scheduleId, Duration delay,
    ScheduledNotificationType type, String description) async {
  await scheduleAlarm(scheduleId, DateTime.now().add(delay), description,
      type: type);
}
