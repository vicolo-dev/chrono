import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/utils/time_format.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/l10n/language_local.dart';
import 'package:clock_app/notifications/logic/notifications.dart';
import 'package:clock_app/settings/screens/ringtones_screen.dart';
import 'package:clock_app/settings/screens/tags_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/system/logic/permissions.dart';
import 'package:clock_app/widgets/logic/update_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TimePickerType { dial, input, spinner }

enum DurationPickerType { rings, spinner }

SelectSettingOption<String> _getDateSettingOption(String format) {
  return SelectSettingOption(
      (context) => "${DateFormat(format).format(DateTime.now())} ($format)",
      format);
}

final dateFormatOptions = [
  _getDateSettingOption("dd/MM/yyyy"),
  _getDateSettingOption("dd-MM-yyyy"),
  _getDateSettingOption("d/M/yyyy"),
  _getDateSettingOption("d-M-yyyy"),
  _getDateSettingOption("MM/dd/yyyy"),
  _getDateSettingOption("MM-dd-yyyy"),
  _getDateSettingOption("M/d/yy"),
  _getDateSettingOption("M-d-yy"),
  _getDateSettingOption("M/d/yyyy"),
  _getDateSettingOption("M-d-yyyy"),
  _getDateSettingOption("yyyy/dd/MM"),
  _getDateSettingOption("yyyy-dd-MM"),
  _getDateSettingOption("yyyy/MM/dd"),
  _getDateSettingOption("yyyy-MM-dd"),
  _getDateSettingOption("d MMM yyyy"),
  _getDateSettingOption("d MMMM yyyy"),
];

enum SwipeAction {
  cardActions,
  switchTabs,
}

final timeFormatOptions = [
  SelectSettingOption(
      (context) => AppLocalizations.of(context)!.timeFormat12, TimeFormat.h12),
  SelectSettingOption(
      (context) => AppLocalizations.of(context)!.timeFormat24, TimeFormat.h24),
  SelectSettingOption(
      (context) => AppLocalizations.of(context)!.timeFormatDevice,
      TimeFormat.device),
];

