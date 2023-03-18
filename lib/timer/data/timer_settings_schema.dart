import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

Settings timerSettingsSchema = Settings(
  [
    StringSetting("Label", ""),
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
      ],
    ),
    SliderSetting("Add Length", 1, 30, 1, unit: "minutes"),
  ],
);
