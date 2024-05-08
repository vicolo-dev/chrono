import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_search_card.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        await _renderWidget(tester);
        expect(find.text(sampleCity.name), findsOneWidget);
      },
    );
    testWidgets(
      'shows country name correctly',
      (tester) async {
        await _renderWidget(tester);

        expect(find.text(sampleCity.country), findsOneWidget);
      },
    );
  });
}

Future<void> _renderWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: defaultTheme,
      home: TimeZoneSearchCard(
        city: sampleCity,
        onTap: () {},
      ),
    ),
  );
}
