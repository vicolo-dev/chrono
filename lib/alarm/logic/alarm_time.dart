import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/utils/date_time.dart';

// Calculates the DateTime when the provided `time` will next occur
DateTime getDailyAlarmDate(
  Time time, {
  DateTime? scheduleStartDate,
  int interval = 1,
}) {
  if (scheduleStartDate != null && scheduleStartDate.isAfter(DateTime.now())) {
    return DateTime(scheduleStartDate.year, scheduleStartDate.month,
        scheduleStartDate.day, time.hour, time.minute, time.second);
  }

  // If a date has not been provided, assume it to be today
  DateTime scheduleDate = DateTime.now();
  DateTime alarmTime;

  if (time.toHours() > scheduleDate.toHours()) {
    // If the time is in the future, set the alarm for today
    alarmTime = DateTime(scheduleDate.year, scheduleDate.month,
        scheduleDate.day, time.hour, time.minute, time.second);
  } else {
    // If the time has already passed, set the alarm for next occurence
    if (scheduleStartDate != null) {
      scheduleDate = scheduleStartDate;
    }

    while (scheduleDate.isBefore(DateTime.now())) {
      scheduleDate = scheduleDate.add(Duration(days: interval));
    }

    alarmTime = DateTime(scheduleDate.year, scheduleDate.month,
        scheduleDate.day, time.hour, time.minute, time.second);
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
