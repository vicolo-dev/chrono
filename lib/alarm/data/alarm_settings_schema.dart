import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/alarm/types/alarm_schedules.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

Settings alarmSettingsSchema = Settings([
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
  SettingGroup(
      "Sound and Vibration",
      [
        DynamicSelectSetting<String>(
          "Melody",
          () => RingtoneManager.ringtones
              .map((ringtone) =>
                  SelectSettingOption(ringtone.title, ringtone.uri))
              .toList(),
          onSelect: (index, uri) {
            if (RingtoneManager.lastPlayedRingtoneUri == uri) {
              AlarmAudioPlayer.stop();
            } else {
              AlarmAudioPlayer.play(uri, loopMode: LoopMode.off);
            }
          },
          onChange: (index) {
            AlarmAudioPlayer.stop();
          },
        ),
        SwitchSetting("Vibration", false),
        SliderSetting("Volume", 0, 100, 100, unit: "%"),
        SwitchSetting("Rising Volume", false,
            description: "Gradually increase volume over time"),
      ],
      Icons.volume_up,
      summarySettings: [
        "Melody",
        "Vibration",
      ]),
  SettingGroup(
      "Snooze",
      [
        SliderSetting("Length", 1, 30, 5, unit: "minutes"),
      ],
      Icons.snooze_rounded,
      summarySettings: [
        "Length",
      ])
]);
