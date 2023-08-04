import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/theme/screens/themes_screen.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:clock_app/theme/utils/style_theme.dart';
import 'package:clock_app/timer/data/timer_settings_schema.dart';
import 'package:clock_app/timer/screens/presets_screen.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
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
        ]),
        SettingAction("Disable battery optimizations", () async {
          print("testing");
          await DisableBatteryOptimization.showDisableAllOptimizationsSettings(
              "Enable Auto Start",
              "Follow the steps and enable the auto start of this app",
              "Your device has additional battery optimization",
              "Follow the steps and disable the optimizations to allow smooth functioning of this app");
        })
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
            CustomSetting(
              "Color Scheme",
              defaultColorScheme,
              (context, setting) => ThemesScreen(
                saveTag: 'color_schemes',
                setting: setting,
                getThemeFromItem: (theme, themeItem) =>
                    getThemeFromColorScheme(theme, themeItem),
                createThemeItem: () => ColorSchemeData(),
              ),
              (context, setting) => Text(
                setting.value.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
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
          "Style",
          [
            CustomSetting<StyleTheme>(
              "Style Theme",
              defaultStyleTheme,
              (context, setting) => ThemesScreen(
                saveTag: 'style_themes',
                setting: setting,
                getThemeFromItem: (theme, themeItem) =>
                    getThemeFromStyleTheme(theme, themeItem),
                createThemeItem: () => StyleTheme(),
              ),
              (context, setting) => Text(
                setting.value.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onChange: (context, styleTheme) {
                App.setStyleTheme(context, styleTheme);
              },
            ),
          ],
        ),
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
    ),
    SettingGroup(
      "Developer Options",
      [
        SettingGroup("Alarm", [
          SwitchSetting(
            "Show Instant Alarm Button",
            true,
            description:
                "Show a button on the alarm screen that creates an alarm that rings one second in the future",
          ),
        ]),
      ],
      icon: Icons.code,
    ),
  ],
);

// Settings appSettings = Settings(settingsItems);
