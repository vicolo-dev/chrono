// ignore_for_file: prefer_const_constructors

import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/settings/widgets/settings_top_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<SettingItem> searchedItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    List<Widget> getSearchItemWidgets() {
      return searchedItems.map((item) {
        String pathString = item.path.fold("", (previousValue, group) {
          return "$previousValue${previousValue.isNotEmpty ? " > " : ""}${group.name}";
        });
        Widget settingWidget =
            getSettingWidget(appSettings, item, showSummaryView: true) ??
                Container();
        return CardContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SettingGroupScreen(
                        settingsGroup: item.parent!,
                        settings: appSettings,
                      );
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            pathString,
                            style: textTheme.titleSmall?.copyWith(
                                color:
                                    colorScheme.onBackground.withOpacity(0.6)),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
                settingWidget
                // Text(
                //   item.name,
                //   style: textTheme.displaySmall,
                // ),
                // const Spacer(),
              ],
            ),
          ),
        );
      }).toList();
    }

    return Scaffold(
      appBar: SettingsTopBar(
        onSearch: (settingItems) {
          setState(() {
            searchedItems = settingItems;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: searchedItems.isEmpty
                ? [
                    ...getSettingWidgets(
                      appSettings,
                      onSettingChanged: () {
                        appSettings.save("settings");
                      },
                    ),
                    const SizedBox(height: 16),
                  ]
                : [
                    ...getSearchItemWidgets(),
                    const SizedBox(height: 16),
                  ],
          ),
        ),
      ),
    );
  }
}
