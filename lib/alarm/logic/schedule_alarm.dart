import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:intl/intl.dart';

void scheduleAlarm(int id, DateTime startDate, String ringtoneUri,
    {Duration repeatInterval = Duration.zero}) async {
  await cancelAlarm(id);
  print(
      "Alarm $id scheduled for ${DateFormat("yyyy MM dd hh mm").format(startDate)}");
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
      'ringtoneUri': ringtoneUri,
    },
  );
}

Future<void> cancelAlarm(int id) async {
  print("Alarm $id cancelled");
  await AndroidAlarmManager.cancel(id);
}
