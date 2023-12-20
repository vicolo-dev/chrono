import 'package:audio_session/audio_session.dart';
import 'package:clock_app/alarm/data/alarm_task_schemas.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/alarm/types/range_interval.dart';
import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/alarm/widgets/alarm_task_card.dart';
import 'package:clock_app/alarm/widgets/try_alarm_task_button.dart';
import 'package:clock_app/audio/audio_channels.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/audio.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/utils/ringtones.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

const alarmSchemaVersion = 2;

SettingGroup alarmSettingsSchema = SettingGroup(
  version: alarmSchemaVersion,
  "AlarmSettings",
  [
    StringSetting("Label", ""),
    SettingGroup(
      "Schedule",
      [
        SelectSetting<Type>(
          "Type",
          [
            SelectSettingOption("Once", OnceAlarmSchedule,
                description: "Will ring at the next occurrence of the time"),
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
        ToggleSetting(
          "Week Days",
          [
            ToggleSettingOption("M", 1),
            ToggleSettingOption("T", 2),
            ToggleSettingOption("W", 3),
            ToggleSettingOption("T", 4),
            ToggleSettingOption("F", 5),
            ToggleSettingOption("S", 6),
            ToggleSettingOption("S", 7),
          ],
          enableConditions: [
            SettingEnableConditionParameter("Type", WeeklyAlarmSchedule)
          ],
        ),
        DateTimeSetting(
          "Dates",
          [],
          enableConditions: [
            SettingEnableConditionParameter("Type", DatesAlarmSchedule)
          ],
        ),
        DateTimeSetting(
          "Date Range",
          [],
          rangeOnly: true,
          enableConditions: [
            SettingEnableConditionParameter("Type", RangeAlarmSchedule)
          ],
        ),
        SelectSetting<RangeInterval>(
          "Interval",
          [
            SelectSettingOption("Daily", RangeInterval.daily),
            SelectSettingOption("Weekly", RangeInterval.weekly),
          ],
          enableConditions: [
            SettingEnableConditionParameter("Type", RangeAlarmSchedule)
          ],
        ),
      ],
      icon: Icons.timer,
    ),
    SettingGroup(
      "Sound and Vibration",
      [
        SettingGroup(
          "Sound",
          [
            DynamicSelectSetting<FileItem>(
              "Melody",
              getRingtoneOptions,
              onSelect: (context, index, uri) {},
              onChange: (context, index) {
                RingtonePlayer.stop();
              },
              shouldCloseOnSelect: false,
            ),
            SelectSetting<AndroidAudioUsage>(
                "Audio Channel", audioChannelOptions,
                onChange: (context, index) {
              RingtonePlayer.stop();
            }),
            SliderSetting("Volume", 0, 100, 100, unit: "%"),
            SwitchSetting("Rising Volume", false,
                description: "Gradually increase volume over time"),
            DurationSetting(
                "Time To Full Volume", const TimeDuration(minutes: 1),
                enableConditions: [
                  SettingEnableConditionParameter("Rising Volume", true)
                ]),
          ],
        ),
        SwitchSetting("Vibration", false),
      ],
      icon: Icons.volume_up,
      summarySettings: [
        "Melody",
        "Vibration",
      ],
    ),
    SettingGroup(
      "Snooze",
      [
        SliderSetting("Length", 1, 30, 5, unit: "minutes"),
        SliderSetting("Max Snoozes", 1, 10, 3,
            unit: "times",
            snapLength: 1,
            description:
                "The maximum number of times the alarm can be snoozed before it is dismissed"),
        SettingGroup("While Snoozed", [
          SwitchSetting("Prevent Disabling", false),
          SwitchSetting("Prevent Deletion", false),
        ]),
      ],
      icon: Icons.snooze_rounded,
      summarySettings: [
        "Length",
      ],
    ),
    ListSetting<AlarmTask>(
      "Tasks",
      [],
      alarmTaskSchemasMap.keys.map((key) => AlarmTask(key)).toList(),
      addCardBuilder: (item) => AlarmTaskCard(task: item, isAddCard: true),
      cardBuilder: (item) => AlarmTaskCard(task: item, isAddCard: false),
      valueDisplayBuilder: (context, setting) {
        return Text("${setting.value.length} tasks");
      },
      itemPreviewBuilder: (item) => TryAlarmTaskButton(alarmTask: item),
    ),
    // CustomSetting<AlarmTaskList>("Tasks", AlarmTaskList([]),
    //     (context, setting) {
    //   return CustomizeAlarmTasksScreen(setting: setting);
    // }, (context, setting) {
    //   return Text("${setting.value.tasks.length} tasks");
    // }),
  ],
);
