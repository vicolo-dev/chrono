import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/theme_item.dart';
import 'package:clock_app/theme/widgets/theme_preview_card.dart';
import 'package:flutter/material.dart';

class CustomizeThemeSettingsScreen<Item extends ThemeItem>
    extends StatefulWidget {
  const CustomizeThemeSettingsScreen({
    super.key,
    required this.themeItem,
    this.onSettingsChanged,
    required this.getThemeFromItem,
  });

  final Item themeItem;
  final void Function()? onSettingsChanged;
  final ThemeData Function(ThemeData, Item) getThemeFromItem;

  @override
  State<CustomizeThemeSettingsScreen> createState() =>
      _CustomizeThemeSettingsScreenState<Item>();
}

class _CustomizeThemeSettingsScreenState<Item extends ThemeItem>
    extends State<CustomizeThemeSettingsScreen<Item>> {

  late ThemeData themeData = widget.getThemeFromItem(theme, widget.themeItem);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppTopBar(actions: [
        TextButton(
            onPressed: () {
              widget.onSettingsChanged?.call();
              Navigator.pop(context);
            },
            child: const Text("Save"))
      ]),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ...getSettingWidgets(
                  widget.themeItem.settings.settingItems,
                  checkDependentEnableConditions: () {
                    setState(() {});
                  },
                  onChanged: () {
                    setState(() {
                      themeData =
                          widget.getThemeFromItem(theme, widget.themeItem);
                    });
                  },
                  isAppSettings: false,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CardContainer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Preview", style: theme.textTheme.titleMedium),
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
        )
      ]),
    );
  }
}
