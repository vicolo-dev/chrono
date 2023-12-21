import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class SettingGroupCard extends StatefulWidget {
  final SettingGroup settingGroup;
  final VoidCallback? checkDependentEnableConditions;
  final VoidCallback? onSettingChanged;
  final bool isAppSettings;

  const SettingGroupCard({
    Key? key,
    required this.settingGroup,
    this.checkDependentEnableConditions,
    this.onSettingChanged,
    this.isAppSettings = true,
  }) : super(key: key);

  @override
  State<SettingGroupCard> createState() => _SettingGroupCardState();
}

class _SettingGroupCardState extends State<SettingGroupCard> {
  List<SettingItem> searchedItems = [];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    if (widget.settingGroup.isEmpty) return const SizedBox();

    bool showSummaryView = widget.settingGroup.summarySettings.isNotEmpty;
    bool showExpandedView = (widget.settingGroup.showExpandedView ??
            widget.settingGroup.settingGroups.isEmpty) ||
        showSummaryView;

    void openSettingGroupScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SettingGroupScreen(
          settingGroup: widget.settingGroup,
          isAppSettings: widget.isAppSettings,
        );
      })).then((value) => widget.checkDependentEnableConditions?.call());
    }

    List<SettingItem> settingItems = showSummaryView
        ? widget.settingGroup.settings
            .where((setting) =>
                widget.settingGroup.summarySettings.contains(setting.name))
            .toList()
        : widget.settingGroup.settingItems;

    CardContainer expandedView = CardContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingGroupHeader(
              isAppSettings: widget.isAppSettings,
              settingGroup: widget.settingGroup,
              showSummaryView: showSummaryView,
              onTap: openSettingGroupScreen,
            ),
            ...getSettingWidgets(
              settingItems,
              showAsCard: false,
              checkDependentEnableConditions:
                  widget.checkDependentEnableConditions,
              onSettingChanged: widget.onSettingChanged,
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
            Icon(widget.settingGroup.icon, color: colorScheme.onBackground),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.settingGroup.name,
                    style: textTheme.displaySmall,
                  ),
                  if (widget.settingGroup.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.settingGroup.description,
                      style: textTheme.bodyMedium,
                    )
                  ]
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onBackground.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );

    return showExpandedView ? expandedView : cardView;
  }
}

class SettingGroupHeader extends StatelessWidget {
  const SettingGroupHeader({
    super.key,
    required this.isAppSettings,
    required this.settingGroup,
    this.onTap,
    required this.showSummaryView,
  });

  final bool isAppSettings;
  final SettingGroup settingGroup;
  final VoidCallback? onTap;
  final bool showSummaryView;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAppSettings || showSummaryView ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                settingGroup.name,
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  if (showSummaryView)
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        "More",
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  if (isAppSettings || showSummaryView)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.primary,
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
