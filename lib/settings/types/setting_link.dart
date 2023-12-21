import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class SettingPageLink extends SettingItem {
  Widget screen;

  SettingPageLink(
    String name,
    this.screen, {
    String description = "",
    List<String> searchTags = const [],
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, searchTags, enableConditions);

  @override
  SettingPageLink copy() {
    return SettingPageLink(name, screen,
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
