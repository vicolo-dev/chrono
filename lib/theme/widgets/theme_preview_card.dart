import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ThemePreviewCard extends StatelessWidget {
  const ThemePreviewCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Background",
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onBackground,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: CardContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Card",
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              CardContainer(
                color: colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Accent",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onPrimary)),
                ),
              ),
              CardContainer(
                color: colorScheme.error,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Error",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onError)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
