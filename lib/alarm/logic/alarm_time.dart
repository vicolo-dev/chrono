import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/utils/date_time.dart';

// Calculates the DateTime when the provided `time` will next occur
DateTime getDailyAlarmDate(
  Time time, {
  DateTime? scheduledDate,
}) {
  if (scheduledDate != null && scheduledDate.isAfter(DateTime.now())) {
    return DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day,
        time.hour, time.minute, time.second);
  }

  // If a date has not been provided, assume it to be today
  scheduledDate = DateTime.now();
  DateTime alarmTime;

  if (time.toHours() > scheduledDate.toHours()) {
    // If the time is in the future, set the alarm for today
    alarmTime = DateTime(scheduledDate.year, scheduledDate.month,
        scheduledDate.day, time.hour, time.minute, time.second);
  } else {
    // If the time has already passed, set the alarm for tomorrow
    DateTime nextDateTime = scheduledDate.add(const Duration(days: 1));
    alarmTime = DateTime(nextDateTime.year, nextDateTime.month,
        nextDateTime.day, time.hour, time.minute, time.second);
  }

  return alarmTime;
}

// Calculates the DateTime when the provided `time` will next occur on the
// provided `weekday`
DateTime getWeeklyAlarmDate(Time time, int weekday) {
  DateTime dateTime = getDailyAlarmDate(time);
  while (dateTime.weekday != weekday) {
    dateTime = dateTime.add(const Duration(days: 1));
  }
  return dateTime;
}
