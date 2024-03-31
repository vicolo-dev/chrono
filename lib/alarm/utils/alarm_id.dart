import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/list_storage.dart';

Alarm? getAlarmByScheduleId(int id) {
  try {
    final List<Alarm> alarms = loadListSync('alarms');
    return alarms.firstWhere((alarm) => alarm.hasScheduleWithId(id));
  } catch (e) {
    return null;
  }
}
