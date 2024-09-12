import 'package:clock_app/common/widgets/list/static_list_view.dart';
import 'package:clock_app/navigation/widgets/search_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/screens/restore_defaults_screen.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clock_app/settings/widgets/search_setting_card.dart';
import 'package:clock_app/settings/widgets/setting_page_link_card.dart';
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
  List<SettingItem> _searchedItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    List<Widget> getSearchItemWidgets() {
      return _searchedItems.map((item) {
        return SearchSettingCard(settingItem: item);
      }).toList();
    }

    return Scaffold(
      appBar: SearchTopBar(
        title: widget.settingGroup.displayName(context),
        searchParams: widget.settingGroup.isSearchable
            ? SearchParams(
                onSearch: (settingItems) {
                  setState(() {
                    _searchedItems = settingItems;
                  });
                },
                placeholder: localizations.searchSettingPlaceholder,
                choices: [
                  ...appSettings.settings,
                  ...appSettings.settingPageLinks,
                  ...appSettings.settingActions
                ],
                searchTermGetter: (item) {
                  // Search term includes the setting name, as well as the parent group names and the tags
                  return "${item.name} ${item.path.map((group) => group.name).join(" ")} ${item.searchTags.join(" ")}";
                },
              )
            : null,
        // showSearch: widget.settingGroup.isSearchable,
      ),
      body: StaticListView(
        children: _searchedItems.isEmpty
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
                          'restore_default_values',
                          (context) => localizations.restoreSettingGroup,
                          RestoreDefaultScreen(
                            settingGroup: widget.settingGroup,
                            onRestore: () async {
                              await appSettings.save();
                              setState(() {});
                            },
                          ))),
              ]
            : getSearchItemWidgets(),
      ),
    );
  }
}
