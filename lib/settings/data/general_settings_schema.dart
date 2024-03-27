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
import 'package:clock_app/settings/screens/ringtones_screen.dart';
import 'package:clock_app/settings/screens/vendor_list_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locale_names/locale_names.dart';

SelectSettingOption<String> _getDateSettingOption(String format) {
  return SelectSettingOption(
      "${DateFormat(format).format(DateTime.now())} ($format)", format);
}

final timeFormatOptions = [
  SelectSettingOption("12 Hours", TimeFormat.h12),
  SelectSettingOption("24 Hours", TimeFormat.h24),
  SelectSettingOption("Device Settings", TimeFormat.device),
];

SettingGroup generalSettingsSchema = SettingGroup(
  "General",
  [
    SelectSetting("Language",[SelectSettingOption("System", Locale(Platform.localeName)), ...AppLocalizations.supportedLocales.map((locale) {
      return SelectSettingOption(Locale.fromSubtags(
        languageCode: locale.languageCode, scriptCode: locale.scriptCode, countryCode: locale.countryCode).nativeDisplayLanguage, locale);
    })], onChange: (context, index) {
      App.refreshTheme(context);
    }),
    SettingGroup("Display", [
      SelectSetting<String>(
        "Date Format",
        [
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
          // SelectSettingOption(DateTime.now().toIso8601Date(), "YYYY-MM-DD"),
          _getDateSettingOption("d MMM yyyy"),
          _getDateSettingOption("d MMMM yyyy"),
        ],
        description: "How to display the dates",
      ),
      SelectSetting<TimeFormat>("Time Format", timeFormatOptions,
          description: "12 or 24 hour time", onChange: (context, index) {
        saveTextFile("time_format_string",
            getTimeFormatString(context, timeFormatOptions[index].value));
      }),
      SwitchSetting("Show Seconds", true),
    ]),
    SettingPageLink(
      "Melodies",
      const RingtonesScreen(),
      searchTags: ["ringtones", "music", "audio", "tones", "custom"],
    ),
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
        description: "Allow lock screen notifications for alarms and timers",
      ),
      SettingAction(
        "Auto Start",
        (context) async {
          try {
            //check auto-start availability.
            var test = (await isAutoStartAvailable) ?? false;
            //if available then navigate to auto-start setting page.
            if (test) {
              await getAutoStartPermission();
            } else {
              // ignore: use_build_context_synchronously
              showSnackBar(
                  context, "Auto Start is not available for your device");
            }
          } on PlatformException catch (e) {
            if (kDebugMode) print(e.message);
          }
        },
        description:
            "Some devices require Auto Start to be enabled for alarms to ring while app is closed.",
      )
    ]),
  ],
  icon: FluxIcons.settings,
  description: "Set app wide settings like time format",
);
