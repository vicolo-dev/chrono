import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/alarm/types/range_interval.dart';
import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/alarm/widgets/alarm_task_card.dart';
import 'package:clock_app/audio/types/audio.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

SettingGroup alarmSettingsSchema = SettingGroup(
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
            DynamicSelectSetting<Audio>(
              "Melody",
              () => RingtoneManager.ringtones
                  .map((ringtone) =>
                      SelectSettingOption<Audio>(ringtone.title, ringtone))
                  .toList(),
              onSelect: (context, index, uri) {},
              onChange: (context, index) {
                RingtonePlayer.stop();
              },
              shouldCloseOnSelect: false,
            ),
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
      ],
      icon: Icons.snooze_rounded,
      summarySettings: [
        "Length",
      ],
    ),
    ListSetting<AlarmTask>("Tasks", [], [AlarmTask(AlarmTaskType.arithmetic)],
        getSettings: (item) => item.settings,
        addCardBuilder: (item) => AlarmTaskCard(task: item),
        cardBuilder: (item) => AlarmTaskCard(task: item),
        valueDisplayBuilder: (context, setting) {
          return Text("${setting.value.length} tasks");
        }),
    // CustomSetting<AlarmTaskList>("Tasks", AlarmTaskList([]),
    //     (context, setting) {
    //   return CustomizeAlarmTasksScreen(setting: setting);
    // }, (context, setting) {
    //   return Text("${setting.value.tasks.length} tasks");
    // }),
  ],
);
