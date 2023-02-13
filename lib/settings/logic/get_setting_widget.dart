import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/settings/widgets/select_setting_card.dart';
import 'package:clock_app/settings/widgets/setting_group_card.dart';
import 'package:clock_app/settings/widgets/slider_setting_card.dart';
import 'package:clock_app/settings/widgets/switch_setting_card.dart';
import 'package:clock_app/settings/widgets/toggle_setting_card.dart';
import 'package:flutter/material.dart';

bool defaultFilter(SettingItem setting) {
  return true;
}

List<Widget> getSettingWidgets(
  Settings settings, {
  List<SettingItem>? settingItems,
  bool summaryView = false,
  bool showExpandedView = false,
  VoidCallback? onChanged,
}) {
  List<SettingItem> items = settingItems ?? settings.items;

  List<Widget> widgets = [];
  for (var item in items) {
    Widget? widget = getSettingWidget(
      settings,
      item,
      summaryView: summaryView,
      onChanged: onChanged,
      showExpandedView: showExpandedView,
    );
    if (widget != null) {
      widgets.add(widget);
    }
  }
  return widgets;
}

Widget? getSettingWidget(
  Settings settings,
  SettingItem item, {
  bool summaryView = false,
  bool showExpandedView = false,
  VoidCallback? onChanged,
}) {
  if (item is SettingGroup) {
    return SettingGroupCard(
      settings: settings,
      settingGroup: item,
      onChanged: onChanged,
      showExpandedView: showExpandedView,
    );
  } else if (item is Setting) {
    if (item.enableConditions.isNotEmpty) {
      bool enabled = true;
      for (var condition in item.enableConditions) {
        Setting setting = settings.getSetting(condition.settingName);
        if (setting.value != condition.value) {
          enabled = false;
          break;
        }
      }
      if (!enabled) {
        return null;
      }
    }

    bool changesEnableConditions = settings.settings.any((setting) => setting
        .enableConditions
        .any((condition) => condition.settingName == item.name));

    onChanged = changesEnableConditions ? onChanged : null;

    if (item is SelectSetting) {
      return SelectSettingCard(
        setting: item,
        summaryView: summaryView,
        onChanged: onChanged,
      );
    } else if (item is SwitchSetting) {
      return SwitchSettingCard(
        setting: item,
        summaryView: summaryView,
        onChanged: onChanged,
      );
    } else if (item is ToggleSetting) {
      return ToggleSettingCard(
        setting: item,
        summaryView: summaryView,
        onChanged: onChanged,
      );
    } else if (item is SliderSetting) {
      return SliderSettingCard(
        setting: item,
        summaryView: summaryView,
        onChanged: onChanged,
      );
    }
  }

  return null;
}
