import 'package:audio_session/audio_session.dart';
import 'package:clock_app/audio/audio_channels.dart';
import 'package:clock_app/audio/screens/ringtones_screen.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/logic/tags.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/popup_action.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/ringtones.dart';
import 'package:clock_app/settings/screens/tags_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

const timerSettingSchemeVersion = 1;

SettingGroup timerSettingsSchema = SettingGroup(
  version: timerSettingSchemeVersion,
  "Timer Setting",
  (context) => "Timer Setting",
  [
    StringSetting(
        "Label", (context) => AppLocalizations.of(context)!.labelField, ""),
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
                    await Navigator.of(context).push(
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
                audioChannelOptions, onChange: (context, index) {
              RingtonePlayer.stop();
            }),
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
    SliderSetting("Add Length",
        (context) => AppLocalizations.of(context)!.addLengthSetting, 1, 30, 1,
        unit: "minutes", snapLength: 1),
    DynamicMultiSelectSetting<Tag>(
      "Tags",
      (context) => AppLocalizations.of(context)!.tagsSetting,
      getTagOptions,
      defaultValue: [],
      actions: [
        MenuAction(
          "Add",
          (context) async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TagsScreen()),
            );
          },
          Icons.add,
        ),
      ],
    ),
  ],
);
