import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/theme/color_scheme.dart';
import 'package:clock_app/theme/screens/color_schemes_screen.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/theme_extension.dart';
import 'package:clock_app/timer/data/timer_settings_schema.dart';
import 'package:clock_app/timer/screens/presets_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

SelectSettingOption<String> _getDateSettingOption(String format) {
  return SelectSettingOption(
      "${DateFormat(format).format(DateTime.now())} ($format)", format);
}

SettingGroup appSettings = SettingGroup(
  "Settings",
  isSearchable: true,
  [
    SettingGroup(
      "General",
      [
        SettingGroup("Display", [
          DynamicSelectSetting<String>(
            "Date Format",
            () => [
              _getDateSettingOption("dd/MM/yyyy"),
              _getDateSettingOption("dd/MM/yyyy"),
              _getDateSettingOption("d/M/yyyy"),
              _getDateSettingOption("MM/dd/yyyy"),
              _getDateSettingOption("M/d/yy"),
              _getDateSettingOption("M/d/yyyy"),
              _getDateSettingOption("yyyy-dd-MM"),
              _getDateSettingOption("d-MMM-yyyy"),
            ],
            description: "How to display the dates",
          ),
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
        ])
      ],
      icon: FluxIcons.settings,
      description: "Set app wide settings like time format",
    ),
    SettingGroup(
      "Appearance",
      [
        SettingGroup(
          "Colors",
          [
            // DynamicSelectSetting<ColorSchemeData>(
            //   "Color Scheme",
            //   () {
            //     List<ColorSchemeData> colorSchemes =
            //         loadListSync("color_schemes");
            //     return colorSchemes
            //         .map((e) => SelectSettingOption(e.name, e))
            //         .toList();
            //   },
            //   onSelect: (context, index, colorScheme) {
            //     App.setColorScheme(
            //       context,
            //       colorScheme,
            //     );
            //   },
            //   isVisual: false,
            // ),
            // SettingPageLink("Color Scheme", const ColorSchemesScreen()),
            CustomSetting(
              "Color Scheme",
              defaultColorScheme,
              (setting) => ColorSchemesScreen(setting: setting),
              (setting) => setting.value.name,
              onChange: (context, colorScheme) {
                App.setColorScheme(context, colorScheme);
              },
            ),
            SwitchSetting(
              "Override Accent Color",
              false,
              onChange: (context, value) {
                App.setColorScheme(context);
              },
            ),
            ColorSetting(
              "Accent Color",
              Colors.cyan,
              onChange: (context, color) {
                App.setColorScheme(context);
              },
              enableConditions: [
                SettingEnableConditionParameter("Override Accent Color", true)
              ],
            ),
          ],
        ),
        SettingGroup(
          "Shapes",
          [
            SliderSetting("Corner Roundness", 0, 36,
                (defaultTheme.extension<ThemeStyle>()?.borderRadius)!,
                onChange: (context, radius) {
              App.setCardRadius(context, radius);
            }),
          ],
        ),
        SettingGroup("Shadows", [
          SliderSetting("Elevation", 0, 10,
              (defaultTheme.extension<ThemeStyle>()?.shadowElevation)!,
              onChange: (context, elevation) {
            App.setCardElevation(context, elevation);
          }),
          SliderSetting("Opacity", 0, 100,
              (defaultTheme.extension<ThemeStyle>()?.shadowOpacity)! * 100,
              onChange: (context, opacity) {
            App.setShadowOpacity(context, opacity / 100);
          }),
          SliderSetting("Blur", 0, 16,
              (defaultTheme.extension<ThemeStyle>()?.shadowBlurRadius)!,
              onChange: (context, blur) {
            App.setShadowBlurRadius(context, blur);
          }),
          SliderSetting("Spread", 0, 8,
              (defaultTheme.extension<ThemeStyle>()?.shadowSpreadRadius)!,
              onChange: (context, spread) {
            App.setShadowSpreadRadius(context, spread);
          }),
        ]),
        SettingGroup("Outlines", [
          SliderSetting("Width", 0, 8,
              (defaultTheme.extension<ThemeStyle>()?.borderWidth)!,
              onChange: (context, width) {
            App.setBorderWidth(context, width);
          }),
        ])
      ],
      icon: FluxIcons.settings,
      description: "Set themes, colors and change layout",
    ),
    SettingGroup(
      "Alarm",
      [
        SettingGroup(
          "Default Settings",
          [...alarmSettingsSchema.settingItems],
          description: "Set default settings for new alarms",
          icon: Icons.settings,
        ),
      ],
      icon: FluxIcons.alarm,
    ),
    SettingGroup(
      "Timer",
      [
        SettingGroup(
          "Default Settings",
          [...timerSettingsSchema.settingItems],
          description: "Set default settings for new timers",
          icon: Icons.settings,
        ),
        SettingPageLink("Presets", const PresetsScreen())
      ],
      icon: FluxIcons.timer,
    ),
    SettingGroup(
      "Stopwatch",
      [
        SettingGroup(
          "Time Format",
          [
            SwitchSetting("Show Milliseconds", true),
          ],
          description: "Show comparison laps bars in stopwatch",
          icon: Icons.settings,
        ),
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
        ),
      ],
      icon: FluxIcons.stopwatch,
    )
  ],
);

// Settings appSettings = Settings(settingsItems);
