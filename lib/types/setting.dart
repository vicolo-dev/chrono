import 'dart:ui';

import 'package:flutter/cupertino.dart';

class SettingGroup {
  String name;
  String description;
  IconData icon;

  List<Setting> settings;

  SettingGroup(this.name, this.settings, this.icon, [this.description = ""]);
}

abstract class Setting<T> {
  String name;
  String description;
  T defaultValue;

  Setting(this.name, this.description, this.defaultValue);
}

class ToggleSetting extends Setting<bool> {
  ToggleSetting(String name, bool defaultValue, [String description = ""])
      : super(name, description, defaultValue);
}

class NumberSetting extends Setting<double> {
  NumberSetting(String name, double defaultValue, [String description = ""])
      : super(name, description, defaultValue);
}

class ColorSetting extends Setting<Color> {
  ColorSetting(String name, Color defaultValue, [String description = ""])
      : super(name, description, defaultValue);
}

class StringSetting extends Setting<String> {
  StringSetting(String name, String defaultValue, [String description = ""])
      : super(name, description, defaultValue);
}

class SliderSetting extends Setting<double> {
  double min;
  double max;

  SliderSetting(String name, this.min, this.max, double defaultValue,
      [String description = ""])
      : super(name, description, defaultValue);
}

class SelectSetting extends Setting<int> {
  List<SettingOption> options;

  SelectSetting(String name, this.options, int defaultValue,
      [String description = ""])
      : super(name, description, defaultValue);
}

class SettingOption {
  String name;
  String description;

  SettingOption(this.name, [this.description = ""]);
}
