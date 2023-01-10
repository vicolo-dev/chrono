import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/settings/logic/settings.dart';

List<Alarm> loadAlarms() {
  final String? encodedAlarms = Settings.preferences?.getString('alarms');

  if (encodedAlarms == null) {
    return [];
  }

  return Alarm.decode(encodedAlarms);
}

void setAlarms(List<Alarm> alarms) {
  Settings.preferences?.setString('alarms', Alarm.encode(alarms));
}
