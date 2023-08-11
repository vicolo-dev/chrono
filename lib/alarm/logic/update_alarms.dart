import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/common/utils/list_storage.dart';

import 'alarm_controls.dart';

Future<void> updateAlarm(int scheduleId) async {
  List<Alarm> alarms = await loadList("alarms");
  int alarmIndex =
      alarms.indexWhere((alarm) => alarm.hasScheduleWithId(scheduleId));
  Alarm alarm = alarms[alarmIndex];

  alarm.update();

  alarms[alarmIndex] = alarm;
  await saveList("alarms", alarms);
}

// Update the state of all the alarms and save them to the disk
// This is called both when an alarm triggers, as well as when the device boots
// up, so we can check for alarms that rung when the device was off
Future<void> updateAlarms() async {
  List<Alarm> alarms = await loadList("alarms");

  alarms.where((alarm) => alarm.isEnabled).forEach((alarm) {
    alarm.update();
  });

  await saveList("alarms", alarms);

  // Notify other isolates that are listening for alarm updates
  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateAlarms");
}

Future<void> updateAlarmById(
    int scheduleId, void Function(Alarm) callback) async {
  List<Alarm> alarms = await loadList("alarms");
  int alarmIndex =
      alarms.indexWhere((alarm) => alarm.hasScheduleWithId(scheduleId));
  Alarm alarm = alarms[alarmIndex];
  callback(alarm);
  alarms[alarmIndex] = alarm;
  await saveList("alarms", alarms);
  SendPort? sendPort = IsolateNameServer.lookupPortByName(updatePortName);
  sendPort?.send("updateAlarms");
}
