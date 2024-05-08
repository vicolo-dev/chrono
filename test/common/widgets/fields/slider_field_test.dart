import 'package:clock_app/common/widgets/fields/slider_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const name = 'Test Slider';
const unit = 'unit';

void main() {
  group('SliderField', () {
    testWidgets('shows name correctly', (tester) async {
      await _renderWidget(tester);
      final nameFinder = find.text(name);
      expect(nameFinder, findsOneWidget);
    });

    testWidgets('shows value and unit correctly', (tester) async {
      const value = 50.0;
      await _renderWidget(tester, value: value);
      final valueFinder = find.text(value.toStringAsFixed(1));
      expect(valueFinder, findsOneWidget);
    });

    testWidgets('should call onChanged when slider is dragged', (tester) async {
      double value = 0.0;
      double originalValue = value;
      await _renderWidget(tester, value: value, onChanged: (newValue) {
        value = newValue;
      });

      await tester.drag(find.byType(Slider), const Offset(100.0, 0.0));
      expect(value, greaterThan(originalValue));
    });
  });
}

Future<void> _renderWidget(WidgetTester tester,
    {double value = 0, void Function(double)? onChanged}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SliderField(
          value: value,
          min: 0,
          max: 100,
          title: name,
          unit: unit,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    ),
  );
}
