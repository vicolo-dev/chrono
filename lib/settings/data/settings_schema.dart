import 'package:app_settings/app_settings.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/alarm/types/notification_action.dart';
import 'package:clock_app/alarm/widgets/notification_actions/area_notification_action.dart';
import 'package:clock_app/alarm/widgets/notification_actions/buttons_notification_action.dart';
import 'package:clock_app/alarm/widgets/notification_actions/slide_notification_action.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/screens/vendor_list_screen.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        SettingGroup("Reliability", [
          SettingPageLink(
            "Vendor Specific",
            const VendorListScreen(),
            description: "Manually disable vendor-specific optimizations",
          ),
          SettingAction(
            "Disable Battery Optimization",
            (context) async {
              AppSettings.openAppSettings(
                  type: AppSettingsType.batteryOptimization);
            },
            description:
                "Disable battery optimization for this app to prevent alarms from being delayed",
          ),
          SettingAction(
            "Allow Notifications",
            (context) async {
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            },
            description:
                "Allow lock screen notifications for alarms and timers",
          ),
          SettingAction(
            "Auto Start",
            (context) async {
              try {
                //check auto-start availability.
                var test = await isAutoStartAvailable ?? false;
                //if available then navigate to auto-start setting page.
                if (test) {
                  await getAutoStartPermission();
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();

                  SnackBar snackBar = SnackBar(
                    content: Container(
                        alignment: Alignment.centerLeft,
                        height: 28,
                        child: const Text(
                            "Auto Start is not available for your device")),
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 4),
                    elevation: 2,
                    dismissDirection: DismissDirection.none,
                  );

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } on PlatformException catch (e) {
                if (kDebugMode) print(e.message);
              }
            },
            description:
                "Enable auto start to allow alarms to go off when the app is closed",
          )
        ]),
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
              searchTags: ["theme", "style", "visual", "dark mode"],
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
              searchTags: ["scheme", "visual"],
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
        SelectSetting<NotificationAction>("Dismiss Action Type", [
          SelectSettingOption(
            "Slide",
            NotificationAction(
              builder: (onDismiss, onSnooze) => SlideNotificationAction(
                onDismiss: onDismiss,
                onSnooze: onSnooze,
              ),
            ),
          ),
          SelectSettingOption(
            "Buttons",
            NotificationAction(
              builder: (onDismiss, onSnooze) => ButtonsNotificationAction(
                onDismiss: onDismiss,
                onSnooze: onSnooze,
              ),
            ),
          ),
          SelectSettingOption(
            "Area Buttons",
            NotificationAction(
              builder: (onDismiss, onSnooze) => AreaNotificationAction(
                onDismiss: onDismiss,
                onSnooze: onSnooze,
              ),
            ),
          )
        ]),
        SwitchSetting("Show Filters", true),
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
        SettingPageLink("Presets", const PresetsScreen()),
        SwitchSetting("Show Filters", true),
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
      "Accessibility",
      [SwitchSetting("Left Handed Mode", false)],
      icon: Icons.accessibility,
      showExpandedView: false,
    ),
    SettingGroup(
      "Developer Options",
      [
        SettingGroup("Alarm", [
          SwitchSetting(
            "Show Instant Alarm Button",
            kDebugMode,
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
