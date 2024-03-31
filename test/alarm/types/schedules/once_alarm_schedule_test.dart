import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:flutter_test/flutter_test.dart';

OnceAlarmSchedule schedule = OnceAlarmSchedule();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnceAlarmSchedule', () {
    setUp(() {
      schedule = OnceAlarmSchedule();
    });

    test('schedule sets currentScheduleDateTime to correct value', () async {
      const time = Time(hour: 10, minute: 30);

      bool result = await schedule.schedule(time, 'test');

      expect(result, true);
      expect(schedule.currentScheduleDateTime?.hour, time.hour);
      expect(schedule.currentScheduleDateTime?.minute, time.minute);
    });
    group('schedules alarm in the future', () {
      test(
        'when time of day is more than current time of day',
        () async {
          final dateTime = DateTime.now().add(const Duration(minutes: 1));
          final time = dateTime.getTime();

          bool result = await schedule.schedule(time, 'test');

          expect(result, true);
          expect(
              schedule.currentScheduleDateTime?.isAfter(DateTime.now()), true);
        },
      );
      test(
        'when time of day is less than current time of day',
        () async {
          final dateTime = DateTime.now().subtract(const Duration(minutes: 1));
          final time = dateTime.getTime();

          bool result = await schedule.schedule(time, 'test');

          expect(result, true);
          expect(
              schedule.currentScheduleDateTime?.isAfter(DateTime.now()), true);
        },
      );
    });

    group('cancel', () {
      test(
        'sets currentScheduleDateTime to null',
        () async {
          const time = Time(hour: 10, minute: 30);

          await schedule.schedule(time, 'test');
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

    test('alarmRunners returns list with one item', () {
      expect(schedule.alarmRunners.length, 1);
    });

    group('hasId()', () {
      test('returns false when id is not in alarmRunners', () {
        expect(schedule.hasId(-1), false);
      });
      test('returns true when id is in alarmRunners', () {
        schedule.schedule(const Time(hour: 10, minute: 30), 'test');
        expect(schedule.hasId(schedule.currentAlarmRunnerId), true);
      });
    });

    test('toJson() returns correct value', () async {
      const time = Time(hour: 10, minute: 30);
      await schedule.schedule(time, "test");

      expect(schedule.toJson(), {
        'alarmRunner': {
          'id': schedule.currentAlarmRunnerId,
          'currentScheduleDateTime':
              schedule.currentScheduleDateTime?.millisecondsSinceEpoch,
        },
        'isDisabled': false,
      });
    });

    test('fromJson() creates OnceAlarmSchedule with correct values', () async {
      final scheduleDate = DateTime.now().add(const Duration(minutes: 1));
      final Json json = {
        'alarmRunner': {
          'id': 50,
          'currentScheduleDateTime': scheduleDate.millisecondsSinceEpoch,
        },
        'isDisabled': true,
      };

      final OnceAlarmSchedule scheduleFromJson =
          OnceAlarmSchedule.fromJson(json);

      expect(scheduleFromJson.currentAlarmRunnerId, 50);
      expect(scheduleFromJson.currentScheduleDateTime?.millisecondsSinceEpoch,
          scheduleDate.millisecondsSinceEpoch);
      expect(scheduleFromJson.isDisabled, true);
    });
  });
}
