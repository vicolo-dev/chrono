import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

SettingGroup accessibilitySettingsSchema = SettingGroup(
  "Accessibility",
  [SwitchSetting("Left Handed Mode", false)],
  icon: Icons.accessibility_new_rounded,
  showExpandedView: false,
);
