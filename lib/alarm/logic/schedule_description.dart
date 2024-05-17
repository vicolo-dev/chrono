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
import 'package:clock_app/common/utils/list.dart';
import 'package:clock_app/common/utils/time_format.dart';
import 'package:clock_app/common/utils/weekday_utils.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getAlarmScheduleDescription(BuildContext context, Alarm alarm,
    String dateFormat, TimeFormat timeFormat) {
  String suffix = '';
  if (alarm.shouldSkipNextAlarm) {
    suffix = ' ${AppLocalizations.of(context)!.skippingDescriptionSuffix}';
  }
  if (alarm.isSnoozed) {
    return AppLocalizations.of(context)!.alarmDescriptionSnooze(
        DateFormat(getTimeFormatString(context, timeFormat))
            .format(alarm.snoozeTime!));
  }
  if (alarm.isFinished) {
    return AppLocalizations.of(context)!.alarmDescriptionFinished;
  }
  if (!alarm.isEnabled) {
    return AppLocalizations.of(context)!.alarmDescriptionNotScheduled;
  }
  switch (alarm.scheduleType) {
    case OnceAlarmSchedule:
      return '${alarm.time.toHours() > DateTime.now().toHours() ? AppLocalizations.of(context)!.alarmDescriptionToday : AppLocalizations.of(context)!.alarmDescriptionTomorrow}$suffix';
    case DailyAlarmSchedule:
      return '${AppLocalizations.of(context)!.alarmDescriptionEveryDay}$suffix';
    case WeeklyAlarmSchedule:
      List<Weekday> alarmWeekdays = alarm.weekdays;
      if (alarmWeekdays.length == 7) {
        return '${AppLocalizations.of(context)!.alarmDescriptionEveryDay}$suffix';
      }
      if (alarmWeekdays.length == 2 &&
          weekdaysContainsAll(alarmWeekdays, [6, 7])) {
        return '${AppLocalizations.of(context)!.alarmDescriptionWeekend}$suffix';
      }
      if (alarmWeekdays.length == 5 &&
          weekdaysContainsAll(alarmWeekdays, [1, 2, 3, 4, 5])) {
        return '${AppLocalizations.of(context)!.alarmDescriptionWeekday}$suffix';
      }
      Weekday weekday = appSettings
          .getGroup("General")
          .getGroup("Display")
          .getSetting("First Day of Week")
          .value;
      final sortedWeekdays = weekdays.rotate(weekday.id - 1);
      final weekdaysString = sortedWeekdays
          .where((weekday) => alarmWeekdays.contains(weekday))
          .map((weekday) => weekday.getDisplayName(context))
          .join(', ');
      return '${AppLocalizations.of(context)!.alarmDescriptionWeekly(weekdaysString)}$suffix';
    case DatesAlarmSchedule:
      List<DateTime> dates = alarm.dates;
      return '${AppLocalizations.of(context)!.alarmDescriptionDates(dates.length - 1, DateFormat(dateFormat).format(dates[0]))}$suffix';
    /*   return 'On ${DateFormat(dateFormat).format(dates[0])}${dates.length > 1 ? ' and ${dates.length - 1} other date${dates.length > 2 ? 's' : ''} ' : ''}$suffix'; */
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
      return '${AppLocalizations.of(context)!.alarmDescriptionRange(endString, interval == RangeInterval.daily ? "daily" : "weekly", startString)}$suffix';
    // return '${interval == RangeInterval.daily ? "Daily" : "Weekly"} from $startString to $endString$suffix';
    default:
      return AppLocalizations.of(context)!.alarmDescriptionNotScheduled;
  }
}
