import 'package:clock/clock.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/debug/logic/logger.dart';

// Calculates the DateTime when the provided `time` will next occur
DateTime getScheduleDateForTime(
  Time time, {
  DateTime? scheduleStartDate,
  int interval = 1,
}) {
  DateTime now = clock.now();

  // If a date has not been provided, assume it to be today
  DateTime scheduleDate = scheduleStartDate ?? now;
  DateTime alarmTime = DateTime(scheduleDate.year, scheduleDate.month,
      scheduleDate.day, time.hour, time.minute, time.second);

  while (!alarmTime.isAfter(now)) {
    alarmTime = alarmTime.add(Duration(days: interval));
  }

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
