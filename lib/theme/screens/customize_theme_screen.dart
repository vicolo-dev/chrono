import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/customize_screen.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/theme/types/theme_item.dart';
import 'package:clock_app/theme/widgets/theme_preview_card.dart';
import 'package:flutter/material.dart';

class CustomizeThemeScreen<Item extends ThemeItem> extends StatefulWidget {
  const CustomizeThemeScreen({
    super.key,
    required this.themeItem,
    required this.getThemeFromItem,
  });

  final Item themeItem;
  final ThemeData Function(ThemeData, Item) getThemeFromItem;

  @override
  State<CustomizeThemeScreen> createState() =>
      _CustomizeThemeScreenState<Item>();
}

class _CustomizeThemeScreenState<Item extends ThemeItem>
    extends State<CustomizeThemeScreen<Item>> {
  // late ThemeData? itemThemeData =
  //     widget.getThemeFromItem(theme, widget.themeItem);

  @override
  Widget build(BuildContext context) {
    return CustomizeScreen(
      item: widget.themeItem,
      builder: (context, themeItem) {
        ThemeData theme = Theme.of(context);

        ThemeData themeData = widget.getThemeFromItem(theme, themeItem);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CardContainer(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child:
                          Text("Preview", style: theme.textTheme.titleMedium),
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
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ...getSettingWidgets(
                        themeItem.settings.settingItems,
                        checkDependentEnableConditions: () {
                          setState(() {});
                        },
                        onSettingChanged: () {
                          setState(() {});
                        },
                        isAppSettings: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
