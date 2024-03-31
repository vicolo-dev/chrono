import 'package:clock_app/alarm/screens/alarm_events_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

SettingGroup developerSettingsSchema = SettingGroup(
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
    SettingPageLink("Alarm Logs", const AlarmEventsScreen())
  ],
  icon: Icons.code_rounded,
);
