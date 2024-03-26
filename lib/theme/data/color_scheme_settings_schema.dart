import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

const colorSchemeSettingsSchemaVersion = 1;

SettingGroup colorSchemeSettingsSchema = SettingGroup(
  version: colorSchemeSettingsSchemaVersion,
  "Color Scheme",
  [
    StringSetting("Name", "Color Scheme"),
    SettingGroup("Background", [
      ColorSetting("Color", Colors.white),
      ColorSetting("Text", Colors.black),
    ]),
    SettingGroup("Card", [
      ColorSetting("Color", Colors.white),
      ColorSetting("Text", Colors.black),
    ]),
    SettingGroup("Accent", [
      ColorSetting("Color", Colors.cyan),
      ColorSetting("Text", Colors.white),
    ]),
    SettingGroup("Shadow", [
      SwitchSetting("Use Accent as Shadow", false),
      ColorSetting("Color", Colors.black, enableConditions: [
        ValueCondition(["Use Accent as Shadow"], (value)=>value==false),
      ]),
    ]),
    SettingGroup("Outline", [
      SwitchSetting("Use Accent as Outline", false),
      ColorSetting("Color", Colors.black, enableConditions: [
        ValueCondition(["Use Accent as Outline"], (value)=>value==false),
      ]),
    ]),
    SettingGroup("Error", [
      ColorSetting("Color", Colors.red),
      ColorSetting("Text", Colors.white),
    ]),
  ],
);
