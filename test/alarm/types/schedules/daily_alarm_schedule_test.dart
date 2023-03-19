import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyAlarmSchedule', () {
    group('schedules alarm in the future', () {
      test(
        'when time of day is more than current time of day',
        () async {
          final DailyAlarmSchedule schedule = DailyAlarmSchedule();
          final dateTime = DateTime.now().add(const Duration(minutes: 1));
          final timeOfDay = dateTime.toTimeOfDay();

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
          final DailyAlarmSchedule schedule = DailyAlarmSchedule();
          final dateTime = DateTime.now().subtract(const Duration(minutes: 1));
          final timeOfDay = dateTime.toTimeOfDay();

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
          final DailyAlarmSchedule schedule = DailyAlarmSchedule();
          const timeOfDay = TimeOfDay(hour: 10, minute: 30);

          await schedule.schedule(timeOfDay);
          schedule.cancel();

          expect(schedule.currentScheduleDateTime, null);
        },
      );
    });

    test('toJson() returns correct value', () async {
      final DailyAlarmSchedule schedule = DailyAlarmSchedule();
      const timeOfDay = TimeOfDay(hour: 10, minute: 30);
      await schedule.schedule(timeOfDay);

      expect(schedule.toJson(), {
        'alarmRunner': {
          'id': schedule.currentAlarmRunnerId,
          'currentScheduleDateTime':
              schedule.currentScheduleDateTime?.millisecondsSinceEpoch,
        },
      });
    });

    test('fromJson() creates DailyAlarmSchedule with correct values', () async {
      final scheduleDate = DateTime.now().add(const Duration(minutes: 1));
      final Map<String, dynamic> json = {
        'alarmRunner': {
          'id': 50,
          'currentScheduleDateTime': scheduleDate.millisecondsSinceEpoch,
        },
      };

      final DailyAlarmSchedule schedule = DailyAlarmSchedule.fromJson(json);

      expect(schedule.currentAlarmRunnerId, 50);
      expect(schedule.currentScheduleDateTime?.millisecondsSinceEpoch,
          scheduleDate.millisecondsSinceEpoch);
    });
  });
}
