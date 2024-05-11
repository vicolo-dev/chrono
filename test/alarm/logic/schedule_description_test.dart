import 'package:clock_app/alarm/logic/schedule_description.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void testDescription(String name, Function(BuildContext) callback) {
  testWidgets(name, (WidgetTester tester) async {
    await tester.pumpWidget(
      Localizations(
        delegates: AppLocalizations.localizationsDelegates,
        locale: const Locale('en'),
        child: Builder(
          builder: (BuildContext context) {
            callback(context);
            return const Placeholder();
          },
        ),
      ),
    );
  });
}

void main() async {
  group('getAlarmScheduleDescription', () {
    testDescription('when alarm is snoozed', (context) async {
      final alarm = Alarm(const Time(hour: 8, minute: 30));
      await alarm.snooze();

      final result = getAlarmScheduleDescription(
          context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);

      expect(
        result,
        'Snoozed until ${DateFormat("h:mm a").format(alarm.snoozeTime!)}',
      );
    });

    // testDescription('when alarm is finished', (context) async {
    //   final alarm = Alarm(const Time(hour: 8, minute: 30));
    //   // alarm.setSettingWithoutNotify("Type", 3);
    //
    //   // await alarm.finish();
    //
    //   final result = getAlarmScheduleDescription(
    //       context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);
    //
    //   expect(result, 'No future dates');
    // });

    testDescription('when alarm is not enabled', (context) async {
      final alarm = Alarm(const Time(hour: 8, minute: 30));

      await alarm.disable();

      final result = getAlarmScheduleDescription(
          context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);

      expect(result, 'Not scheduled');
    });

    testDescription('when alarm has once schedule', (context) {
      final alarm = Alarm(const Time(hour: 8, minute: 30));
      alarm.setSettingWithoutNotify("Type", 0);

      final result = getAlarmScheduleDescription(
          context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);

      expect(
        result,
        'Just ${alarm.time.toHours() > Time.now().toHours() ? 'today' : 'tomorrow'}',
      );
    });

    testDescription('when alarm has daily schedule', (context) {
      final alarm = Alarm(const Time(hour: 8, minute: 30));
      alarm.setSettingWithoutNotify("Type", 1);

      final result = getAlarmScheduleDescription(
          context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);

      expect(result, 'Every day');
    });

    group('when alarm has weekly schedule', () {
      final alarm = Alarm(const Time(hour: 8, minute: 30));
      alarm.setSettingWithoutNotify("Type", 2);
      testDescription("with all week days", (context) {
        alarm.setSettingWithoutNotify(
            "Week Days", [true, true, true, true, true, true, true]);

        final result = getAlarmScheduleDescription(
            context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);

        expect(result, 'Every day');
      });

      testDescription("with only weekends", (context) {
        alarm.setSettingWithoutNotify(
            "Week Days", [false, false, false, false, false, true, true]);

        final result = getAlarmScheduleDescription(
            context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);

        expect(result, 'Every weekend');
      });
      testDescription("with only weekdays", (context) {
        alarm.setSettingWithoutNotify(
            "Week Days", [true, true, true, true, true, false, false]);

        final result = getAlarmScheduleDescription(
            context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);

        expect(result, 'Every weekday');
      });
      testDescription("with other week days", (context) {
        alarm.setSettingWithoutNotify(
            "Week Days", [true, false, false, false, false, false, true]);

        final result = getAlarmScheduleDescription(
            context, alarm, 'yyyy-MM-dd HH:mm:ss.SSS', TimeFormat.h12);

        expect(result, 'Every Mon, Sun');
      });
    });
  });
}
