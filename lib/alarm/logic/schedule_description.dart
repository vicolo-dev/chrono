import 'package:clock_app/alarm/types/range_interval.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/common/types/weekday.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_format.dart';
import 'package:clock_app/common/utils/weekday_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getAlarmScheduleDescription(BuildContext context, Alarm alarm,
    String dateFormat, TimeFormat timeFormat) {
  String suffix = '';
  if (alarm.shouldSkipNextAlarm) {
    suffix = '(skipping next occurence)';
  }
  if (alarm.isSnoozed) {
    return 'Snoozed until ${DateFormat(getTimeFormatString(context, timeFormat)).format(alarm.snoozeTime!)}';
  }
  if (alarm.isFinished) {
    return 'No future dates';
  }
  if (!alarm.isEnabled) {
    return 'Not scheduled';
  }
  switch (alarm.scheduleType) {
    case OnceAlarmSchedule:
      return 'Just ${alarm.time.toHours() > DateTime.now().toHours() ? 'today' : 'tomorrow'}';
    case DailyAlarmSchedule:
      return 'Every day $suffix';
    case WeeklyAlarmSchedule:
      List<Weekday> alarmWeekdays = alarm.weekdays;
      if (alarmWeekdays.length == 7) {
        return 'Every day $suffix';
      }
      if (alarmWeekdays.length == 2 &&
          weekdaysContainsAll(alarmWeekdays, ['Sat', 'Sun'])) {
        return 'Every weekend $suffix';
      }
      if (alarmWeekdays.length == 5 &&
          weekdaysContainsAll(
              alarmWeekdays, ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'])) {
        return 'Every weekday $suffix';
      }
      return 'Every ${weekdays.where((weekday) => alarmWeekdays.contains(weekday)).map((weekday) => weekday.displayName).join(', ')} $suffix';
    case DatesAlarmSchedule:
      List<DateTime> dates = alarm.dates;
      return 'On ${DateFormat(dateFormat).format(dates[0])}${dates.length > 1 ? ' and ${dates.length - 1} other date${dates.length > 2 ? 's' : ''} ' : ''} $suffix';
    case RangeAlarmSchedule:
      DateTime rangeStart = alarm.startDate;
      DateTime rangeEnd = alarm.endDate;
      RangeInterval interval = alarm.interval;

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

      return '${interval == RangeInterval.daily ? "Daily" : "Weekly"} from $startString to $endString $suffix';
    default:
      return 'Not scheduled';
  }
}
