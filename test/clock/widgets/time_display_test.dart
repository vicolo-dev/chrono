import 'package:clock_app/common/widgets/clock/time_display.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('TimeDisplay shows time correctly ...', (tester) async {
    DateTime dateTime = DateTime.now();
    String format = "hh:mm";
    await tester.pumpWidget(MaterialApp(
      theme: defaultTheme,
      home: TimeDisplay(format: format, fontSize: 32, dateTime: dateTime),
    ));

    expect(find.text(DateFormat(format).format(dateTime)), findsOneWidget);
  });
}
