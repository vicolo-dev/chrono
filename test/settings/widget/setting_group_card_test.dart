// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:clock_app/settings/data/settings_data.dart';
import 'package:clock_app/settings/widgets/setting_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SettingGroupCard shows title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SettingGroupCard(settingGroup: settings[0]),
    ));

    expect(find.text('General'), findsOneWidget);
  });
}