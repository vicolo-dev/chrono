import 'package:clock_app/common/widgets/fields/switch_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const name = 'Test Switch';

void main() {
  group('SwitchField', () {
    testWidgets('shows name and switch', (WidgetTester tester) async {
      await _renderWidget(tester);

      expect(find.text(name), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    group("should toggle value", () {
      testWidgets('when field is tapped', (WidgetTester tester) async {
        bool switchValue = false;

        await _renderWidget(tester, value: switchValue,
            onChanged: (bool value) {
          switchValue = value;
        });

        expect(switchValue, false);

        await tester.tap(find.byType(InkWell));
        expect(switchValue, true);

        await _renderWidget(tester, value: switchValue,
            onChanged: (bool value) {
          switchValue = value;
        });

        await tester.tap(find.byType(InkWell));
        expect(switchValue, false);
      });

      testWidgets('when switch is tapped', (WidgetTester tester) async {
        bool switchValue = false;

        await _renderWidget(tester, value: switchValue,
            onChanged: (bool value) {
          switchValue = value;
        });

        expect(switchValue, false);

        await tester.tap(find.byType(Switch));
        expect(switchValue, true);

        await _renderWidget(tester, value: switchValue,
            onChanged: (bool value) {
          switchValue = value;
        });

        await tester.tap(find.byType(InkWell));
        expect(switchValue, false);
      });
    });
  });
}

void _defaultOnChanged(bool value) {}

Future<void> _renderWidget(WidgetTester tester,
    {value = false, void Function(bool) onChanged = _defaultOnChanged}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SwitchField(
          name: name,
          value: value,
          onChanged: onChanged,
        ),
      ),
    ),
  );
  //action
}
