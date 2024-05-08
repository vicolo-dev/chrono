import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clock_app/common/widgets/fields/toggle_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const List<ToggleOption<int>> testOptions = [
  ToggleOption('Option 1', 1),
  ToggleOption('Option 2', 2),
  ToggleOption('Option 3', 3),
];

void main() {
  group('ToggleField', () {
    testWidgets('shows name and options', (WidgetTester tester) async {
      await _renderWidget(tester);

      expect(find.text('Test Field'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });

    testWidgets('toggles selection when pressed', (WidgetTester tester) async {
      final selectedItems = [false, false, false];
      await _renderWidget(tester, selectedItems: selectedItems,
          onChange: (index) {
        selectedItems[index] = !selectedItems[index];
      });

      await tester.tap(find.text('Option 1'));
      expect(selectedItems, [true, false, false]);

      await _renderWidget(tester, selectedItems: selectedItems,
          onChange: (index) {
        selectedItems[index] = !selectedItems[index];
      });

      await tester.tap(find.text('Option 3'));
      expect(selectedItems, [true, false, true]);

      await _renderWidget(tester, selectedItems: selectedItems,
          onChange: (index) {
        selectedItems[index] = !selectedItems[index];
      });

      await tester.tap(find.text('Option 2'));
      expect(selectedItems, [true, true, true]);
    });
  });
}

Future<void> _renderWidget(WidgetTester tester,
    {String? name,
    List<bool>? selectedItems,
    String? description,
    List<ToggleOption<int>>? options,
    void Function(int)? onChange}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ToggleField<int>(
          name: name ?? 'Test Field',
          selectedItems: selectedItems ?? [false, false, false],
          description: description,
          options: options ?? testOptions,
          onChange: onChange ?? (int index) {},
        ),
      ),
    ),
  );
}