SettingGroup generalSettingsSchema = SettingGroup(
  "General",
  (context) => AppLocalizations.of(context)!.generalSettingGroup,
  [
    SelectSetting(
      "Language",
      (context) => AppLocalizations.of(context)!.languageSetting,
      [
        SelectSettingOption((context) => AppLocalizations.of(context)!.system,
            Locale(Platform.localeName.split("_").first)),
        ...getLocaleOptions()
      ],
      onChange: (context, index) {
        App.refreshTheme(context);
      },
    ),
    SettingGroup(
      "Display",
      (context) => AppLocalizations.of(context)!.displaySettingGroup,
      [
        SelectSetting<String>(
          "Date Format",
          (context) => AppLocalizations.of(context)!.dateFormatSetting,
          dateFormatOptions,
          getDescription: (context) => "How to display the dates",
          onChange: (context, index) async {
            // await HomeWidget.saveWidgetData(
            //     "dateFormat", dateFormatOptions[index].value);
            // updateDigitalClockWidget();
          },
        ),
        SelectSetting<TimeFormat>(
          "Time Format",
          (context) => AppLocalizations.of(context)!.timeFormatSetting,
          timeFormatOptions,
          getDescription: (context) => "12 or 24 hour time",
          onChange: (context, index) async {
            String timeFormat =
                getTimeFormatString(context, timeFormatOptions[index].value);
            saveTextFile("time_format_string", timeFormat);
            setDigitalClockWidgetData(context);
          },
        ),
        SwitchSetting(
            "Show Seconds",
            (context) => AppLocalizations.of(context)!.showSecondsSetting,
            true),
        SelectSetting("Time Picker",
            (context) => AppLocalizations.of(context)!.timePickerSetting, [
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.pickerDial,
            TimePickerType.dial,
          ),
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.pickerInput,
            TimePickerType.input,
          ),
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.pickerSpinner,
            TimePickerType.spinner,
          ),
        ],
            searchTags: [
              "time",
              "picker",
              "dial",
              "input",
              "spinner",
            ]),
        SelectSetting("Duration Picker",
            (context) => AppLocalizations.of(context)!.durationPickerSetting, [
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.pickerRings,
            DurationPickerType.rings,
          ),
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.pickerSpinner,
            DurationPickerType.spinner,
          ),
        ],
            searchTags: [
              "duration",
              "rings",
              "time",
              "picker",
              "dial",
              "input",
              "spinner",
            ]),
      ],
    ),
    SelectSetting(
      "Swipe Action",
      (context) => AppLocalizations.of(context)!.swipeActionSetting,
      [
        SelectSettingOption(
          (context) => AppLocalizations.of(context)!.swipActionCardAction,
          SwipeAction.cardActions,
          getDescription: (context) =>
              AppLocalizations.of(context)!.swipeActionCardActionDescription,
        ),
        SelectSettingOption(
          (context) => AppLocalizations.of(context)!.swipActionSwitchTabs,
          SwipeAction.switchTabs,
          getDescription: (context) =>
              AppLocalizations.of(context)!.swipeActionSwitchTabsDescription,
        )
      ],
    ),
    SettingPageLink(
      "Melodies",
      (context) => AppLocalizations.of(context)!.melodiesSetting,
      const RingtonesScreen(),
      searchTags: ["ringtones", "music", "audio", "tones", "custom"],
      icon: Icons.music_note_outlined,
    ),
    SettingPageLink(
      "Tags",
      (context) => AppLocalizations.of(context)!.tagsSetting,
      const TagsScreen(),
      searchTags: ["tags", "groups", "filter"],
      icon: Icons.label_outline_rounded,
    ),
    SettingGroup("Reliability",
        (context) => AppLocalizations.of(context)!.reliabilitySettingGroup, [
      SettingAction(
        "Ignore Battery Optimizations",
        (context) =>
            AppLocalizations.of(context)!.ignoreBatteryOptimizationSetting,
        (context) async {
          requestBatteryOptimizationPermission(
              onAlreadyGranted: () => {
                    showSnackBar(
                        context,
                        AppLocalizations.of(context)!
                            .ignoreBatteryOptimizationAlreadyGranted)
                  });
        },
        getDescription: (context) =>
            AppLocalizations.of(context)!.batteryOptimizationSettingDescription,
      ),
      SettingAction(
        "Notifications",
        (context) =>
            AppLocalizations.of(context)!.notificationPermissionSetting,
        (context) async {
          requestNotificationPermissions(
              onAlreadyGranted: () => {
                    showSnackBar(
                        context,
                        AppLocalizations.of(context)!
                            .notificationPermissionAlreadyGranted)
                  });
        },
      ),
      SettingAction(
        "Vendor Specific",
        (context) => AppLocalizations.of(context)!.vendorSetting,
        (context) => launchUrl(Uri.parse("https://dontkillmyapp.com")),
        getDescription: (context) =>
            AppLocalizations.of(context)!.vendorSettingDescription,
      ),
      SettingAction(
        "Disable Battery Optimization",
        (context) => AppLocalizations.of(context)!.batteryOptimizationSetting,
        (context) async {
          AppSettings.openAppSettings(
              type: AppSettingsType.batteryOptimization);
        },
        getDescription: (context) =>
            AppLocalizations.of(context)!.batteryOptimizationSettingDescription,
      ),
      SettingAction(
        "Allow Notifications",
        (context) => AppLocalizations.of(context)!.allowNotificationSetting,
        (context) async {
          AppSettings.openAppSettings(type: AppSettingsType.notification);
        },
        getDescription: (context) =>
            AppLocalizations.of(context)!.allowNotificationSettingDescription,
      ),
      SettingAction(
        "Auto Start",
        (context) => AppLocalizations.of(context)!.autoStartSetting,
        (context) async {
          try {
            //check auto-start availability.
            var test = (await isAutoStartAvailable) ?? false;
            //if available then navigate to auto-start setting page.
            if (test) {
              await getAutoStartPermission();
            } else {
              // ignore: use_build_context_synchronously
              if (context.mounted) {
                showSnackBar(
                    context, "Auto Start is not available for your device");
              }
            }
          } on PlatformException catch (e) {
            if (kDebugMode) print(e.message);
          }
        },
        getDescription: (context) =>
            AppLocalizations.of(context)!.autoStartSettingDescription,
      ),
    ]),
    SelectSetting(
      "Default Tab",
      (context) => AppLocalizations.of(context)!.defaultPageSetting,
      [
        SelectSettingOption(
          (context) => AppLocalizations.of(context)!.alarmTitle,
          0,
        ),
        SelectSettingOption(
          (context) => AppLocalizations.of(context)!.clockTitle,
          1,
        ),
        SelectSettingOption(
          (context) => AppLocalizations.of(context)!.timerTitle,
          2,
        ),
        SelectSettingOption(
          (context) => AppLocalizations.of(context)!.stopwatchTitle,
          3,
        ),
      ],
    ),
    SettingGroup("Animations",
        (context) => AppLocalizations.of(context)!.animationSettingGroup, [
      SliderSetting(
        "Animation Speed",
        (context) => AppLocalizations.of(context)!.animationSpeedSetting,
        0.5,
        2,
        1,
        // unit: 'm',
        snapLength: 0.1,
        // enableConditions: [
        //   ValueCondition(
        //       ["Show Upcoming Alarm Notifications"], (value) => value),
        // ],
      ),
      SwitchSetting(
          "Extra Animations",
          (context) => AppLocalizations.of(context)!.extraAnimationSetting,
          false),
    ])
  ],
  icon: FluxIcons.settings,
  getDescription: (context) =>
      AppLocalizations.of(context)!.generalSettingGroupDescription,
);
