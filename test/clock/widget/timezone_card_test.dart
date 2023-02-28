import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/clock/logic/timezone_database.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:flutter_test/flutter_test.dart';

bool deleted = false;
const testKey = Key('key');

void main() {
  group('TimeZoneCard', () {
    setUp(
      () async {
        timezone_db.initializeTimeZones();
        await GetStorage.init();
        await initializeDatabases();
      },
    );

    testWidgets(
      'Show city name',
      (tester) async {
        var sampleCity = City("Tokyo", "Japan", "Asia/Tokyo");
        await renderWidget(tester);

        // The widget code uses `replaceAll` to work around flutter's
        // limitation of cutting entire words on overflow instead of
        // individual letters, so we do the same here
        expect(find.text(sampleCity.name.replaceAll('', '\u{200B}')),
            findsOneWidget);
      },
    );
    // testWidgets(
    //     'does not show delete button initially',
    //     (tester) async {
    //       await renderWidget(tester);
    //       expect(find.text("Delete"), findsNothing);
    //     },
    //   );

    //   testWidgets(
    //     'shows delete button on right swipe',
    //     (tester) async {
    //       await renderWidget(tester);

    //       await tester.drag(find.byKey(testKey), const Offset(500.0, 0.0));
    //       await tester.pumpAndSettle();
    //       expect(find.text("Delete"), findsOneWidget);
    //     },
    //   );
    //   testWidgets(
    //     'shows delete button on left swipe',
    //     (tester) async {
    //       await renderWidget(tester);

    //       await tester.drag(find.byKey(testKey), const Offset(-500.0, 0.0));
    //       await tester.pumpAndSettle();
    //       expect(find.text("Delete"), findsOneWidget);
    //     },
    //   );
    //   testWidgets(
    //     'calls the onDelete function on clicking delete button',
    //     (tester) async {
    //       deleted = false;
    //       await renderWidget(tester);

    //       await tester.drag(find.byKey(testKey), const Offset(500.0, 0.0));
    //       await tester.pumpAndSettle();
    //       await tester.tap(find.text("Delete"));
    //       await tester.pump();
    //       expect(deleted, equals(true));
    //     },
    //   );
  });
}

Future<void> renderWidget(WidgetTester tester) async {
  var sampleCity = City("Tokyo", "Japan", "Asia/Tokyo");
  await tester.pumpWidget(
    MaterialApp(
      home: TimeZoneCard(
        city: sampleCity,
        key: testKey,
      ),
    ),
  );
  //action
}
