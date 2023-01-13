import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:flutter/material.dart';

DateTime getOneTimeAlarmDate(TimeOfDay timeOfDay) {
  DateTime alarmTime;

  DateTime currentDateTime = DateTime.now();

  if (timeOfDay.toHours() > currentDateTime.toHours()) {
    alarmTime = DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, timeOfDay.hour, timeOfDay.minute);
  } else {
    DateTime nextDateTime = currentDateTime.add(const Duration(days: 1));
    alarmTime = DateTime(nextDateTime.year, nextDateTime.month,
        nextDateTime.day, timeOfDay.hour, timeOfDay.minute);
  }

  return alarmTime;
}

DateTime getRepeatAlarmDate(TimeOfDay timeOfDay, int weekday) {
  DateTime dateTime = getOneTimeAlarmDate(timeOfDay);
  while (dateTime.weekday != weekday) {
    dateTime = dateTime.add(const Duration(days: 1));
  }
  return dateTime;
}
