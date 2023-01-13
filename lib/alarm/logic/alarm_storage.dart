import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

// List<Alarm> loadAlarms() {
//   final String? encodedAlarms =
//       SettingsManager.preferences?.getString('alarms');

//   if (encodedAlarms == null) {
//     return [];
//   }

//   return decodeList(encodedAlarms);
// }

// void setAlarms(List<Alarm> alarms) {
//   SettingsManager.preferences?.setString('alarms', encodeList(alarms));
// }

Alarm getAlarmByScheduleId(int id) {
  final List<Alarm> alarms = loadList('alarms');
  return alarms.firstWhere((alarm) => alarm.hasOneTimeScheduleWithId(id));
}

void disableAlarmByScheduleId(int id) {
  final List<Alarm> alarms = loadList('alarms');
  final Alarm alarm =
      alarms.firstWhere((alarm) => alarm.hasOneTimeScheduleWithId(id));
  alarm.disable();
  saveList('alarms', alarms);
}
