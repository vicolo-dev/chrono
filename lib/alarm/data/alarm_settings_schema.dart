import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

Settings alarmSettingsSchema = Settings([
  StringSetting("Label", ""),
  SelectSetting<Type>(
    "Schedule Type",
    [
      SelectSettingOption("Once", OnceAlarmSchedule,
          description: "Will ring at the next occurrence of the time."),
      SelectSettingOption("Daily", DailyAlarmSchedule,
          description: "Will ring every day"),
      SelectSettingOption("On Specified Week Days", WeeklyAlarmSchedule,
          description: "Will repeat on the specified week days"),
      SelectSettingOption("On Specific Dates", DatesAlarmSchedule,
          description: "Will repeat on the specified dates"),
      SelectSettingOption("Date Range", RangeAlarmSchedule,
          description: "Will repeat during the specified date range"),
    ],
  ),
  ToggleSetting("Week Days", [
    ToggleSettingOption("M", 1),
    ToggleSettingOption("T", 2),
    ToggleSettingOption("W", 3),
    ToggleSettingOption("T", 4),
    ToggleSettingOption("F", 5),
    ToggleSettingOption("S", 6),
    ToggleSettingOption("S", 7),
  ], enableConditions: [
    SettingEnableCondition("Schedule Type", WeeklyAlarmSchedule)
  ]),
  DateTimeSetting(
    "Dates",
    [],
    enableConditions: [
      SettingEnableCondition("Schedule Type", DatesAlarmSchedule)
    ],
  ),
  DateTimeSetting(
    "Date Range",
    [],
    rangeOnly: true,
    enableConditions: [
      SettingEnableCondition("Schedule Type", RangeAlarmSchedule)
    ],
  ),
  SelectSetting<Duration>(
    "Interval",
    [
      SelectSettingOption("Daily", const Duration(days: 1)),
      SelectSettingOption("Weekly", const Duration(days: 7)),
    ],
    enableConditions: [
      SettingEnableCondition("Schedule Type", RangeAlarmSchedule)
    ],
  ),
  SettingGroup(
      "Sound and Vibration",
      [
        SettingGroup(
          "Sound",
          [
            DynamicSelectSetting<String>(
              "Melody",
              () => RingtoneManager.ringtones
                  .map((ringtone) =>
                      SelectSettingOption(ringtone.title, ringtone.uri))
                  .toList(),
              onSelect: (context, index, uri) {
                if (RingtoneManager.lastPlayedRingtoneUri == uri) {
                  RingtonePlayer.stop();
                } else {
                  RingtonePlayer.playUri(uri, loopMode: LoopMode.off);
                }
              },
              onChange: (context, index) {
                RingtonePlayer.stop();
              },
            ),
            SliderSetting("Volume", 0, 100, 100, unit: "%"),
            SwitchSetting("Rising Volume", false,
                description: "Gradually increase volume over time"),
            DurationSetting(
                "Time To Full Volume", const TimeDuration(minutes: 1),
                enableConditions: [
                  SettingEnableCondition("Rising Volume", true)
                ]),
          ],
        ),
        SwitchSetting("Vibration", false),
      ],
      icon: Icons.volume_up,
      summarySettings: [
        "Melody",
        "Vibration",
      ]),
  SettingGroup(
      "Snooze",
      [
        SliderSetting("Length", 1, 30, 5, unit: "minutes"),
      ],
      icon: Icons.snooze_rounded,
      summarySettings: [
        "Length",
      ])
]);
