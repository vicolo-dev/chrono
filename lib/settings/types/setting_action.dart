import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class SettingAction extends SettingItem {
  void Function(BuildContext context) action;

  SettingAction(
    String name,
    this.action, {
    String description = "",
    List<String> searchTags = const [],
  }) : super(name, description, searchTags);

  @override
  SettingAction copy() {
    return SettingAction(name, action,
        description: description, searchTags: searchTags);
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
