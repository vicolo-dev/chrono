import 'package:clock_app/alarm/types/alarm_audio_player.dart';
import 'package:clock_app/alarm/types/alarm_schedules.dart';
import 'package:clock_app/alarm/types/schedule_type.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

List<SelectSettingOption<int>> getRingtoneOptions() {
  return AlarmAudioPlayer.ringtones
      .asMap()
      .entries
      .map((entry) => SelectSettingOption<int>(entry.value.title, entry.key))
      .toList();
}

Settings alarmDefaultSettings = Settings([
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
        DynamicSelectSetting<int>(
          "Melody",
          getRingtoneOptions,
          onSelect: (index) {
            if (AlarmAudioPlayer.lastPlayedRingtoneIndex == index) {
              AlarmAudioPlayer.stop();
            } else {
              AlarmAudioPlayer.play(index, loopMode: LoopMode.off);
            }
          },
          onChange: (value) {
            AlarmAudioPlayer.stop();
          },
        ),
        SwitchSetting("Vibration", false),
      ],
      Icons.volume_up,
      summarySettings: [
        "Melody",
        "Vibration",
      ]),
]);


// const Map<ScheduleTypeName, ScheduleType> scheduleTypes = {
//   OnceSchedu:
//       ScheduleType("Once", "Will ring at the next occurrence of the time."),
//   ScheduleTypeName.daily: ScheduleType("Daily", "Will ring every day"),
//   ScheduleTypeName.weekly: ScheduleType(
//       "On Specific Week Days", "Will repeat on the specified week days"),
//   ScheduleTypeName.dates:
//       ScheduleType("On Specific Dates", "Will repeat on the specified dates"),
//   ScheduleTypeName.range:
//       ScheduleType("Date Range", "Will repeat during the specified date range"),
// };
  // ScheduleType("Once", "Will ring at the next occurrence of the time."),
  // ScheduleType("Daily", "Will ring every day"),
  // ScheduleType("On Specified Days", "Will repeat on the specified week days"),
  // ScheduleType("Advanced", "Set your owns rules for the schedule"),

