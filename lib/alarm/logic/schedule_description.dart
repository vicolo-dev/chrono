import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/common/types/weekday.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/utils/weekday_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getAlarmScheduleDescription(Alarm alarm, String dateFormat) {
  if (alarm.isSnoozed) {
    return 'Snoozed until ${DateFormat("hh:mm").format(alarm.snoozeTime!)}';
  }
  if (alarm.isFinished) {
    return 'No future dates';
  }
  if (!alarm.isEnabled) {
    return 'Not scheduled';
  }
  switch (alarm.scheduleType) {
    case OnceAlarmSchedule:
      return 'Just ${alarm.time.toHours() > TimeOfDay.now().toHours() ? 'today' : 'tomorrow'}';
    case DailyAlarmSchedule:
      return 'Every day';
    case WeeklyAlarmSchedule:
      List<Weekday> alarmWeekdays = alarm.weekdays;
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
      List<DateTime> dates = alarm.dates;
      return 'On ${DateFormat(dateFormat).format(dates[0])}${dates.length > 1 ? ' and ${dates.length - 1} other${dates.length > 2 ? 's' : ''}' : ''}';
    case RangeAlarmSchedule:
      DateTime rangeStart = alarm.startDate;
      DateTime rangeEnd = alarm.endDate;
      Duration interval = alarm.interval;

      String startString = DateFormat(dateFormat).format(rangeStart);
      String endString = DateFormat(dateFormat).format(rangeEnd);

      DateTime currentDate = DateTime.now();

      if (rangeStart.year == currentDate.year &&
          rangeEnd.year == currentDate.year) {
        if (rangeStart.month == rangeEnd.month) {
          startString = DateFormat('d').format(rangeStart);
          endString = DateFormat('d MMM').format(rangeEnd);
        } else {
          startString = DateFormat('d MMM').format(rangeStart);
          endString = DateFormat('d MMM').format(rangeEnd);
        }
      }

      return '${interval.inDays == 1 ? "Daily" : "Weekly"} from $startString to $endString';
    default:
      return 'Not scheduled';
  }
}
