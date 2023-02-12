import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SettingGroupCard extends StatelessWidget {
  final SettingGroup settingGroup;
  final Settings settings;
  final VoidCallback? onChanged;
  final bool showExpandedView;

  // final VoidCallback onTap;

  const SettingGroupCard({
    Key? key,
    required this.settingGroup,
    required this.settings,
    this.onChanged,
    this.showExpandedView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void openSettingGroupScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SettingGroupScreen(
          settingsGroup: settingGroup,
          settings: settings,
        );
      })).then((value) => onChanged?.call());
    }

    Card summaryView = Card(
      child: InkWell(
        onTap: openSettingGroupScreen,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      settingGroup.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorTheme.textColorSecondary,
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: ColorTheme.textColorTertiary,
                    )
                  ],
                ),
              ),
              ...getSettingWidgets(
                settings,
                settingItems: settingGroup.settings
                    .where((setting) =>
                        settingGroup.summarySettings.contains(setting.name))
                    .toList(),
                summaryView: true,
                onChanged: onChanged,
              )
            ],
          ),
        ),
      ),
    );

    Card expandedView = Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    settingGroup.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorTheme.textColorSecondary,
                        ),
                  ),
                ],
              ),
            ),
            ...getSettingWidgets(
              settings,
              settingItems: settingGroup.settingItems,
              summaryView: true,
              onChanged: onChanged,
            )
          ],
        ),
      ),
    );

    Card cardView = Card(
      child: InkWell(
        onTap: openSettingGroupScreen,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        // onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(settingGroup.icon, color: ColorTheme.textColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settingGroup.name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 4),
                    if (settingGroup.description.isNotEmpty)
                      Text(
                        settingGroup.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                  ],
                ),
              ),
              const Icon(Icons.arrow_right, color: ColorTheme.textColor),
            ],
          ),
        ),
      ),
    );

    return showExpandedView
        ? expandedView
        : settingGroup.summarySettings.isNotEmpty
            ? summaryView
            : cardView;
  }
}
