import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/theme_item.dart';
import 'package:clock_app/theme/widgets/theme_preview_card.dart';
import 'package:flutter/material.dart';

class ThemeCard<Item extends ThemeItem> extends StatelessWidget {
  const ThemeCard({
    Key? key,
    required this.themeItem,
    required this.onPressEdit,
    required this.isSelected,
    required this.getThemeFromItem,
  }) : super(key: key);

  final Item themeItem;
  final VoidCallback onPressEdit;
  final bool isSelected;
  final ThemeData Function(ThemeData, Item) getThemeFromItem;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    ThemeData themeData = getThemeFromItem(theme, themeItem);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 4.0, bottom: 0),
          child: Row(
            children: [
              if (isSelected) Icon(Icons.check, color: colorScheme.primary),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(themeItem.name, style: textTheme.displaySmall),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: !themeItem.isDefault
                    ? onPressEdit
                    : () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                              alignment: Alignment.centerLeft,
                              height: 28,
                              child: const Text(
                                  "Default themes cannot be edited. You can duplicate the theme by swiping right on it."),
                            ),
                            margin: const EdgeInsets.only(
                                left: 20, right: 64 + 16, bottom: 12),
                            elevation: 2,
                            dismissDirection: DismissDirection.none,
                          ),
                        );
                      },
                icon: Icon(Icons.edit,
                    color: !themeItem.isDefault
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.5)),
              ),
            ],
          ),
        ),
        CardContainer(
          showShadow: false,
          showLightBorder: true,
          color: themeData.colorScheme.background,
          child: Theme(
            data: themeData,
            child: const ThemePreviewCard(),
          ),
        ),
      ],
    );
  }
}
