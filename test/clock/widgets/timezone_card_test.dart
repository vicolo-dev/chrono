import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

bool deleted = false;
const testKey = Key('key');
var sampleCity = City("Tokyo", "Japan", "Asia/Tokyo");

void main() {
  group('TimeZoneCard', () {
    setUp(
      () async {
        timezone_db.initializeTimeZones();
      },
    );

    testWidgets(
      'shows city name correctly',
      (tester) async {
        await _renderWidget(tester);
        expect(find.text(sampleCity.name), findsOneWidget);
      },
    );
  });
}

Future<void> _renderWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: defaultTheme,
      home: TimeZoneCard(
        city: sampleCity,
        key: testKey,
        onDelete: (){},
      ),
    ),
  );
  //action
}
