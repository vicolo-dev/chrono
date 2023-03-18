import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_search_card.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

var sampleCity = City("Tokyo", "Japan", "Asia/Tokyo");

void main() {
  group('TimeZoneSearchCard', () {
    setUp(
      () async {
        timezone_db.initializeTimeZones();
      },
    );
    testWidgets(
      'shows city name correctly',
      (tester) async {
        await renderWidget(tester);

        // The widget code uses `replaceAll` to work around flutter's
        // limitation of cutting entire words on overflow instead of
        // individual letters, so we do the same here
        expect(find.text(sampleCity.name.replaceAll('', '\u{200B}')),
            findsOneWidget);
      },
    );
    testWidgets(
      'shows country name correctly',
      (tester) async {
        await renderWidget(tester);

        expect(find.text(sampleCity.country), findsOneWidget);
      },
    );
  });
}

Future<void> renderWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: defaultTheme,
      home: TimeZoneSearchCard(
        city: sampleCity,
        onTap: () {},
      ),
    ),
  );
}
