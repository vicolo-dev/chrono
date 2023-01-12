import 'package:flutter/material.dart';

double timeOfDayToHours(TimeOfDay timeOfDay) =>
    timeOfDay.hour + timeOfDay.minute / 60.0;

double dateTimeToHours(DateTime dateTime) =>
    dateTime.hour + dateTime.minute / 60.0;

TimeOfDay hoursToTimeOfDay(double hours) {
  int hour = hours.floor();
  int minute = ((hours - hour) * 60).round();
  return TimeOfDay(hour: hour, minute: minute);
}

DateTime getOneTimeAlarmDate(TimeOfDay timeOfDay) {
  DateTime alarmTime;

  DateTime currentDateTime = DateTime.now();

  if (timeOfDayToHours(timeOfDay) > dateTimeToHours(currentDateTime)) {
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

DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
  return DateTime(0, 0, 0, timeOfDay.hour, timeOfDay.minute);
}
