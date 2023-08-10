import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/widgets/timer_card.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const testKey = Key('key');
var sampleTimer =
    ClockTimer(const TimeDuration(hours: 2, minutes: 30, seconds: 10));

void main() {
  group('TimerCard', () {
    setUp(
      () async {
        sampleTimer =
            ClockTimer(const TimeDuration(hours: 2, minutes: 30, seconds: 10));
      },
    );
    testWidgets(
      'shows remaining time correctly',
      (tester) async {
        await _renderWidget(tester);
        expect(
            find.text(TimeDuration.fromSeconds(sampleTimer.remainingSeconds)
                .toTimeString()),
            findsOneWidget);
      },
    );
    group("shows state icon correctly", () {
      testWidgets(
        'when stopped',
        (tester) async {
          await _renderWidget(tester);
          expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
        },
      );
      testWidgets(
        'when running',
        (tester) async {
          sampleTimer.start();
          await _renderWidget(tester);
          expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
        },
      );
      testWidgets(
        'when paused',
        (tester) async {
          sampleTimer.start();
          sampleTimer.pause();
          await _renderWidget(tester);
          expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
        },
      );
    });

    group("shows label correctly", () {
      testWidgets(
        'when label is empty',
        (tester) async {
          await _renderWidget(tester);
          expect(find.text("2h 30m 10s timer"), findsOneWidget);
        },
      );
      testWidgets(
        'when label is present',
        (tester) async {
          sampleTimer.setSettingWithoutNotify("Label", "Test Label");
          await _renderWidget(tester);
          expect(find.text("Test Label"), findsOneWidget);
        },
      );
    });
  });
}

Future<void> _renderWidget(WidgetTester tester, [ClockTimer? timer]) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: defaultTheme,
      home: Scaffold(
        body: TimerCard(
          timer: timer ?? sampleTimer,
          onToggleState: () {},
          onPressDelete: () {},
          onPressDuplicate: () {},
          key: testKey,
        ),
      ),
    ),
  );
  //action
}
