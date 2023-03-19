import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WeeklyAlarmSchedule', () {
    ToggleSetting<int> weekdaySetting =
        alarmSettingsSchema.getSetting("Week Days") as ToggleSetting<int>;
    final schedule = WeeklyAlarmSchedule(weekdaySetting);

    group('schedules alarm in the future', () {
      test(
        'when time of day is more than current time of day',
        () async {
          const timeOfDay = TimeOfDay(hour: 10, minute: 30);

          bool result = await schedule.schedule(timeOfDay);

          expect(result, true);
          expect(schedule.currentScheduleDateTime?.hour, timeOfDay.hour);
          expect(schedule.currentScheduleDateTime?.minute, timeOfDay.minute);
          expect(
              schedule.currentScheduleDateTime?.isAfter(DateTime.now()), true);
        },
      );
      test(
        'when time of day is less than current time of day',
        () async {
          const timeOfDay = TimeOfDay(hour: 10, minute: 30);

          bool result = await schedule.schedule(timeOfDay);

          expect(result, true);
          expect(schedule.currentScheduleDateTime?.hour, timeOfDay.hour);
          expect(schedule.currentScheduleDateTime?.minute, timeOfDay.minute);
          expect(
              schedule.currentScheduleDateTime?.isAfter(DateTime.now()), true);
        },
      );
    });

    group('cancel', () {
      test(
        'cancels scheduled alarm',
        () async {
          await schedule.schedule(const TimeOfDay(hour: 10, minute: 30));
          schedule.cancel();

          expect(schedule.currentScheduleDateTime, null);
        },
      );
    });

    test('toJson() returns correct value', () async {
      schedule.schedule(const TimeOfDay(hour: 10, minute: 30));
      final weekdayScheduleJson = {
        'weekday': 1,
        'alarmRunner': {
          'id': schedule.currentAlarmRunnerId,
          'currentScheduleDateTime':
              schedule.currentScheduleDateTime?.millisecondsSinceEpoch,
        },
      };
      final weeklyScheduleJson = {
        'weekdaySchedules': [weekdayScheduleJson],
      };

      expect(schedule.toJson(), weeklyScheduleJson);
    });

    test('fromJson() creates WeeklyAlarmSchedule with correct values',
        () async {
      final dateTime = DateTime.now();
      final weekdayScheduleJson = {
        'weekday': 1,
        'alarmRunner': {
          'id': 50,
          'currentScheduleDateTime': dateTime.millisecondsSinceEpoch,
        },
      };
      final weeklyScheduleJson = {
        'weekdaySchedules': [weekdayScheduleJson],
      };

      final weeklySchedule =
          WeeklyAlarmSchedule.fromJson(weeklyScheduleJson, weekdaySetting);

      expect(weeklySchedule.scheduledWeekdays.length, 1);
      expect(weeklySchedule.scheduledWeekdays[0].id, 1);
      expect(weeklySchedule.currentAlarmRunnerId, 50);
      expect(weeklySchedule.currentScheduleDateTime?.millisecondsSinceEpoch,
          dateTime.millisecondsSinceEpoch);
    });
  });
}
