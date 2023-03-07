import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/list_storage.dart';

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
  alarms.where((alarm) => alarm.isEnabled).forEach((alarm) => alarm.update());
  await saveList("alarms", alarms);
}
