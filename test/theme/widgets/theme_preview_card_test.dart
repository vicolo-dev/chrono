import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/widgets/theme_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const testKey = Key('key');
var defaultColorScheme = defaultTheme.colorScheme;

void main() {
  group('ThemePreviewCard', () {
    setUp(
      () async {},
    );

    themeTestGroup("Preview", defaultColorScheme.onBackground,
        defaultColorScheme.background);

    themeTestGroup(
        "Card", defaultColorScheme.onSurface, defaultColorScheme.surface);

    themeTestGroup(
        "Accent", defaultColorScheme.onPrimary, defaultColorScheme.primary);

    themeTestGroup(
        "Error", defaultColorScheme.onError, defaultColorScheme.error);
  });
}

void themeTestGroup(String name, Color textColor, Color backgroundColor) {
  group(
    'shows ${name.toLowerCase()}',
    () {
      testWidgets(
        'text correctly',
        (tester) async {
          await _renderStyleThemeCard(tester);

          expect(find.text(name), findsOneWidget);
        },
      );

      testWidgets(
        'text color correctly',
        (tester) async {
          await _renderStyleThemeCard(tester);

          expect((tester.firstWidget(find.text(name)) as Text).style!.color,
              textColor);
        },
      );

      testWidgets(
        'background color correctly',
        (tester) async {
          await _renderStyleThemeCard(tester);

          expect(
              (tester.firstWidget(find.byKey(Key("Preview Card - $name")))
                      as CardContainer)
                  .color,
              backgroundColor);
        },
      );
    },
  );
}

Future<void> _renderStyleThemeCard(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: defaultTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: ThemePreviewCard(
          key: testKey,
        ),
      ),
    ),
  );
  //action
}
