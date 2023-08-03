// ignore_for_file: prefer_const_constructors

import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/screens/restore_defaults_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/settings/types/setting_link.dart';

import 'package:clock_app/settings/widgets/search_setting_card.dart';
import 'package:clock_app/settings/widgets/setting_page_link_card.dart';
import 'package:clock_app/settings/widgets/settings_top_bar.dart';
import 'package:flutter/material.dart';

class SettingGroupScreen extends StatefulWidget {
  const SettingGroupScreen(
      {super.key, required this.settingGroup, this.isAppSettings = true});

  final SettingGroup settingGroup;
  final bool isAppSettings;

  @override
  State<SettingGroupScreen> createState() => _SettingGroupScreenState();
}

class _SettingGroupScreenState extends State<SettingGroupScreen> {
  List<SettingItem> searchedItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getSearchItemWidgets() {
      return searchedItems.map((item) {
        return SearchSettingCard(settingItem: item);
      }).toList();
    }

    return Scaffold(
      appBar: SettingsTopBar(
        onSearch: (settingItems) {
          setState(() {
            searchedItems = settingItems;
          });
        },
        showSearch: widget.settingGroup.isSearchable,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: searchedItems.isEmpty
                ? [
                    ...getSettingWidgets(
                      widget.settingGroup.settingItems,
                      checkDependentEnableConditions: () => setState(() {}),
                      onSettingChanged: () {
                        if (widget.isAppSettings) {
                          appSettings.save();
                        }
                      },
                      isAppSettings: widget.isAppSettings,
                    ),
                    if (widget.isAppSettings)
                      SettingPageLinkCard(
                          setting: SettingPageLink(
                              'Restore default values',
                              RestoreDefaultScreen(
                                settingGroup: widget.settingGroup,
                                onRestore: () async {
                                  await appSettings.save();
                                  setState(() {});
                                },
                              ))),
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
