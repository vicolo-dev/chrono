import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_schedules.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool weekdaysContains(List<Weekday> alarmWeekdays, String name) {
  return alarmWeekdays
      .contains(weekdays.firstWhere((weekday) => weekday.displayName == name));
}

bool weekdaysContainsAll(List<Weekday> alarmWeekdays, List<String> names) {
  return names.every((name) => weekdaysContains(alarmWeekdays, name));
}

String getAlarmScheduleDescription(Alarm alarm) {
  if (alarm.enabled == false) {
    return 'Not scheduled';
  }
  switch (alarm.scheduleType) {
    case OnceAlarmSchedule:
      return 'Just ${alarm.timeOfDay.toHours() > TimeOfDay.now().toHours() ? 'today' : 'tomorrow'}';
    case DailyAlarmSchedule:
      return 'Every day';
    case WeeklyAlarmSchedule:
      List<Weekday> alarmWeekdays = alarm.getWeekdays();
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
    case DatesAlarmSchedule:
      List<DateTime> dates = alarm.getDates();
      return 'On ${DateFormat('dd/MM/yy').format(dates[0])}${dates.length > 1 ? ' and ${dates.length - 1} other${dates.length > 2 ? 's' : ''}' : ''}';
    // case RangeAlarmSchedule:
    //   DateTime rangeStart = alarm.getRangeStartDate();
    //   DateTime rangeEnd = alarm.getRangeEndDate();
    //   return 'From ${rangeStart.day}/${rangeStart.month} to ${rangeEnd.day}/${rangeEnd.month}';
    default:
      return 'Not scheduled';
  }
}
