import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

AlarmRunner alarmRunner = AlarmRunner();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    alarmRunner = AlarmRunner();
  });
  group('AlarmRunner', () {
    group('currentScheduleDateTime', () {
      test(
        'returns null before scheduling',
        () async {
          expect(alarmRunner.currentScheduleDateTime, null);

          // expect(dateTime.toHours(), 1.5);
        },
      );
      test(
        'returns scheduled time after scheduling',
        () async {
          DateTime scheduledTime =
              DateTime.now().add(const Duration(minutes: 1));
          await alarmRunner.schedule(scheduledTime);

          expect(alarmRunner.currentScheduleDateTime, scheduledTime);

          // expect(dateTime.toHours(), 1.5);
        },
      );
    });

    group('scheduling alarm', () {
      test(
        'in the future returns true',
        () async {
          expect(
              await alarmRunner
                  .schedule(DateTime.now().add(const Duration(minutes: 1))),
              true);

          // expect(dateTime.toHours(), 1.5);
        },
      );
      test(
        'in the past throws exception',
        () async {
          expect(
              () async => await alarmRunner.schedule(
                  DateTime.now().subtract(const Duration(minutes: 1))),
              throwsA(isA<Exception>()));
        },
      );
    });

    test('toJson() returns correct value', () async {
      DateTime scheduledTime = DateTime.now().add(const Duration(minutes: 1));
      await alarmRunner.schedule(scheduledTime);

      expect(alarmRunner.toJson(), {
        'id': alarmRunner.id,
        'currentScheduleDateTime': scheduledTime.millisecondsSinceEpoch,
      });
    });

    // test('fromJson() creates AlarmRunner with correct values', () async {
    //   DateTime scheduledTime = DateTime.now().add(const Duration(minutes: 1));

    //   AlarmRunner alarmRunnerFromJson = AlarmRunner.fromJson({
    //     'id': 50,
    //     'currentScheduleDateTime': scheduledTime.millisecondsSinceEpoch,
    //   });
    //   expect(alarmRunnerFromJson.id, 50);
    //   expect(alarmRunnerFromJson.currentScheduleDateTime, scheduledTime);
    // });
  });
}
