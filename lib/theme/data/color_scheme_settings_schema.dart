import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

SettingGroup colorSchemeSettingsSchema = SettingGroup(
  "Color Scheme",
  [
    StringSetting("Name", "Color Scheme"),
    ColorSetting("Background", Colors.white),
    ColorSetting("On Background", Colors.black),
    ColorSetting("Card", Colors.white),
    ColorSetting("On Card", Colors.black),
    ColorSetting("Accent", Colors.cyan),
    ColorSetting("On Accent", Colors.white),
    SwitchSetting("Use Accent as Shadow", false),
    ColorSetting("Shadow", Colors.black, enableConditions: [
      SettingEnableConditionParameter("Use Accent as Shadow", false),
    ]),
    SwitchSetting("Use Accent as Outline", false),
    ColorSetting("Outline", Colors.black, enableConditions: [
      SettingEnableConditionParameter("Use Accent as Outline", false),
    ]),
    ColorSetting("Error", Colors.red),
    ColorSetting("On Error", Colors.white),
  ],
);
