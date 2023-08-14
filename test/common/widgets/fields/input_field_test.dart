import 'package:clock_app/common/widgets/fields/input_field.dart';
import 'package:clock_app/common/widgets/fields/slider_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const title = 'Test';
const hintText = 'TestHint';

void main() {
  group('InputField', () {
    group('shows input field', () {
      testWidgets('title correctly', (tester) async {
        await _renderWidget(tester);
        final nameFinder = find.text(title);
        expect(nameFinder, findsOneWidget);
      });
      group('value correctly', () {
        testWidgets('value correctly', (tester) async {
          const value = "TestValue";
          await _renderWidget(tester, value: value);
          final valueFinder = find.text(value);
          expect(valueFinder, findsOneWidget);
        });
        testWidgets('after value changed', (tester) async {
          String value = "TestValue";
          const newValue = "NewTestValue";
          await _renderWidget(tester, value: value, onChanged: (val) {
            value = val;
          });
          await tester.tap(find.byType(InputField));
          await tester.pumpAndSettle();
          final fieldFinder = find.descendant(
              of: find.byType(BottomSheet), matching: find.byType(TextField));
          expect(fieldFinder, findsOneWidget);
          await tester.enterText(fieldFinder, newValue);
          await tester.pumpAndSettle();
          await tester.tap(find.text("Save"));
          await tester.pumpAndSettle();
          await _renderWidget(tester, value: value, onChanged: (val) {
            value = val;
          });
          expect(find.text(newValue), findsOneWidget);
          expect(value, newValue);
        });
      });
    });

    testWidgets('hint text correctly', (tester) async {
      const hintText = "TestHint";
      await _renderWidget(tester);
      final hintTextFinder = find.text(hintText);
      expect(hintTextFinder, findsOneWidget);
    });
  });
  group('shows bottom sheet', () {
    testWidgets("when tapped", (tester) async {
      await _renderWidget(tester);
      await tester.tap(find.byType(InputField));
      await tester.pumpAndSettle();
      final bottomSheetFinder = find.byType(BottomSheet);
      expect(bottomSheetFinder, findsOneWidget);
    });
    testWidgets('title correctly', (tester) async {
      await _renderWidget(tester);
      await tester.tap(find.byType(InputField));
      await tester.pumpAndSettle();
      final titleFinder = find.descendant(
          of: find.byType(BottomSheet), matching: find.text(title));
      expect(titleFinder, findsOneWidget);
    });
    group('value correctly', () {
      testWidgets('before value changed', (tester) async {
        const value = "TestValue";
        await _renderWidget(tester, value: value);
        await tester.tap(find.byType(InputField));
        await tester.pumpAndSettle();
        final valueFinder = find.descendant(
            of: find.byType(BottomSheet), matching: find.text(value));
        expect(valueFinder, findsOneWidget);
      });
      testWidgets('after value changed', (tester) async {
        const value = "TestValue";
        const newValue = "NewTestValue";
        await _renderWidget(tester, value: value);
        await tester.tap(find.byType(InputField));
        await tester.pumpAndSettle();
        final fieldFinder = find.descendant(
            of: find.byType(BottomSheet), matching: find.byType(TextField));
        expect(fieldFinder, findsOneWidget);
        await tester.enterText(fieldFinder, newValue);
        await tester.pumpAndSettle();
        final newValueFinder = find.descendant(
            of: find.byType(BottomSheet), matching: find.text(newValue));
        expect(newValueFinder, findsOneWidget);
      });
    });

    testWidgets('save button', (tester) async {
      await _renderWidget(tester);
      await tester.tap(find.byType(InputField));
      await tester.pumpAndSettle();
      final saveButtonFinder = find.text("Save");
      expect(saveButtonFinder, findsOneWidget);
    });
  });
}

Future<void> _renderWidget(WidgetTester tester,
    {String value = "", void Function(String)? onChanged}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: InputField(
          value: value,
          title: title,
          hintText: hintText,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    ),
  );
}
