import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

void scheduleAlarm(int id, DateTime startDate, int ringtoneIndex,
    {Duration repeatInterval = Duration.zero}) {
  cancelAlarm(id);
  AndroidAlarmManager.oneShotAtTime(
    startDate,
    id,
    triggerAlarm,
    allowWhileIdle: true,
    alarmClock: true,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
    params: <String, String>{
      'scheduleId': id.toString(),
      'timeOfDay': startDate.toTimeOfDay().encode(),
      'ringtoneIndex': ringtoneIndex.toString(),
      'alarms': SettingsManager.preferences?.getString("alarms") ?? "",
    },
  );
}

void cancelAlarm(int id) {
  AndroidAlarmManager.cancel(id);
}
