import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class SearchSettingCard extends StatelessWidget {
  const SearchSettingCard({
    super.key,
    required this.settingItem,
  });

  final SettingItem settingItem;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    String pathString =
        settingItem.path.sublist(1).fold("", (previousValue, group) {
      return "$previousValue${previousValue.isNotEmpty ? " > " : ""}${group.name}";
    });
    Widget settingWidget =
        getSettingItemWidget(settingItem, showAsCard: false) ?? Container();

    return CardContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingGroupScreen(
                    settingGroup: settingItem.parent!,
                    isAppSettings: true,
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
                            color: colorScheme.onBackground.withOpacity(0.6)),
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
          ],
        ),
      ),
    );
  }
}
