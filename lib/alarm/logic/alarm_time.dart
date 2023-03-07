import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:flutter/material.dart';

DateTime getDailyAlarmDate(
  TimeOfDay timeOfDay, {
  DateTime? scheduledDate,
}) {
  if (scheduledDate != null && scheduledDate.isAfter(DateTime.now())) {
    return DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day,
        timeOfDay.hour, timeOfDay.minute);
  }

  scheduledDate = DateTime.now();

  DateTime alarmTime;

  if (timeOfDay.toHours() > scheduledDate.toHours()) {
    alarmTime = DateTime(scheduledDate.year, scheduledDate.month,
        scheduledDate.day, timeOfDay.hour, timeOfDay.minute);
  } else {
    DateTime nextDateTime = scheduledDate.add(const Duration(days: 1));
    alarmTime = DateTime(nextDateTime.year, nextDateTime.month,
        nextDateTime.day, timeOfDay.hour, timeOfDay.minute);
  }

  return alarmTime;
}

DateTime getWeeklyAlarmDate(TimeOfDay timeOfDay, int weekday) {
  DateTime dateTime = getDailyAlarmDate(timeOfDay);
  while (dateTime.weekday != weekday) {
    dateTime = dateTime.add(const Duration(days: 1));
  }
  return dateTime;
}
