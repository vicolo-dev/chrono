import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/debug/logic/logger.dart';

// Calculates the DateTime when the provided `time` will next occur
DateTime getScheduleDateForTime(
  Time time, {
  DateTime? scheduleStartDate,
  int interval = 1,
}) {
  // logger.d('getDailyAlarmDate: $time, $scheduleStartDate, $interval');
  // if (scheduleStartDate != null && scheduleStartDate.isAfter(DateTime.now())) {
  //   return DateTime(scheduleStartDate.year, scheduleStartDate.month,
  //       scheduleStartDate.day, time.hour, time.minute, time.second);
  // }
  //
  // If a date has not been provided, assume it to be today
  DateTime scheduleDate = scheduleStartDate ?? DateTime.now();
  DateTime alarmTime;

  // if (time.toHours() > scheduleDate.toHours()) {
  //   // If the time is in the future, set the alarm for today
    alarmTime = DateTime(scheduleDate.year, scheduleDate.month,
        scheduleDate.day, time.hour, time.minute, time.second);
  // } else {
    while (alarmTime.isBefore(DateTime.now())) {
      alarmTime = alarmTime.add(Duration(days: interval));
    }

    // alarmTime = DateTime(scheduleDate.year, scheduleDate.month,
    //     scheduleDate.day, time.hour, time.minute, time.second);
  // }

  return alarmTime;
}

// Calculates the DateTime when the provided `time` will next occur on the
// provided `weekday`
DateTime getWeeklyScheduleDateForTIme(Time time, int weekday) {
  DateTime dateTime = getScheduleDateForTime(time);
  while (dateTime.weekday != weekday) {
    dateTime = dateTime.add(const Duration(days: 1));
  }
  return dateTime;
}
