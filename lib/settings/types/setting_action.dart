import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class SettingAction extends SettingItem {
  VoidCallback action;

  SettingAction(String name, this.action) : super(name);

  @override
  SettingAction copy() {
    return SettingAction(name, action);
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
