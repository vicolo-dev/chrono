import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';

ToggleSetting<int> weekdaySetting =
    alarmSettingsSchema.getSetting("Week Days").copy() as ToggleSetting<int>;
WeeklyAlarmSchedule schedule = WeeklyAlarmSchedule(weekdaySetting);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WeeklyAlarmSchedule', () {
    setUp(() {
      weekdaySetting = alarmSettingsSchema.getSetting("Week Days").copy()
          as ToggleSetting<int>;
      schedule = WeeklyAlarmSchedule(weekdaySetting);
    });
    test('schedule sets currentScheduleDateTime to correct value', () async {
      const time = Time(hour: 10, minute: 30);

      bool result = await schedule.schedule(time);

      expect(result, true);
      expect(schedule.currentScheduleDateTime?.hour, time.hour);
      expect(schedule.currentScheduleDateTime?.minute, time.minute);
    });

    group('schedules alarm in the future', () {
      test(
        'when time of day is more than current time of day',
        () async {
          const time = Time(hour: 10, minute: 30);

          bool result = await schedule.schedule(time);

          expect(result, true);
          expect(
              schedule.currentScheduleDateTime?.isAfter(DateTime.now()), true);
        },
      );
      test(
        'when time of day is less than current time of day',
        () async {
          const time = Time(hour: 10, minute: 30);

          bool result = await schedule.schedule(time);

          expect(result, true);
          expect(
              schedule.currentScheduleDateTime?.isAfter(DateTime.now()), true);
        },
      );
    });

    group('cancel sets currentScheduleDateTime to null', () {
      test(
        'cancels scheduled alarm',
        () async {
          await schedule.schedule(const Time(hour: 10, minute: 30));
          schedule.cancel();

          expect(schedule.currentScheduleDateTime, null);
        },
      );
    });

    test('isFinished returns false', () {
      expect(schedule.isFinished, false);
    });

    test('isDisabled returns false', () {
      expect(schedule.isDisabled, false);
    });

    group('alarmRunners', () {
      test('returns empty list when not scheduled', () {
        expect(schedule.alarmRunners, []);
      });
      test('returns list with one item when scheduled', () {
        schedule.schedule(const Time(hour: 10, minute: 30));
        expect(schedule.alarmRunners.length, 1);
      });
      test('returns list with 5 items when 5 weekdays are selected', () {
        weekdaySetting.setValueWithoutNotify(
            [true, true, true, false, true, false, true]);
        schedule.schedule(const Time(hour: 10, minute: 30));
        expect(schedule.alarmRunners.length, 5);
      });
    });

    group('hasId()', () {
      test('returns false when id is not in alarmRunners', () {
        expect(schedule.hasId(-1), false);
      });
      test('returns true when id is in alarmRunners', () {
        schedule.schedule(const Time(hour: 10, minute: 30));
        expect(schedule.hasId(schedule.currentAlarmRunnerId), true);
      });
    });

    group('nextWeekdaySchedule', () {
      test('returns default WeekdaySchedule when no weekdays are selected', () {
        expect(
            schedule.nextWeekdaySchedule.weekday, WeekdaySchedule(0).weekday);
      });
      test('returns correct weekday schedule when scheduled', () {
        schedule.schedule(const Time(hour: 10, minute: 30));
        expect(schedule.nextWeekdaySchedule.weekday, 1);
      });
    });

    group('scheduledWeekdays', () {
      test('returns list with one item when not scheduled', () {
        schedule.schedule(const Time(hour: 10, minute: 30));
        expect(schedule.scheduledWeekdays.length, 1);
      });
      test('returns list with one item when scheduled', () {
        schedule.schedule(const Time(hour: 10, minute: 30));
        expect(schedule.scheduledWeekdays.length, 1);
      });
      test('returns list with 5 items when 5 weekdays are selected', () {
        weekdaySetting.setValueWithoutNotify(
            [true, true, true, false, true, false, true]);
        schedule.schedule(const Time(hour: 10, minute: 30));
        expect(schedule.scheduledWeekdays.length, 5);
      });
    });

    test('toJson() returns correct value', () {
      schedule.schedule(const Time(hour: 10, minute: 30));
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
