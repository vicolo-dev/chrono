import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/settings/utils/description.dart';
import 'package:flutter/material.dart';

class SettingAction extends SettingItem {
  void Function(BuildContext context) action;

  SettingAction(
    String name,
    String Function(BuildContext) getLocalizedName,
    this.action, {
    String Function(BuildContext) getDescription = defaultDescription,
    List<String> searchTags = const [],
    List<EnableConditionParameter> enableConditions = const [],
  }) : super(name, getLocalizedName, getDescription, searchTags, enableConditions);

  @override
  SettingAction copy() {
    return SettingAction(name, getLocalizedName, action,
        getDescription: getDescription,
        searchTags: searchTags,
        enableConditions: enableConditions,);
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
