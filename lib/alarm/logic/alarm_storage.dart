import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Alarm getAlarmByScheduleId(int id) {
  final List<Alarm> alarms = loadList('alarms');
  return alarms.firstWhere((alarm) => alarm.hasScheduleWithId(id));
}

void disableAlarmByScheduleId(int id) {
  final List<Alarm> alarms = loadList('alarms');
  final Alarm alarm = alarms.firstWhere((alarm) => alarm.hasScheduleWithId(id));
  alarm.disable();
  saveList('alarms', alarms);
}
