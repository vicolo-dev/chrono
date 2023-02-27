import 'dart:ui';

import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/settings/types/setting.dart';

List<SettingItem> settingsItems = [
  SettingGroup(
    "General",
    [
      SelectSetting<TimeFormat>(
        "Time Format",
        [
          SelectSettingOption("12 Hours", TimeFormat.h12),
          SelectSettingOption("24 Hours", TimeFormat.h24),
          SelectSettingOption("Device Settings", TimeFormat.device),
        ],
        description: "12 or 24 hour time",
      ),
      SwitchSetting("Show Seconds", true),
    ],
    icon: FluxIcons.settings,
    description: "Set app wide settings like time format",
  ),
  SettingGroup(
      "Appearance",
      [
        SettingGroup(
          "Color",
          [
            SelectSetting<ColorScheme>(
              "Color Scheme",
              [
                SelectSettingOption("Light", lightColorScheme),
                SelectSettingOption("Dark", darkColorScheme),
                SelectSettingOption("Amoled", amoledColorScheme),
              ],
              onSelect: (context, index, colorScheme) {
                App.setColorScheme(
                    context,
                    colorScheme.copyWith(
                      primary: Theme.of(context).colorScheme.primary,
                      secondary: Theme.of(context).colorScheme.secondary,
                    ));
              },
            ),
            SelectSetting<Color>(
              "Accent Color",
              [
                SelectSettingOption("Cyan", Colors.cyan),
                SelectSettingOption("Red", Colors.red),
                SelectSettingOption("Green", Colors.green),
                SelectSettingOption("Blue", Colors.blue),
                SelectSettingOption("Yellow", Colors.yellow),
                SelectSettingOption("Orange", Colors.orange),
                SelectSettingOption("Purple", Colors.purple),
                SelectSettingOption("Pink", Colors.pink),
                SelectSettingOption("Teal", Colors.teal),
                SelectSettingOption("Lime", Colors.lime),
                SelectSettingOption("Indigo", Colors.indigo),
              ],
              onSelect: (context, index, color) {
                App.setAccentColor(context, color);
              },
            ),
          ],
        ),
        SettingGroup(
          "Shapes",
          [
            SliderSetting("Corner Roundness", 0, 36, 16,
                onChange: (context, radius) {
              App.setCardRadius(context, radius);
            }),
          ],
        ),
        SettingGroup("Shadows", [
          SwitchSetting(
            "Use Accent Color",
            false,
            onChange: (context, value) {
              App.setShadowColor(context,
                  value ? Theme.of(context).colorScheme.primary : Colors.black);
            },
          ),
          SliderSetting("Elevation", 0, 20, 1, onChange: (context, elevation) {
            App.setCardElevation(context, elevation);
          }),
          SliderSetting("Opacity", 0, 100, 50, onChange: (context, opacity) {
            App.setShadowOpacity(context, opacity / 100);
          }),
          SliderSetting("Blur", 0, 20, 2, onChange: (context, blur) {
            App.setShadowBlurRadius(context, blur);
          }),
        ])
      ],
      icon: FluxIcons.settings,
      description: "Set themes, colors and change layout"),
];

Settings appSettings = Settings(settingsItems);
