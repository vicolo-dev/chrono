import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:flutter/material.dart' hide TimePickerDialog;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

TimeOfDay selectedTime = const TimeOfDay(hour: 12, minute: 30);

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  group("showTimePickerDialog", () {
    setUp(() {
      selectedTime = const TimeOfDay(hour: 12, minute: 30);
    });
    group('opens correctly', () {
      testWidgets('in landscape mode', (WidgetTester tester) async {
        binding.window.physicalSizeTestValue = const Size(1920, 1080);
        binding.window.devicePixelRatioTestValue = 1.0;
        await _renderWidget(tester);
        await tester.tap(find.text('Open Time Picker'));
        await tester.pumpAndSettle();
        expect(find.byType(TimePickerDialog), findsOneWidget);
        // await tester.tap(find.text('OK'));
        // await tester.pumpAndSettle();
        // expect(selectedTime,
        //     TimeOfDay(hour: 12, minute: 0).replacing(hour: DateTime.now().hour));
      });
      testWidgets('in portrait mode', (WidgetTester tester) async {
        binding.window.physicalSizeTestValue = const Size(1080, 1920);
        binding.window.devicePixelRatioTestValue = 1.0;
        await _renderWidget(tester);
        await tester.tap(find.text('Open Time Picker'));
        await tester.pumpAndSettle();
        expect(find.byType(TimePickerDialog), findsOneWidget);
        // await tester.tap(find.text('OK'));
        // await tester.pumpAndSettle();
        // expect(selectedTime,
        //     TimeOfDay(hour: 12, minute: 0).replacing(hour: DateTime.now().hour));
      });
    });
    group('shows text', () {
      testWidgets('for hours', (WidgetTester tester) async {
        await _renderWidget(tester);
        await tester.tap(find.text('Open Time Picker'));
        await tester.pumpAndSettle();
        expect(find.text("12"), findsOneWidget);
      });
      testWidgets('for minutes', (WidgetTester tester) async {
        await _renderWidget(tester);
        await tester.tap(find.text('Open Time Picker'));
        await tester.pumpAndSettle();
        expect(find.text("30"), findsOneWidget);
      });
      testWidgets('for day period', (WidgetTester tester) async {
        await _renderWidget(tester);
        await tester.tap(find.text('Open Time Picker'));
        await tester.pumpAndSettle();
        expect(find.text("AM"), findsOneWidget);
        expect(find.text("PM"), findsOneWidget);
      });
    });

    // group('shows dial labels', () {
    //   testWidgets('with default text', (WidgetTester tester) async {

    //     // await tester.tap(find.text('Open Time Picker'));
    //     // await tester.pumpAndSettle();
    //     // await tester.tap(find.textContaining('11'));
    //      await _renderWidget(tester);
    //     final finder = find.byWidgetPredicate((widget) {
    //       if (widget is CustomPaint) {
    //         final painter = widget.painter;
    //         if (painter is DialPainter) {
    //           return painter. == 'Hello, world!';
    //         }
    //       }
    //       return false;
    //     });
    //     expect(finder, findsOneWidget);

    //   });
    // testWidgets('custom', (WidgetTester tester) async {
    //   await _renderWidget(tester);
    //   await tester.tap(find.text('Open Time Picker'));hb
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('OK'));
    // });
    // });

    group('shows confirm button', () {
      testWidgets('with default text', (WidgetTester tester) async {
        await _renderWidget(tester);
        await tester.tap(find.text('Open Time Picker'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
      });
      // testWidgets('custom', (WidgetTester tester) async {
      //   await _renderWidget(tester);
      //   await tester.tap(find.text('Open Time Picker'));
      //   await tester.pumpAndSettle();
      //   await tester.tap(find.text('OK'));
      // });
    });
    group('shows cancel button', () {
      testWidgets('with default text', (WidgetTester tester) async {
        await _renderWidget(tester);
        await tester.tap(find.text('Open Time Picker'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
      });
    });
    group('returns correct time', () {
      testWidgets('when time is not changed', (WidgetTester tester) async {
        await _renderWidget(tester);
        await tester.tap(find.text('Open Time Picker'));
        await tester.pumpAndSettle();
        // expect(find.byType(TimePickerDialog), findsOneWidget);
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        expect(selectedTime, const TimeOfDay(hour: 12, minute: 30));
      });
    });
  });
}

Future<void> _renderWidget(WidgetTester tester) async {
  return await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () async {
                PickerResult<TimeOfDay>? result = await showTimePickerDialog(
                  context: context,
                  initialTime: selectedTime,
                );
                if (result != null) {
                  selectedTime = result.value;
                }
              },
              child: const Text('Open Time Picker'),
            );
          },
        ),
      ),
    ),
  );
}
