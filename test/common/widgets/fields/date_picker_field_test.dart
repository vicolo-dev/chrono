import 'package:clock_app/common/widgets/fields/date_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const title = 'Test';
const hintText = 'TestHint';

void main() {
  group('DatePickerField', () {
    group('shows input field', () {
      testWidgets('title correctly', (tester) async {
        await _renderWidget(tester);
        final nameFinder = find.text(title);
        expect(nameFinder, findsOneWidget);
      });
      group('value correctly', () {
        testWidgets('with 1 date', (tester) async {
          final value = [DateTime(2021, 1, 1)];
          await _renderWidget(tester, value: value);
          final valueFinder = find.byKey(const Key("DateChip"));
          expect(valueFinder, findsOneWidget);
        });
        testWidgets('with 2 dates', (tester) async {
          final value = [DateTime(2021, 1, 1), DateTime(2021, 1, 2)];
          await _renderWidget(tester, value: value);
          final valueFinder = find.byKey(const Key("DateChip"));
          expect(valueFinder, findsNWidgets(2));
        });
        testWidgets('with 10 dates', (tester) async {
          final value = List.generate(10, (index) => DateTime(2021, 1, 1));
          await _renderWidget(tester, value: value);
          final valueFinder = find.byKey(const Key("DateChip"));
          expect(valueFinder, findsNWidgets(10));
        });
      });
    });
    group('shows bottom sheet', () {
      testWidgets("when tapped", (tester) async {
        await _renderWidget(tester);
        await tester.tap(find.byType(DatePickerField));
        await tester.pumpAndSettle();
        final bottomSheetFinder = find.byType(BottomSheet);
        expect(bottomSheetFinder, findsOneWidget);
      });
      // testWidgets('title correctly', (tester) async {
      //   await _renderWidget(tester);
      //   await tester.tap(find.byType(DatePickerField));
      //   await tester.pumpAndSettle();
      //   final titleFinder = find.descendant(
      //       of: find.byType(BottomSheet), matching: find.text(title));
      //   expect(titleFinder, findsOneWidget);
      // });
      // testWidgets('value correctly', (tester) async {
      //   final value = [DateTime(2021, 1, 1)];
      //   await _renderWidget(tester, value: value);
      //   await tester.tap(find.byType(DatePickerField));
      //   await tester.pumpAndSettle();
      //   final valueFinder = find.descendant(
      //       of: find.byType(BottomSheet), matching: find.byType(DateChip));
      //   expect(valueFinder, findsOneWidget);
      // });
      testWidgets('save button', (tester) async {
        await _renderWidget(tester);
        await tester.tap(find.byType(DatePickerField));
        await tester.pumpAndSettle();
        final saveButtonFinder = find.text("Save");
        expect(saveButtonFinder, findsOneWidget);
      });
    });
  });
}

Future<void> _renderWidget(WidgetTester tester,
    {List<DateTime> value = const [],
    void Function(List<DateTime>)? onChanged}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: DatePickerField(
          value: value,
          title: title,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    ),
  );
}
