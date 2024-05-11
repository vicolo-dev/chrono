import 'package:clock_app/common/logic/card_decoration.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemePreviewCard extends StatelessWidget {
  const ThemePreviewCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;
    return CardContainer(
      key: const Key("Preview Card - Preview"),
      showShadow: false,
      showLightBorder: true,
      color: colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.previewLabel,
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                children: [
                  CardContainer(
                    color: getCardColor(context),
                    key: const Key("Preview Card - Card"),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(context)!.cardLabel,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  CardContainer(
                    key: const Key("Preview Card - Accent"),
                    color: colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(AppLocalizations.of(context)!.accentLabel,
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onPrimary)),
                    ),
                  ),
                  CardContainer(
                    key: const Key("Preview Card - Error"),
                    color: colorScheme.error,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(AppLocalizations.of(context)!.errorLabel,
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onError)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
