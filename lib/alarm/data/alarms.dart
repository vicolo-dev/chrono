import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

List<Alarm> loadAlarms() {
  final String? encodedAlarms =
      SettingsManager.preferences?.getString('alarms');

  if (encodedAlarms == null) {
    return [];
  }

  return Alarm.decode(encodedAlarms);
}

void setAlarms(List<Alarm> alarms) {
  SettingsManager.preferences?.setString('alarms', Alarm.encode(alarms));
}
