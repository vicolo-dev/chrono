import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

SettingGroup stopwatchSettingsSchema = SettingGroup(
  "Stopwatch",
  [
    SettingGroup(
        "Time Format",
        [
          SwitchSetting("Show Milliseconds", true),
        ],
        description: "Show comparison laps bars in stopwatch",
        icon: Icons.settings,
        searchTags: ["milliseconds"]),
    SettingGroup(
      "Comparison Lap Bars",
      [
        SwitchSetting("Show Previous Lap", true),
        SwitchSetting("Show Fastest Lap", true),
        SwitchSetting("Show Slowest Lap", true),
        SwitchSetting("Show Average Lap", true),
      ],
      description: "Show comparison laps bars in stopwatch",
      icon: Icons.settings,
      searchTags: ["fastest", "slowest", "average", "previous"],
    ),
    SwitchSetting("Show Notification", true),
  ],
  icon: FluxIcons.stopwatch,
);
