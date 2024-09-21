import 'package:clock_app/alarm/data/alarm_app_settings_schema.dart';
import 'package:clock_app/clock/data/clock_settings_schema.dart';
import 'package:clock_app/developer/data/developer_settings_schema.dart';
import 'package:clock_app/settings/data/accessibility_settings_schema.dart';
import 'package:clock_app/settings/data/backup_settings_schema.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/screens/about_screen.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/stopwatch/data/stopwatch_settings_schema.dart';
import 'package:clock_app/theme/data/appearance_settings_schema.dart';
import 'package:clock_app/timer/data/timer_app_settings_schema.dart';
import 'package:clock_app/widgets/data/widget_settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// Increment this after every schema change
const int settingsSchemaVersion = 7;

SettingGroup appSettings = SettingGroup(
  "Settings",
  (context) => AppLocalizations.of(context)!.settings,
  version: settingsSchemaVersion,
  isSearchable: true,
  [
    generalSettingsSchema,
    appearanceSettingsSchema,
    alarmAppSettingsSchema,
    clockSettingsSchema,
    timerAppSettingsSchema,
    stopwatchSettingsSchema,
    widgetSettingSchema,
    accessibilitySettingsSchema,
    backupSettingsSchema,
    developerSettingsSchema,
    SettingPageLink(
      "About",
      (context) => AppLocalizations.of(context)!.aboutSettingGroup,
      const AboutScreen(),
      icon: Icons.info_outline_rounded,
    ),
  ],
);

