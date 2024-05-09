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
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/common/logic/tags.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/popup_action.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/ringtones.dart';
import 'package:clock_app/settings/screens/ringtones_screen.dart';
import 'package:clock_app/settings/screens/tags_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const alarmSchemaVersion = 5;

SettingGroup alarmSettingsSchema = SettingGroup(
  version: alarmSchemaVersion,
  "AlarmSettings",
  (context) => AppLocalizations.of(context)!.alarmTitle,
  [
    StringSetting(
        "Label", (context) => AppLocalizations.of(context)!.labelField, ""),
    SettingGroup(
      "Schedule",
      (context) => AppLocalizations.of(context)!.alarmScheduleSettingGroup,
      [
        SelectSetting<Type>(
          "Type",
          (context) => AppLocalizations.of(context)!.scheduleTypeField,
          [
            SelectSettingOption(
              (context) => AppLocalizations.of(context)!.scheduleTypeOnce,
              OnceAlarmSchedule,
              getDescription: (context) =>
                  AppLocalizations.of(context)!.scheduleTypeOnceDescription,
            ),
            SelectSettingOption(
              (context) => AppLocalizations.of(context)!.scheduleTypeDaily,
              DailyAlarmSchedule,
              getDescription: (context) =>
                  AppLocalizations.of(context)!.scheduleTypeDailyDescription,
            ),
            SelectSettingOption(
              (context) => AppLocalizations.of(context)!.scheduleTypeWeek,
              WeeklyAlarmSchedule,
              getDescription: (context) =>
                  AppLocalizations.of(context)!.scheduleTypeWeekDescription,
            ),
            SelectSettingOption(
              (context) => AppLocalizations.of(context)!.scheduleTypeDate,
              DatesAlarmSchedule,
              getDescription: (context) =>
                  AppLocalizations.of(context)!.scheduleTypeDateDescription,
            ),
            SelectSettingOption(
              (context) => AppLocalizations.of(context)!.scheduleTypeRange,
              RangeAlarmSchedule,
              getDescription: (context) =>
                  AppLocalizations.of(context)!.scheduleTypeRangeDescription,
            ),
          ],
        ),
        ToggleSetting(
          "Week Days",
          (context) => AppLocalizations.of(context)!.alarmWeekdaysSetting,
          weekdays
              .map((weekday) => ToggleSettingOption(
                  (context) => weekday.getAbbreviation(context), weekday.id))
              .toList(),
          enableConditions: [
            ValueCondition(["Type"], (value) => value == WeeklyAlarmSchedule)
          ],
        ),
        DateTimeSetting(
          "Dates",
          (context) => AppLocalizations.of(context)!.alarmDatesSetting,
          [],
          enableConditions: [
            ValueCondition(["Type"], (value) => value == DatesAlarmSchedule)
          ],
        ),
        DateTimeSetting(
          "Date Range",
          (context) => AppLocalizations.of(context)!.alarmRangeSetting,
          [],
          rangeOnly: true,
          enableConditions: [
            ValueCondition(["Type"], (value) => value == RangeAlarmSchedule)
          ],
        ),
        SelectSetting<RangeInterval>(
          "Interval",
          (context) => AppLocalizations.of(context)!.alarmIntervalSetting,
          [
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.alarmIntervalDaily,
                RangeInterval.daily),
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.alarmIntervalWeekly,
                RangeInterval.weekly),
          ],
          enableConditions: [
            ValueCondition(["Type"], (value) => value == RangeAlarmSchedule)
          ],
        ),
        SwitchSetting(
            "Delete After Ringing",
            (context) =>
                AppLocalizations.of(context)!.alarmDeleteAfterRingingSetting,
            false,
            enableConditions: [
              ValueCondition(["Type"], (value) => value == OnceAlarmSchedule)
            ]),
        SwitchSetting(
            "Delete After Finishing",
            (context) =>
                AppLocalizations.of(context)!.alarmDeleteAfterFinishingSetting,
            false,
            enableConditions: [
              ValueCondition(
                ["Type"],
                (value) =>
                    [RangeAlarmSchedule, DatesAlarmSchedule].contains(value),
              )
            ]),
      ],
      icon: Icons.timer,
    ),
    SettingGroup(
      "Sound and Vibration",
      (context) => AppLocalizations.of(context)!.soundAndVibrationSettingGroup,
      [
        SettingGroup(
          "Sound",
          (context) => AppLocalizations.of(context)!.soundSettingGroup,
          [
            DynamicSelectSetting<FileItem>(
              "Melody",
              (context) => AppLocalizations.of(context)!.melodySetting,
              getRingtoneOptions,
              onChange: (context, index) {
                RingtonePlayer.stop();
              },
              actions: [
                MenuAction(
                  "Add",
                  (context) async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const RingtonesScreen()),
                    );
                  },
                  Icons.add,
                ),
              ],
              // shouldCloseOnSelect: false,
            ),
            SelectSetting<AndroidAudioUsage>(
              "Audio Channel",
              (context) => AppLocalizations.of(context)!.audioChannelSetting,
              audioChannelOptions,
              onChange: (context, index) {
                RingtonePlayer.stop();
              },
            ),
            SliderSetting(
                "Volume",
                (context) => AppLocalizations.of(context)!.volumeSetting,
                0,
                100,
                100,
                unit: "%"),
            SwitchSetting(
              "Rising Volume",
              (context) => AppLocalizations.of(context)!.risingVolumeSetting,
              false,

              // description: "Gradually increase volume over time",
            ),
            DurationSetting(
                "Time To Full Volume",
                (context) =>
                    AppLocalizations.of(context)!.timeToFullVolumeSetting,
                const TimeDuration(minutes: 1),
                enableConditions: [
                  ValueCondition(["Rising Volume"], (value) => value == true)
                ]),
          ],
        ),
        SwitchSetting("Vibration",
            (context) => AppLocalizations.of(context)!.vibrationSetting, false),
      ],
      icon: Icons.volume_up,
      summarySettings: [
        "Melody",
        "Vibration",
      ],
    ),
    SettingGroup(
      "Snooze",
      (context) => AppLocalizations.of(context)!.snoozeSettingGroup,
      [
        SwitchSetting(
            "Enabled",
            (context) => AppLocalizations.of(context)!.snoozeEnableSetting,
            true),
        SliderSetting(
            "Length",
            (context) => AppLocalizations.of(context)!.snoozeLengthSetting,
            1,
            30,
            5,
            unit: "minutes",
            enableConditions: [
              ValueCondition(["Enabled"], (value) => value == true)
            ]),
        SliderSetting(
            "Max Snoozes",
            (context) => AppLocalizations.of(context)!.maxSnoozesSetting,
            1,
            10,
            3,
            unit: "times",
            snapLength: 1,
            // description:
            //     "The maximum number of times the alarm can be snoozed before it is dismissed",
            enableConditions: [
              ValueCondition(["Enabled"], (value) => value == true)
            ]),
        SettingGroup(
            "While Snoozed",
            (context) => AppLocalizations.of(context)!.whileSnoozedSettingGroup,
            [
              SwitchSetting(
                  "Prevent Disabling",
                  (context) => AppLocalizations.of(context)!
                      .snoozePreventDisablingSetting,
                  false),
              SwitchSetting(
                  "Prevent Deletion",
                  (context) => AppLocalizations.of(context)!
                      .snoozePreventDeletionSetting,
                  false),
            ],
            enableConditions: [
              ValueCondition(["Enabled"], (value) => value == true)
            ]),
      ],
      icon: Icons.snooze_rounded,
      summarySettings: [
        "Enabled",
        "Length",
      ],
    ),
    ListSetting<AlarmTask>(
      "Tasks",
      (context) => AppLocalizations.of(context)!.tasksSetting,
      [],
      alarmTaskSchemasMap.keys.map((key) => AlarmTask(key)).toList(),
      addCardBuilder: (item) => AlarmTaskCard(task: item, isAddCard: true),
      cardBuilder: (item, [onDelete, onDuplicate]) => AlarmTaskCard(
        task: item,
        isAddCard: false,
        onPressDelete: onDelete,
        onPressDuplicate: onDuplicate,
      ),
      valueDisplayBuilder: (context, setting) {
        return Text("${setting.value.length} tasks");
      },
      itemPreviewBuilder: (item) => TryAlarmTaskButton(alarmTask: item),
      // onChange: (context, value)async{
      //   await appSettings.save();
      // }
    ),
    DynamicMultiSelectSetting<Tag>(
      "Tags",
      (context) => AppLocalizations.of(context)!.tagsSetting,
      getTagOptions,
      defaultValue: [],
      actions: [
        MenuAction(
          "Add",
          (context) async {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TagsScreen()),
            );
          },
          Icons.add,
        ),
      ],
    ),

    // ListSetting<Tag>()
    // CustomSetting<AlarmTaskList>("Tasks", AlarmTaskList([]),
    //     (context, setting) {
    //   return CustomizeAlarmTasksScreen(setting: setting);
    // }, (context, setting) {
    //   return Text("${setting.value.tasks.length} tasks");
    // }),
  ],
);
