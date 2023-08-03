import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class SettingPageLink extends SettingItem {
  Widget screen;

  SettingPageLink(String name, this.screen) : super(name);

  @override
  SettingPageLink copy() {
    return SettingPageLink(name, screen);
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
