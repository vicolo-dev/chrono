import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SettingGroup stopwatchSettingsSchema = SettingGroup(
  "Stopwatch",
  (context) => AppLocalizations.of(context)!.stopwatchTitle,
  [
    SettingGroup(
        "Time Format",
        (context) =>
            AppLocalizations.of(context)!.stopwatchTimeFormatSettingGroup,
        [
          SwitchSetting(
              "Show Milliseconds",
              (context) => AppLocalizations.of(context)!
                  .stopwatchShowMillisecondsSetting,
              true),
        ],
        // description: "Show comparison laps bars in stopwatch",
        icon: Icons.settings,
        searchTags: ["milliseconds"]),
    SettingGroup(
      "Comparison Lap Bars",
      (context) => AppLocalizations.of(context)!.comparisonLapBarsSettingGroup,
      [
        SwitchSetting(
            "Show Previous Lap",
            (context) => AppLocalizations.of(context)!.showPreviousLapSetting,
            true),
        SwitchSetting(
            "Show Fastest Lap",
            (context) => AppLocalizations.of(context)!.showFastestLapSetting,
            true),
        SwitchSetting(
            "Show Slowest Lap",
            (context) => AppLocalizations.of(context)!.showSlowestLapSetting,
            true),
        SwitchSetting(
            "Show Average Lap",
            (context) => AppLocalizations.of(context)!.showAverageLapSetting,
            true),
      ],
      // description: "Show comparison laps bars in stopwatch",
      icon: Icons.settings,
      searchTags: ["fastest", "slowest", "average", "previous"],
    ),
    SwitchSetting(
        "Show Notification",
        (context) => AppLocalizations.of(context)!.showNotificationSetting,
        true),
  ],
  icon: FluxIcons.stopwatch,
);
