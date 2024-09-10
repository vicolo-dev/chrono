import 'dart:io';

import 'package:clock_app/alarm/screens/alarm_events_screen.dart';
import 'package:clock_app/debug/screens/logs_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SettingGroup developerSettingsSchema = SettingGroup(
  "Developer Options",
  (context) => AppLocalizations.of(context)!.developerOptionsSettingGroup,
  [
    SettingGroup(
        "Alarm", (context) => AppLocalizations.of(context)!.alarmTitle, [
      SwitchSetting(
        "Show Instant Alarm Button",
        (context) => AppLocalizations.of(context)!.showIstantAlarmButtonSetting,
        kDebugMode,
        // description:
        //     "Show a button on the alarm screen that creates an alarm that rings one second in the future",
      ),
    ]),
    SettingGroup(
        "Logs", (context) => AppLocalizations.of(context)!.logsSettingGroup, [
      SliderSetting(
        "Max logs",
        (context) => AppLocalizations.of(context)!.maxLogsSetting,
        10,
        500,
        100,
        snapLength: 1,
      ),
      SettingPageLink(
          "alarm_logs",
          (context) => AppLocalizations.of(context)!.alarmLogSetting,
          const AlarmEventsScreen()),
       SettingPageLink(
          "app_logs",
          (context) => AppLocalizations.of(context)!.appLogs,
          const LogsScreen()),

        ]),
  ],
  icon: Icons.code_rounded,
);
