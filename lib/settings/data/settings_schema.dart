import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/theme/color.dart';
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

List<SettingItem> settingsItems = [
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
          SliderSetting("Corner Roundness", 0, 36,
              (defaultTheme.extension<ThemeStyle>()?.borderRadius)!,
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
        SwitchSetting(
          "Use Accent Color",
          false,
          onChange: (context, value) {
            App.setBorderColor(
                context,
                value
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onBackground);
          },
        ),
        SliderSetting(
            "Width", 0, 8, (defaultTheme.extension<ThemeStyle>()?.borderWidth)!,
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
        [...alarmSettingsSchema.items],
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
        [...timerSettingsSchema.items],
        description: "Set default settings for new timers",
        icon: Icons.settings,
      ),
      SettingLink("Presets", const PresetsScreen())
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
];

Settings appSettings = Settings(settingsItems);
