import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SettingGroupCard extends StatelessWidget {
  final SettingGroup settingGroup;
  final Settings settings;
  final VoidCallback? checkDependentEnableConditions;
  final bool showExpandedView;

  // final VoidCallback onTap;

  const SettingGroupCard({
    Key? key,
    required this.settingGroup,
    required this.settings,
    this.checkDependentEnableConditions,
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
      })).then((value) => checkDependentEnableConditions?.call());
    }

    CardContainer showSummaryView = CardContainer(
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6),
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
              showSummaryView: true,
              checkDependentEnableConditions: checkDependentEnableConditions,
            )
          ],
        ),
      ),
    );

    CardContainer expandedView = CardContainer(
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
                  Hero(
                    tag: settingGroup.name,
                    child: Text(
                      settingGroup.name,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            ...getSettingWidgets(
              settings,
              settingItems: settingGroup.settingItems,
              showSummaryView: true,
              checkDependentEnableConditions: checkDependentEnableConditions,
            )
          ],
        ),
      ),
    );

    CardContainer cardView = CardContainer(
      onTap: openSettingGroupScreen,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(settingGroup.icon,
                color: Theme.of(context).colorScheme.onBackground),
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
            Icon(Icons.arrow_right,
                color: Theme.of(context).colorScheme.onBackground),
          ],
        ),
      ),
    );

    return showExpandedView
        ? expandedView
        : settingGroup.summarySettings.isNotEmpty
            ? showSummaryView
            : cardView;
  }
}
