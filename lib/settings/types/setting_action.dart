import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class SettingAction extends SettingItem {
  void Function(BuildContext context) action;

  SettingAction(
    String name,
    this.action, {
    String description = "",
    List<String> searchTags = const [],
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, searchTags, enableConditions);

  @override
  SettingAction copy() {
    return SettingAction(name, action,
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
