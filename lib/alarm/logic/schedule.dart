import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';

void scheduleAlarm(int id, DateTime startDate, int ringtoneIndex,
    {Duration repeatInterval = Duration.zero}) {
  cancelAlarm(id);
  AndroidAlarmManager.oneShotAt(
    startDate,
    id,
    ringAlarm,
    allowWhileIdle: true,
    alarmClock: true,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
    params: <String, String>{
      'scheduleId': id.toString(),
      'timeOfDay': startDate.toTimeOfDay().encode(),
      'ringtoneIndex': ringtoneIndex.toString(),
      'repeatInterval': repeatInterval.inMilliseconds.toString(),
    },
  );
}

void cancelAlarm(int id) {
  AndroidAlarmManager.cancel(id);
}
