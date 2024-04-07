import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/settings/widgets/color_setting_card.dart';
import 'package:clock_app/settings/widgets/custom_setting_card.dart';

import 'package:clock_app/settings/widgets/date_setting_card.dart';
import 'package:clock_app/settings/widgets/duration_setting_card.dart';
import 'package:clock_app/settings/widgets/dynamic_multi_select_setting_card.dart';
import 'package:clock_app/settings/widgets/dynamic_select_setting_card.dart';
import 'package:clock_app/settings/widgets/list_setting_card.dart';
import 'package:clock_app/settings/widgets/multi_select_setting_card.dart';
import 'package:clock_app/settings/widgets/select_setting_card.dart';
import 'package:clock_app/settings/widgets/setting_action_card.dart';
import 'package:clock_app/settings/widgets/setting_page_link_card.dart';
import 'package:clock_app/settings/widgets/setting_group_card.dart';
import 'package:clock_app/settings/widgets/slider_setting_card.dart';
import 'package:clock_app/settings/widgets/string_setting_card.dart';
import 'package:clock_app/settings/widgets/switch_setting_card.dart';
import 'package:clock_app/settings/widgets/toggle_setting_card.dart';
import 'package:flutter/material.dart';

List<Widget> getSettingWidgets(
  List<SettingItem> settingItems, {
  bool showAsCard = true,
  VoidCallback? checkDependentEnableConditions,
  VoidCallback? onSettingChanged,
  bool isAppSettings = true,
}) {
  bool showExtraAnimations = appSettings
      .getGroup("General")
      .getGroup("Animations")
      .getSetting("Extra Animations")
      .value;
  List<Widget> widgets = [];
  for (var item in settingItems) {
    Widget? widget = getSettingItemWidget(
      item,
      showAsCard: showAsCard,
      checkDependentEnableConditions: checkDependentEnableConditions,
      onSettingChanged: onSettingChanged,
      isAppSettings: isAppSettings,
    );
    if (widget != null) {
      if (showExtraAnimations) {
        widgets.add(AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: SizedBox(height: item.isEnabled ? null : 0, child: widget)));
      } else {
        widgets.add(widget);
      }
    }
  }
  return widgets;
}

Widget? getSettingItemWidget(
  SettingItem item, {
  bool showAsCard = false,
  VoidCallback? checkDependentEnableConditions,
  VoidCallback? onSettingChanged,
  bool isAppSettings = true,
}) {
  if (!item.isEnabled) return null;
  if (item is SettingGroup) {
    // print(
    //     "setting group ${item.name} ${item.isEnabled} ${item.enableSettings.map((e) => e.setting.name)}");
    return SettingGroupCard(
      settingGroup: item,
      checkDependentEnableConditions: checkDependentEnableConditions,
      onSettingChanged: onSettingChanged,
      isAppSettings: isAppSettings,
    );
  } else if (item is SettingPageLink) {
    return SettingPageLinkCard(
      setting: item,
      showAsCard: showAsCard,
    );
  } else if (item is SettingAction) {
    return SettingActionCard(
      setting: item,
      showAsCard: showAsCard,
    );
  } else if (item is Setting) {
    if (!item.isVisual) return null;

    onChanged(dynamic value) {
      // If any other item depend on this one, we should update
      // state when this one changes
      if (item.changesEnableCondition) {
        checkDependentEnableConditions?.call();
      }
      onSettingChanged?.call();
    }

    if (item is SelectSetting) {
      return SelectSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    }
    if (item is DynamicSelectSetting) {
      return DynamicSelectSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    }
    if (item is MultiSelectSetting) {
      return MultiSelectSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    }
    if (item is DynamicMultiSelectSetting) {
      return DynamicMultiSelectSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else if (item is SwitchSetting) {
      return SwitchSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else if (item is ToggleSetting) {
      return ToggleSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else if (item is SliderSetting) {
      return SliderSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else if (item is StringSetting) {
      return StringSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else if (item is DurationSetting) {
      return DurationSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else if (item is DateTimeSetting) {
      return DateSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else if (item is ColorSetting) {
      return ColorSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else if (item is CustomSetting) {
      return CustomSettingCard(
        setting: item,
        showAsCard: showAsCard,
      );
    } else if (item is ListSetting) {
      return ListSettingCard(
        setting: item,
        showAsCard: showAsCard,
        onChanged: onChanged,
      );
    } else {
      throw Exception('No widget for setting type: ${item.runtimeType}');
    }
  }

  return null;
}
