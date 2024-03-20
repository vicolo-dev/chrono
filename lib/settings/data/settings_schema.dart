import 'package:clock_app/settings/data/accessibility_settings_schema.dart';
import 'package:clock_app/settings/data/alarm_app_settings_schema.dart';
import 'package:clock_app/settings/data/appearance_settings_schema.dart';
import 'package:clock_app/settings/data/backup_settings_schema.dart';
import 'package:clock_app/settings/data/developer_settings_schema.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/stopwatch_settings_schema.dart';
import 'package:clock_app/settings/data/timer_app_settings_schema.dart';
import 'package:clock_app/settings/screens/about_screen.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';

const int settingsSchemaVersion = 1;

SettingGroup appSettings = SettingGroup(
  "Settings",
  version: settingsSchemaVersion,
  isSearchable: true,
  [
    generalSettingsSchema,
    appearanceSettingsSchema,
    alarmAppSettingsSchema,
    timerAppSettingsSchema,
    stopwatchSettingsSchema,
    accessibilitySettingsSchema,
    backupSettingsSchema,
    developerSettingsSchema,
    SettingPageLink(
      "About",
      const AboutScreen(),
    ),
  ],
);


// Settings appSettings = Settings(settingsItems);
