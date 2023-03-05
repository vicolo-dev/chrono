import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Future<void> updateAlarm(int scheduleId) async {
  List<Alarm> alarms = await loadList("alarms");
  int alarmIndex =
      alarms.indexWhere((alarm) => alarm.hasScheduleWithId(scheduleId));
  Alarm alarm = alarms[alarmIndex];

  if (alarm.isRepeating) {
    alarm.schedule();
  } else {
    print(alarm.nextScheduleDateTime);
    if (alarm.nextScheduleDateTime.isBefore(DateTime.now())) {
      alarm.disable();
    }
  }

  alarms[alarmIndex] = alarm;
  await saveList("alarms", alarms);
}

Future<void> updateAlarms() async {
  List<Alarm> alarms = await loadList("alarms");

  alarms.where((alarm) => alarm.enabled).forEach((alarm) {
    if (alarm.isRepeating) {
      alarm.schedule();
    } else {
      print(alarm.nextScheduleDateTime);
      if (alarm.nextScheduleDateTime.isBefore(DateTime.now())) {
        alarm.disable();
      }
    }
  });

  await saveList("alarms", alarms);
}
