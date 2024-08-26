import 'dart:convert';

import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/backup_option.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:clock_app/widgets/logic/update_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Order of BackupOption matters
// tags should be before alarms and timers
// color_schemes and style_themes should be before settings
final backupOptions = [
   BackupOption(
    "tags",
    (context) => AppLocalizations.of(context)!.presetsSetting,
    encode: () async {
      return await loadTextFile("tags");
    },
    decode: (context, value) async {
      await saveList<TimerPreset>("tags", [
        ...listFromString<TimerPreset>(value),
        ...await loadList<TimerPreset>("tags")
      ]);
    },
  ),
  BackupOption(
    "color_schemes",
    (context) => AppLocalizations.of(context)!.colorSchemeSetting,
    encode: () async {
      List<ColorSchemeData> colorSchemes =
          await loadList<ColorSchemeData>("color_schemes");
      List<ColorSchemeData> customColorSchemes =
          colorSchemes.where((scheme) => !scheme.isDefault).toList();
      return listToString(customColorSchemes);
    },
    decode: (context, value) async {
      await saveList<ColorSchemeData>("color_schemes", [
        ...listFromString<ColorSchemeData>(value),
        ...await loadList<ColorSchemeData>("color_schemes")
      ]);
      if (context.mounted) App.refreshTheme(context);
    },
  ),
  BackupOption(
    "style_themes",
    (context) => AppLocalizations.of(context)!.styleThemeSetting,
    encode: () async {
      List<StyleTheme> styleThemes = await loadList<StyleTheme>("style_themes");
      List<StyleTheme> customThemes =
          styleThemes.where((scheme) => !scheme.isDefault).toList();
      return listToString(customThemes);
    },
    decode: (context, value) async {
      await saveList<StyleTheme>("style_themes", [
        ...listFromString<StyleTheme>(value),
        ...await loadList<StyleTheme>("style_themes")
      ]);
      if (context.mounted) App.refreshTheme(context);
    },
  ),
  BackupOption(
    "settings",
    (context) => AppLocalizations.of(context)!.settings,
    encode: () async {
      return json.encode(appSettings.valueToJson());
    },
    decode: (context, value) async {
      appSettings.loadValueFromJson(json.decode(value));
      appSettings.callAllListeners();
      App.refreshTheme(context);
      await appSettings.save();
      if (context.mounted) {
        setDigitalClockWidgetData(context);
      }
    },
  ),
  BackupOption(
    "alarms",
    (context) => AppLocalizations.of(context)!.alarmTitle,
    encode: () async {
      return await loadTextFile("alarms");
    },
    decode: (context, value) async {
      await saveList<Alarm>("alarms", [
        ...listFromString<Alarm>(value),
        ...await loadList<Alarm>("alarms")
      ]);
      await updateAlarms("Updated alarms on importing backup");
    },
  ),
  BackupOption(
    "timers",
    (context) => AppLocalizations.of(context)!.timerTitle,
    encode: () async {
      return await loadTextFile("timers");
    },
    decode: (context, value) async {
      await saveList<ClockTimer>("timers", [
        ...listFromString<ClockTimer>(value),
        ...await loadList<ClockTimer>("timers")
      ]);
      await updateTimers("Updated timers on importing backup");
    },
  ),
  BackupOption(
    "favorite_cities",
    (context) => AppLocalizations.of(context)!.clockTitle,
    encode: () async {
      return await loadTextFile("favorite_cities");
    },
    decode: (context, value) async {
      await saveList<City>("favorite_cities", [
        ...listFromString<City>(value),
        // ...await loadList<City>("favorite_cities")
      ]);
      // await updateTimers("Updated timers on importing backup");
    },
  ),

  // BackupOption(
  //   "stopwatches",
  //   (context) => AppLocalizations.of(context)!.stopwatchTitle,
  //   encode: () async {
  //     return await loadTextFile("stopwatches");
  //   },
  //   decode: (context, value) async {
  //     await saveList<ClockTimer>("stopwatches", [
  //       ...listFromString<ClockTimer>(value),
  //     ]);
  //   },
  // ),

   BackupOption(
    "timer_presets",
    (context) => AppLocalizations.of(context)!.presetsSetting,
    encode: () async {
      return await loadTextFile("timer_presets");
    },
    decode: (context, value) async {
      await saveList<TimerPreset>("timer_presets", [
        ...listFromString<TimerPreset>(value),
        ...await loadList<TimerPreset>("timer_presets")
      ]);
    },
  ),

];
