import 'package:clock_app/common/types/clock_settings_types.dart';
import 'package:clock_app/common/widgets/clock/digital_clock.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SettingGroup clockSettingsSchema = SettingGroup(
  "clock",
  (context) => AppLocalizations.of(context)!.clockTitle,
  [
    SettingGroup(
      "clockStyle",
      (context) => AppLocalizations.of(context)!.clockStyleSettingGroup,
      [
        SelectSetting<ClockType>(
          "clockType",
          (context) => AppLocalizations.of(context)!.clockTypeSetting,
          [
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.digitalClock,
                ClockType.digital),
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.analogClock,
                ClockType.analog),
          ],
          searchTags: ["analog", "digital", "face"],
        ),
        SelectSetting<ClockNumbersType>(
          "showNumbers",
          (context) => AppLocalizations.of(context)!.showNumbersSetting,
          [
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.allNumbers,
                ClockNumbersType.all),
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.quarterNumbers,
                ClockNumbersType.quarter),
            SelectSettingOption((context) => AppLocalizations.of(context)!.none,
                ClockNumbersType.none),
          ],
          enableConditions: [
            ValueCondition(["clockType"], (value) => value == ClockType.analog),
          ],
          defaultValue: 1,
          searchTags: ["analog", "digital", "face"],
        ),
        SelectSetting<ClockNumeralType>(
          "numeralType",
          (context) => AppLocalizations.of(context)!.numeralTypeSetting,
          [
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.arabicNumeral,
                ClockNumeralType.arabic),
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.romanNumeral,
                ClockNumeralType.roman),
          ],
          searchTags: ["roman", "arabic", "number", "numeral"],
          enableConditions: [
            ValueCondition(["clockType"], (value) => value == ClockType.analog),
            ValueCondition(
                ["showNumbers"], (value) => value != ClockNumbersType.none)
          ],
        ),
        SelectSetting<ClockTicksType>(
          "showTicks",
          (context) => AppLocalizations.of(context)!.showClockTicksSetting,
          [
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.allTicks,
                ClockTicksType.all),
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.majorTicks,
                ClockTicksType.major),
            SelectSettingOption((context) => AppLocalizations.of(context)!.none,
                ClockTicksType.none),
          ],
          enableConditions: [
            ValueCondition(["clockType"], (value) => value == ClockType.analog),
          ],
          defaultValue: 1,
          searchTags: ["ticks", "mark"],
        ),
        SwitchSetting(
          'showDigitalClock',
          (context) => AppLocalizations.of(context)!.showDigitalClock,
          false,
          searchTags: ["digital", "time"],
          enableConditions: [
            ValueCondition(["clockType"], (value) => value == ClockType.analog),
          ],
        ),
      ],
      // description: "Show comparison laps bars in stopwatch",
      icon: Icons.palette_outlined,
      searchTags: ["clock face", "ui"],
    ),
  ],
  icon: FluxIcons.clock,
);
