import 'package:clock/clock.dart';
import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime currentDate = DateTime(2000, 1, 10, 10, 0);
DateTime futureScheduleStartDate = DateTime(2000, 1, 20, 10, 0);
DateTime pastScheduleStartDate = DateTime(2000, 1, 1, 10, 0);

void testGetScheduleDateForTime(Time scheduleTime, DateTime expectedDate,
    {DateTime? scheduleStartDate, int interval = 1}) {
  withClock(
    Clock.fixed(currentDate),
    () {
      DateTime scheduledDateTime = getScheduleDateForTime(
        scheduleTime,
        interval: interval,
        scheduleStartDate: scheduleStartDate,
      );
      expect(
          scheduledDateTime,
          DateTime(
            expectedDate.year,
            expectedDate.month,
            expectedDate.day,
            scheduleTime.hour,
            scheduleTime.minute,
            scheduleTime.second,
          ));
    },
  );
}

void main() async {
  group('getScheduleDateForTime()', () {
    group('with interval = 1', () {
      group('without scheduleStartDate', () {
        test(
          "returns today's date when scheduled time is after current time",
          () {
            testGetScheduleDateForTime(
                const Time(hour: 11, minute: 0),
                DateTime(
                  currentDate.year,
                  currentDate.month,
                  currentDate.day,
                ));
          },
        );
        test(
          "returns tomorrow's date when scheduled time is before current time",
          () {
            testGetScheduleDateForTime(
                const Time(hour: 9, minute: 0),
                DateTime(
                  currentDate.year,
                  currentDate.month,
                  currentDate.day + 1,
                ));
          },
        );
        test(
          "returns tomorrow's date when scheduled time is same as current time",
          () {
            testGetScheduleDateForTime(
                const Time(hour: 10, minute: 0),
                DateTime(
                  currentDate.year,
                  currentDate.month,
                  currentDate.day + 1,
                ));
          },
        );
      });
      group('with scheduleStartDate in the future', () {
        test(
          "returns scheduleStartDate when scheduled time is after current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 11, minute: 0),
              DateTime(
                futureScheduleStartDate.year,
                futureScheduleStartDate.month,
                futureScheduleStartDate.day,
              ),
              scheduleStartDate: futureScheduleStartDate,
            );
          },
        );
        test(
          "returns day after scheduleStartDate when scheduled time is before current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 9, minute: 0),
              DateTime(
                futureScheduleStartDate.year,
                futureScheduleStartDate.month,
                futureScheduleStartDate.day,
              ),
              scheduleStartDate: futureScheduleStartDate,
            );
          },
        );
        test(
          "returns day after scheduleStartDate when scheduled time is same as current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 10, minute: 0),
              DateTime(
                futureScheduleStartDate.year,
                futureScheduleStartDate.month,
                futureScheduleStartDate.day,
              ),
              scheduleStartDate: futureScheduleStartDate,
            );
          },
        );
      });
      group('with scheduleStartDate in the past', () {
        test(
          "returns today's date when scheduled time is after current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 11, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day,
              ),
              scheduleStartDate: pastScheduleStartDate,
            );
          },
        );
        test(
          "returns tomorrow's date when scheduled time is before current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 9, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day + 1,
              ),
              scheduleStartDate: pastScheduleStartDate,
            );
          },
        );
        test(
          "returns tomorrow's date when scheduled time is same as current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 10, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day + 1,
              ),
              scheduleStartDate: pastScheduleStartDate,
            );
          },
        );
      });
    });
    group('with interval = 7', () {
      group('without scheduleStartDate', () {
        test(
          "returns today's date when scheduled time is after current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 11, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day,
              ),
              interval: 7,
            );
          },
        );
        test(
          "returns next week date when scheduled time is before current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 9, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day + 7,
              ),
              interval: 7,
            );
          },
        );
        test(
          "returns next week date when scheduled time is same as current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 10, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day + 7,
              ),
              interval: 7,
            );
          },
        );
      });
      group('with scheduleStartDate in the future', () {
        test(
          "returns scheduleStartDate when scheduled time is after current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 11, minute: 0),
              DateTime(
                futureScheduleStartDate.year,
                futureScheduleStartDate.month,
                futureScheduleStartDate.day,
              ),
              scheduleStartDate: futureScheduleStartDate,
              interval: 7,
            );
          },
        );
        test(
          "returns scheduleStartDate when scheduled time is before current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 9, minute: 0),
              DateTime(
                futureScheduleStartDate.year,
                futureScheduleStartDate.month,
                futureScheduleStartDate.day,
              ),
              scheduleStartDate: futureScheduleStartDate,
              interval: 7,
            );
          },
        );
        test(
          "returns scheduleStartDate when scheduled time is same as current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 10, minute: 0),
              DateTime(
                futureScheduleStartDate.year,
                futureScheduleStartDate.month,
                futureScheduleStartDate.day,
              ),
              scheduleStartDate: futureScheduleStartDate,
              interval: 7,
            );
          },
        );
      });
      group('with scheduleStartDate in the past', () {
        test(
          "returns correctly when scheduled time is after current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 11, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                15,
              ),
              scheduleStartDate: pastScheduleStartDate,
              interval: 7,
            );
          },
        );
        test(
          "returns correctly when scheduled time is before current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 9, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                15,
              ),
              scheduleStartDate: pastScheduleStartDate,
              interval: 7,
            );
          },
        );
        test(
          "returns returns correctly when scheduled time is same as current time",
          () {
            testGetScheduleDateForTime(
              const Time(hour: 10, minute: 0),
              DateTime(
                currentDate.year,
                currentDate.month,
                15,
              ),
              scheduleStartDate: pastScheduleStartDate,
              interval: 7,
            );
          },
        );
      });
    });
  });
}
