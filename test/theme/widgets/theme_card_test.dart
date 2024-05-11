import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:clock_app/theme/utils/style_theme.dart';
import 'package:clock_app/theme/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const testKey = Key('key');
var sampleStyleTheme = StyleTheme();
var sampleColorScheme = ColorSchemeData();

void main() {
  group('ThemeCard', () {
    setUp(
      () async {},
    );

    testWidgets(
      'shows theme name correctly',
      (tester) async {
        await _renderStyleThemeCard(tester);

        expect(find.text(sampleStyleTheme.name), findsOneWidget);
      },
    );

    testWidgets(
      'shows menu icon',
      (tester) async {
        await _renderStyleThemeCard(tester);

        expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'shows edit icon',
      (tester) async {
        await _renderStyleThemeCard(tester);

        expect(find.byIcon(Icons.edit), findsOneWidget);
      },
    );

    group(
      'shows tick mark correctly',
      () {
        testWidgets(
          'when not selected',
          (tester) async {
            await _renderStyleThemeCard(tester);

            expect(find.byIcon(Icons.check), findsNothing);
          },
        );

        testWidgets(
          'when selected',
          (tester) async {
            await _renderStyleThemeCard(tester, isSelected: true);

            expect(find.byIcon(Icons.check), findsOneWidget);
          },
        );
      },
    );
  });
}

Future<void> _renderStyleThemeCard(WidgetTester tester,
    {bool isSelected = false}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: defaultTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ThemeCard(
          themeItem: sampleStyleTheme,
          isSelected: isSelected,
          onPressDelete: () {},
          onPressDuplicate: () {},
          onPressEdit: () {},
          getThemeFromItem: (theme, item) =>
              getTheme(colorScheme: theme.colorScheme, styleTheme: item),
          key: testKey,
        ),
      ),
    ),
  );
  //action
}
