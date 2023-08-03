import 'package:clock_app/alarm/logic/schedule_description.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('getAlarmScheduleDescription', () {
    test('when alarm is snoozed', () {
      final alarm = Alarm(const Time(hour: 8, minute: 30));
      alarm.snooze();

      final result =
          getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

      expect(
        result,
        'Snoozed until ${DateFormat("hh:mm").format(alarm.snoozeTime!)}',
      );
    });

    test('when alarm is finished', () {
      final alarm = Alarm(const Time(hour: 8, minute: 30));

      alarm.finish();

      final result =
          getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

      expect(result, 'No future dates');
    });

    test('when alarm is not enabled', () {
      final alarm = Alarm(const Time(hour: 8, minute: 30));

      alarm.disable();

      final result =
          getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

      expect(result, 'Not scheduled');
    });

    test('when alarm has once schedule', () {
      final alarm = Alarm(const Time(hour: 8, minute: 30));
      alarm.setSettingWithoutNotify("Type", 0);

      final result =
          getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

      expect(
        result,
        'Just ${alarm.time.toHours() > Time.now().toHours() ? 'today' : 'tomorrow'}',
      );
    });

    test('when alarm has daily schedule', () {
      final alarm = Alarm(const Time(hour: 8, minute: 30));
      alarm.setSettingWithoutNotify("Type", 1);

      final result =
          getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

      expect(result, 'Every day');
    });

    group('when alarm has weekly schedule', () {
      final alarm = Alarm(const Time(hour: 8, minute: 30));
      alarm.setSettingWithoutNotify("Type", 2);
      test("with all week days", () {
        alarm.setSettingWithoutNotify(
            "Week Days", [true, true, true, true, true, true, true]);

        final result =
            getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

        expect(result, 'Every day');
      });

      test("with only weekends", () {
        alarm.setSettingWithoutNotify(
            "Week Days", [false, false, false, false, false, true, true]);

        final result =
            getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

        expect(result, 'Every weekend');
      });
      test("with only weekdays", () {
        alarm.setSettingWithoutNotify(
            "Week Days", [true, true, true, true, true, false, false]);

        final result =
            getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

        expect(result, 'Every weekday');
      });
      test("with other week days", () {
        alarm.setSettingWithoutNotify(
            "Week Days", [true, false, false, false, false, false, true]);

        final result =
            getAlarmScheduleDescription(alarm, 'yyyy-MM-dd HH:mm:ss.SSS');

        expect(result, 'Every Mon, Sun');
      });
    });
  });
}
