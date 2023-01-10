import 'dart:ui';

import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/settings/types/setting.dart';

List<SettingGroup> settings = [
  SettingGroup(
    "General",
    [
      SelectSetting(
        "Time Format",
        [
          SettingOption("12 hour"),
          SettingOption("24 hour"),
          SettingOption("System")
        ],
        1,
        description: "12 or 24 hour time",
      ),
    ],
    FluxIcons.settings,
    description: "Set app wide settings like time format",
  ),
  SettingGroup(
      "Appearance",
      [
        SelectSetting(
            "Theme",
            [
              SettingOption("Light"),
              SettingOption("Dark"),
              SettingOption("Amoled"),
              SettingOption("System"),
            ],
            1),
        ColorSetting("Accent Color", const Color.fromARGB(255, 9, 163, 184)),
      ],
      FluxIcons.settings,
      description: "Set themes, colors and change layout"),
];
