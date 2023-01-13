import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:flutter/material.dart';

bool weekdaysContains(List<Weekday> alarmWeekdays, String name) {
  return alarmWeekdays
      .contains(weekdays.firstWhere((weekday) => weekday.displayName == name));
}

bool weekdaysContainsAll(List<Weekday> alarmWeekdays, List<String> names) {
  return names.every((name) => weekdaysContains(alarmWeekdays, name));
}

String getAlarmDescriptionText(Alarm alarm) {
  List<Weekday> alarmWeekdays = alarm.getWeekdays();
  if (alarm.enabled == false) {
    return 'Not scheduled';
  }
  if (alarmWeekdays.isEmpty) {
    return 'Just ${alarm.timeOfDay.toHours() > TimeOfDay.now().toHours() ? 'today' : 'tomorrow'}';
  } else {
    if (alarmWeekdays.length == 7) {
      return 'Every day';
    }
    if (alarmWeekdays.length == 2 &&
        weekdaysContainsAll(alarmWeekdays, ['Sat', 'Sun'])) {
      return 'Every weekend';
    }
    if (alarmWeekdays.length == 5 &&
        weekdaysContainsAll(
            alarmWeekdays, ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'])) {
      return 'Every weekday';
    }

    return 'Every ${weekdays.where((weekday) => alarmWeekdays.contains(weekday)).map((weekday) => weekday.displayName).join(', ')}';
  }
}
