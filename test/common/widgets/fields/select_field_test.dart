import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/fields/input_field.dart';
import 'package:clock_app/common/widgets/fields/select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const title = 'Test';
const choices = [
  SelectTextChoice(title: "Test1", description: "Test1Description"),
  SelectTextChoice(title: "Test2", description: "Test2Description"),
  SelectTextChoice(title: "Test3", description: "Test3Description"),
];

void main() {
  group('SelectField Widget', () {
    group('shows select field', () {
      testWidgets('title correctly', (tester) async {
        await _renderWidget(tester);
        final nameFinder = find.text(title);
        expect(nameFinder, findsOneWidget);
      });
      testWidgets('value correctly', (tester) async {
        const selectedIndex = 0;
        await _renderWidget(tester, selectedIndex: selectedIndex);
        final valueFinder = find.text(choices[selectedIndex].title);
        expect(valueFinder, findsOneWidget);
      });
    });
    group('shows bottom sheet', () {
      testWidgets("when tapped", (tester) async {
        await _renderWidget(tester);
        await tester.tap(find.byType(SelectField));
        await tester.pumpAndSettle();
        final bottomSheetFinder = find.byType(BottomSheet);
        expect(bottomSheetFinder, findsOneWidget);
      });
      testWidgets('title correctly', (tester) async {
        await _renderWidget(tester);
        await tester.tap(find.byType(SelectField));
        await tester.pumpAndSettle();
        final titleFinder = find.descendant(
            of: find.byType(BottomSheet), matching: find.text(title));
        expect(titleFinder, findsOneWidget);
      });
      group('choices', () {
        testWidgets('title correctly', (tester) async {
          await _renderWidget(tester);
          await tester.tap(find.byType(SelectField));
          await tester.pumpAndSettle();
          for (var i = 0; i < choices.length; i++) {
            final valueFinder = find.descendant(
                of: find.byType(BottomSheet),
                matching: find.text(choices[i].title));
            expect(valueFinder, findsOneWidget);
          }
        });
        testWidgets('description correctly', (tester) async {
          await _renderWidget(
            tester,
          );
          await tester.tap(find.byType(SelectField));
          await tester.pumpAndSettle();
          for (var i = 0; i < choices.length; i++) {
            final valueFinder = find.descendant(
                of: find.byType(BottomSheet),
                matching: find.text(choices[i].description));
            expect(valueFinder, findsOneWidget);
          }
        });
      });
    });
  });
}

Future<void> _renderWidget(WidgetTester tester,
    {int selectedIndex = 0, void Function(int)? onChanged}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SelectField(
          selectedIndex: selectedIndex,
          title: title,
          choices: choices,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    ),
  );
}
