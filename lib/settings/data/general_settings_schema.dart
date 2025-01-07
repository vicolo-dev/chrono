import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/audio/screens/ringtones_screen.dart';
import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/common/types/weekday.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/utils/time_format.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/l10n/language_local.dart';
import 'package:clock_app/notifications/logic/notifications.dart';
import 'package:clock_app/settings/screens/tags_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/system/logic/background_service.dart';
import 'package:clock_app/system/logic/permissions.dart';
import 'package:clock_app/widgets/logic/update_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TimePickerType { dial, input, spinner }

enum DurationPickerType { rings, spinner, numpad }

SelectSettingOption<String> _getDateSettingOption(String format) {
  return SelectSettingOption((context) {
    Locale locale = Localizations.localeOf(context);
    return "${DateFormat(format, locale.languageCode).format(DateTime.now())} ($format)";
  }, format);
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

final longDateFormatOptions = [
  _getDateSettingOption("EEE, MMM d"),
  _getDateSettingOption("EEE, MMMM d"),
  _getDateSettingOption("EEE, d MMM"),
  _getDateSettingOption("EEE, d MMMM"),
  _getDateSettingOption("EEEE, MMM d"),
  _getDateSettingOption("EEEE, MMMM d"),
  _getDateSettingOption("EEEE, d MMM"),
  _getDateSettingOption("EEEE, d MMMM"),
];

enum SwipeAction {
  cardActions,
  switchTabs,
}

enum LongPressAction {
  reorder,
  multiSelect,
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
          onChange: (context, index) async {
            // await HomeWidget.saveWidgetData(
            //     "dateFormat", dateFormatOptions[index].value);
            // updateDigitalClockWidget();
          },
        ),
        SelectSetting<String>(
          "Long Date Format",
          (context) => AppLocalizations.of(context)!.longDateFormatSetting,
          longDateFormatOptions,
          onChange: (context, index) async {
            setDigitalClockWidgetData(context);

            // await HomeWidget.saveWidgetData(
            //     "dateFormat", dateFormatOptions[index].value);
            // updateDigitalClockWidget();
          },
        ),
        SelectSetting<TimeFormat>(
          "Time Format",
          (context) => AppLocalizations.of(context)!.timeFormatSetting,
          timeFormatOptions,
          onChange: (context, index) async {
            String timeFormat =
                getTimeFormatString(context, timeFormatOptions[index].value);
            saveTextFile("time_format_string", timeFormat);
            setDigitalClockWidgetData(context);
          },
        ),
        SelectSetting<Weekday>(
          "First Day of Week",
          (context) => AppLocalizations.of(context)!.firstDayOfWeekSetting,
          weekdays.map((weekday) {
            return SelectSettingOption(
              (context) => weekday.getFullName(context),
              weekday,
            );
          }).toList(),
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
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.pickerNumpad,
            DurationPickerType.numpad,
          ),
        ],
            searchTags: [
              "duration",
              "rings",
              "time",
              "numpad"
                  "picker",
              "dial",
              "input",
              "spinner",
            ]),
      ],
    ),
    SettingGroup("Interactions",
        (context) => AppLocalizations.of(context)!.interactionsSettingGroup, [
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
      SelectSetting(
        "Long Press Action",
        (context) => AppLocalizations.of(context)!.longPressActionSetting,
        [
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.longPressSelectAction,
            LongPressAction.multiSelect,
          ),
          SelectSettingOption(
            (context) => AppLocalizations.of(context)!.longPressReorderAction,
            LongPressAction.reorder,
          ),
        ],
      ),
    ]),
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
    SettingGroup(
      "Reliability",
      (context) => AppLocalizations.of(context)!.reliabilitySettingGroup,
      [
        SwitchSetting(
          "Show Foreground Notification",
          (context) => AppLocalizations.of(context)!.showForegroundNotification,
          false,
          getDescription: (context) => AppLocalizations.of(context)!
              .showForegroundNotificationDescription,
          searchTags: ["foreground", "notification"],
        ),
        SwitchSetting(
          "useBackgroundService",
          (context) =>
              AppLocalizations.of(context)!.useBackgroundServiceSetting,
          false,
          getDescription: (context) => AppLocalizations.of(context)!
              .useBackgroundServiceSettingDescription,
          onChange: (context, value) {
            stopBackgroundService();
          },
          searchTags: ["background", "service"],
        ),
        SliderSetting(
            "backgroundServiceInterval",
            (context) =>
                AppLocalizations.of(context)!.backgroundServiceIntervalSetting,
            15,
            300,
            60,
            unit: "m",
            snapLength: 15,
            getDescription: (context) => AppLocalizations.of(context)!
                .backgroundServiceIntervalSettingDescription,
            searchTags: ["background", "service", "interval"],
            onChange: (context, value) {
              initBackgroundService(interval: value.toInt());
            },
            enableConditions: [
              ValueCondition(["useBackgroundService"], (value) => value == true)
            ]),
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
          getDescription: (context) => AppLocalizations.of(context)!
              .batteryOptimizationSettingDescription,
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
          getDescription: (context) =>
              AppLocalizations.of(context)!.notificationPermissionDescription,
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
          getDescription: (context) => AppLocalizations.of(context)!
              .batteryOptimizationSettingDescription,
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
      ],
      searchTags: ["reliability", "battery", "optimization", "notifications"],
    ),
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
  ],
  icon: FluxIcons.settings,
  getDescription: (context) =>
      AppLocalizations.of(context)!.generalSettingGroupDescription,
);
