import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/theme/color_scheme.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:flutter/material.dart';

class ColorSchemeCard extends StatefulWidget {
  const ColorSchemeCard({
    Key? key,
    required this.colorSchemeData,
    required this.onPressEdit,
    required this.isSelected,
  }) : super(key: key);

  final ColorSchemeData colorSchemeData;
  final VoidCallback onPressEdit;
  final bool isSelected;

  @override
  State<ColorSchemeCard> createState() => _ColorSchemeCardState();
}

class _ColorSchemeCardState extends State<ColorSchemeCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 0),
          child: Row(
            children: [
              if (widget.isSelected)
                Icon(Icons.check, color: colorScheme.primary),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.colorSchemeData.name,
                        style: textTheme.displaySmall),
                  ],
                ),
              ),
              const Spacer(),
              if (!widget.colorSchemeData.isDefault)
                IconButton(
                  onPressed: widget.onPressEdit,
                  icon: Icon(Icons.edit, color: colorScheme.primary),
                ),
            ],
          ),
        ),
        Theme(
          data: getThemeFromColorScheme(theme, widget.colorSchemeData),
          child: CardContainer(
            showShadow: false,
            showLightBorder: true,
            color: widget.colorSchemeData.background,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Background",
                      style: textTheme.headlineMedium?.copyWith(
                        color: widget.colorSchemeData.onBackground,
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
                                color: widget.colorSchemeData.onCard,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CardContainer(
                        color: widget.colorSchemeData.accent,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Accent",
                              style: textTheme.bodyMedium?.copyWith(
                                  color: widget.colorSchemeData.onAccent)),
                        ),
                      ),
                      CardContainer(
                        color: widget.colorSchemeData.error,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Error",
                              style: textTheme.bodyMedium?.copyWith(
                                  color: widget.colorSchemeData.onError)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
