import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

TimeOfDay timeOfDay = const TimeOfDay(hour: 1, minute: 30);

void main() {
  group('TimeOfDayUtils', () {
    test(
      'toHours() returns correct value',
      () {
        expect(timeOfDay.toHours(), 1.5);
      },
    );

    group(
      'isBetween()',
      () {
        test(
          'return true when time is between start and end',
          () {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 1, minute: 0),
                    const TimeOfDay(hour: 2, minute: 0)),
                true);
          },
        );

        test(
          'returns true when time is equal to start',
          () {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 1, minute: 30),
                    const TimeOfDay(hour: 2, minute: 0)),
                true);
          },
        );

        test(
          'returns true when time is equal to end',
          () {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 1, minute: 0),
                    const TimeOfDay(hour: 1, minute: 30)),
                true);
          },
        );

        test(
          'returns false when time is before start',
          () {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 2, minute: 0),
                    const TimeOfDay(hour: 3, minute: 0)),
                false);
          },
        );

        test(
          'returns false when time is after end',
          () {
            expect(
                timeOfDay.isBetween(const TimeOfDay(hour: 0, minute: 0),
                    const TimeOfDay(hour: 1, minute: 0)),
                false);
          },
        );
      },
    );

    test(
      'formatToString() returns correct value',
      () {
        expect(timeOfDay.formatToString("hh:mm"), '01:30');
      },
    );

    test(
      'fromHours() returns correct value',
      () {
        expect(TimeOfDayUtils.fromHours(1.5),
            const TimeOfDay(hour: 1, minute: 30));
      },
    );
    test(
      'fromJson() returns correct value',
      () {
        expect(TimeOfDayUtils.fromJson({'hour': 1, 'minute': 30}),
            const TimeOfDay(hour: 1, minute: 30));
      },
    );
    // test(
    //   'toDateTime() returns correct value',
    //   ()  {
    //     expect(timeOfDay.toDateTime(), DateTime(2020, 1, 1, 1, 30, 0));
    //   },
    // );
    test(
      'toJson() returns correct value',
      () {
        expect(timeOfDay.toJson(), {'hour': 1, 'minute': 30});
      },
    );

    test(
      'encode() returns correct value',
      () {
        expect(timeOfDay.encode(), '1.5');
      },
    );

    test(
      'decode() returns correct value',
      () {
        expect(
            TimeOfDayUtils.decode('1.5'), const TimeOfDay(hour: 1, minute: 30));
      },
    );
  });
}
