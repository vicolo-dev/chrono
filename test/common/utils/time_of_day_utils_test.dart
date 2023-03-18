import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

TimeOfDay timeOfDay = const TimeOfDay(hour: 1, minute: 30);

void main() {
  group('TimeOfDayUtils', () {
    testWidgets(
      'toHours() returns correct value',
      (tester) async {
        expect(timeOfDay.toHours(), 1.5);
      },
    );

    group(
      'isBetween() returns correct value',
      () {
        testWidgets(
          'when time is between start and end',
          (tester) async {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 1, minute: 0),
                    const TimeOfDay(hour: 2, minute: 0)),
                true);
          },
        );

        testWidgets(
          'when time is equal to start',
          (tester) async {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 1, minute: 30),
                    const TimeOfDay(hour: 2, minute: 0)),
                true);
          },
        );

        testWidgets(
          'when time is equal to end',
          (tester) async {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 1, minute: 0),
                    const TimeOfDay(hour: 1, minute: 30)),
                true);
          },
        );

        testWidgets(
          'when time is before start',
          (tester) async {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 2, minute: 0),
                    const TimeOfDay(hour: 3, minute: 0)),
                false);
          },
        );

        testWidgets(
          'when time is after end',
          (tester) async {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 0, minute: 0),
                    const TimeOfDay(hour: 1, minute: 0)),
                false);
          },
        );
      },
    );

    testWidgets(
      'formatToString() returns correct value',
      (tester) async {
        expect(timeOfDay.formatToString("hh:mm"), '01:30');
      },
    );

    testWidgets(
      'fromHours() returns correct value',
      (tester) async {
        expect(TimeOfDayUtils.fromHours(1.5),
            const TimeOfDay(hour: 1, minute: 30));
      },
    );
    testWidgets(
      'fromJson() returns correct value',
      (tester) async {
        expect(TimeOfDayUtils.fromJson({'hour': 1, 'minute': 30}),
            const TimeOfDay(hour: 1, minute: 30));
      },
    );
    // testWidgets(
    //   'toDateTime() returns correct value',
    //   (tester) async {
    //     expect(timeOfDay.toDateTime(), DateTime(2020, 1, 1, 1, 30, 0));
    //   },
    // );
    testWidgets(
      'toJson() returns correct value',
      (tester) async {
        expect(timeOfDay.toJson(), {'hour': 1, 'minute': 30});
      },
    );

    testWidgets(
      'encode() returns correct value',
      (tester) async {
        expect(timeOfDay.encode(), '1.5');
      },
    );

    testWidgets(
      'decode() returns correct value',
      (tester) async {
        expect(
            TimeOfDayUtils.decode('1.5'), const TimeOfDay(hour: 1, minute: 30));
      },
    );
  });
}
