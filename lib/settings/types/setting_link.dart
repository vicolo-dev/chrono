import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class SettingPageLink extends SettingItem {
  final Widget screen;
  final IconData? icon;

  SettingPageLink(
    String name,
    this.screen, {
    String description = "",
    this.icon,
    List<String> searchTags = const [],
    List<EnableConditionParameter> enableConditions = const [],
  }) : super(name, description, searchTags, enableConditions);

  @override
  SettingPageLink copy() {
    return SettingPageLink(name, screen,
        icon: icon,
        description: description,
        searchTags: searchTags,
        enableConditions: enableConditions);
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
