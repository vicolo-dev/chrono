import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/types/schedule_id.dart';
import 'package:clock_app/common/utils/list_storage.dart';

import 'alarm_controls.dart';

Future<void> cancelAllAlarms() async {
  List<ScheduleId> scheduleIds =
      await loadList<ScheduleId>('alarm_schedule_ids');
  for (var scheduleId in scheduleIds) {
    await cancelAlarm(scheduleId.id, ScheduledNotificationType.alarm);
  }
  scheduleIds.clear();
  await saveList('alarm_schedule_ids', scheduleIds);
}

Future<void> updateAlarm(int scheduleId, String description) async {
  List<Alarm> alarms = await loadList("alarms");
  int alarmIndex =
      alarms.indexWhere((alarm) => alarm.hasScheduleWithId(scheduleId));
  Alarm alarm = alarms[alarmIndex];

  await alarm.update(description);

  alarms[alarmIndex] = alarm;
  await saveList("alarms", alarms);
}

// Update the state of all the alarms and save them to the disk
// This is called both when an alarm triggers, as well as when the device boots
// up, so we can check for alarms that rung when the device was off
Future<void> updateAlarms(String description) async {
  await cancelAllAlarms();

  List<Alarm> alarms = await loadList("alarms");

  for (Alarm alarm in alarms) {
    await alarm.update(description);
  }

  await saveList("alarms", alarms);

  // Notify other isolates that are listening for alarm updates
  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateAlarms");
}

Future<void> updateAlarmById(
    int scheduleId, Future<void> Function(Alarm) callback) async {
  List<Alarm> alarms = await loadList("alarms");
  int alarmIndex =
      alarms.indexWhere((alarm) => alarm.hasScheduleWithId(scheduleId));
  if (alarmIndex == -1) {
    return;
  }
  Alarm alarm = alarms[alarmIndex];
  await callback(alarm);
  alarms[alarmIndex] = alarm;
  await saveList("alarms", alarms);

  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateAlarms");
}
