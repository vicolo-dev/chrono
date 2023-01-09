import 'package:clock_app/clock/data/timezone_database.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_search_card.dart';
import 'package:clock_app/settings/logic/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

import 'package:timezone/timezone.dart' as timezone;

void main() {
  testWidgets('timeZoneSearchCard shows correctly', (tester) async {
    //setup
    timezone_db.initializeTimeZones();
    await initializeDatabases();
    Settings.initialize();

    const sampleCity = City("New York", "United States", "America/New_York");
    final timezoneLocation = timezone.getLocation(sampleCity.timezone);

    DateTime now = timezone.TZDateTime.now(timezoneLocation);
    String formattedTime = DateFormat('h:mm').format(now);

    await tester.pumpWidget(TimeZoneSearchCard(
      city: sampleCity,
      onTap: () {},
    ));
    //action

    //assert
    expect(find.text(sampleCity.name), findsOneWidget);
    expect(find.text(sampleCity.country), findsOneWidget);
    expect(find.text(formattedTime), findsOneWidget);
  });
}
