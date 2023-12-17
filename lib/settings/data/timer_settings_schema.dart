import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/timer/data/timer_settings_schema.dart';
import 'package:clock_app/timer/screens/presets_screen.dart';
import 'package:flutter/material.dart';

SettingGroup timerAppSettingsSchema = SettingGroup(
  "Timer",
  [
    SettingGroup(
      "Default Settings",
      [...timerSettingsSchema.settingItems],
      description: "Set default settings for new timers",
      icon: Icons.settings,
    ),
    SettingPageLink("Presets", const PresetsScreen()),
    SwitchSetting("Show Filters", true),
  ],
  icon: FluxIcons.timer,
);
