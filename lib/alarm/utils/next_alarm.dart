

import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Alarm? getNextAlarm () {
  List<Alarm> alarms = loadListSync('alarms');
  if (alarms.isEmpty) return null;
  alarms.sort((a, b) {
    if (a.currentScheduleDateTime == null) return 1;
    if (b.currentScheduleDateTime == null) return -1;
    return a.currentScheduleDateTime!.compareTo(b.currentScheduleDateTime!);
  });
  return alarms.first;
}
