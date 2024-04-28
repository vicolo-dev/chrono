import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/settings/utils/description.dart';
import 'package:flutter/material.dart';

class SettingPageLink extends SettingItem {
  final Widget screen;
  final IconData? icon;

  SettingPageLink(
    String name,
    String Function(BuildContext) getLocalizedName,
    this.screen, {
    String Function(BuildContext) getDescription = defaultDescription,
    this.icon,
    List<String> searchTags = const [],
    List<EnableConditionParameter> enableConditions = const [],
  }) : super(name, getLocalizedName, getDescription, searchTags,
            enableConditions);

  @override
  SettingPageLink copy() {
    return SettingPageLink(
      name,
      getLocalizedName,
      screen,
      icon: icon,
      getDescription: getDescription,
      searchTags: searchTags,
      enableConditions: enableConditions,
    );
  }

  @override
  dynamic valueToJson() {
    return null;
  }

  @override
  void loadValueFromJson(dynamic value) {
    return;
  }
}
