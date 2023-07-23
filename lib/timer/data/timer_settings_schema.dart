import 'package:clock_app/audio/types/audio.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';

import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

SettingGroup timerSettingsSchema = SettingGroup(
  "Timer Setting",
  [
    StringSetting("Label", ""),
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
    SliderSetting("Add Length", 1, 30, 1, unit: "minutes"),
  ],
);
