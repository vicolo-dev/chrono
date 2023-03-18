import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime dateTime = DateTime(2023, 1, 1, 1, 30, 0);

void main() {
  group('DateTimeUtils', () {
    testWidgets(
      'toHours() returns correct value',
      (tester) async {
        expect(dateTime.toHours(), 1.5);
      },
    );

    testWidgets(
      'toTimeOfDay() returns correct value',
      (tester) async {
        expect(dateTime.toTimeOfDay(), const TimeOfDay(hour: 1, minute: 30));
      },
    );
    testWidgets(
      'addTimeDuration() returns correct value',
      (tester) async {
        expect(
            dateTime.addTimeDuration(const TimeDuration(hours: 5, minutes: 7)),
            DateTime(2023, 1, 1, 6, 37, 0));
      },
    );
  });
}
