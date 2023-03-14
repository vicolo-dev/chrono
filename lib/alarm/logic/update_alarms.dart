import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/types/alarm.dart';
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

Future<void> updateAlarms() async {
  List<Alarm> alarms = await loadList("alarms");
  alarms.where((alarm) => alarm.isEnabled).forEach((alarm) {
    alarm.unSnooze();
    alarm.update();
  });
  await saveList("alarms", alarms);

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
