import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/clock/logic/initialize_default_favorite_cities.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/theme/data/default_color_schemes.dart';
import 'package:clock_app/theme/data/default_style_themes.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/timer/logic/initialize_default_timer_presets.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

Future<void> _clearSettings() async {
  List<ClockTimer> timers = await loadList<ClockTimer>('timers');
  List<Alarm> alarms = await loadList<Alarm>('alarms');
  // We need to remove all scheduled alarms and timers before clearing the data
  // Otherwise, there would be no way to remove them in the future
  for (var alarm in alarms) {
    alarm.cancel();
  }
  for (var timer in timers) {
    timer.reset();
  }
  await GetStorage().erase();
}

Future<void> initializeSettings() async {
  await GetStorage.init();

  // Used to clear the preferences in case of a change in format of the data
  // Comment this out after the preferences are cleared
  if (kDebugMode) await _clearSettings();

  bool? firstLaunch = GetStorage().read('first_launch');
  if (firstLaunch == null) {
    GetStorage().write('first_launch', true);

    // This is used to show alarm and timer edit animations
    GetStorage().write('first_alarm_created', false);
    GetStorage().write('first_timer_created', false);

    initializeDefaultFavoriteCities();
    initializeDefaultTimerPresets();
    initializeDefaultAlarms();
    saveList<ClockTimer>('timers', []);
    saveList<ClockStopwatch>('stopwatches', [ClockStopwatch()]);
    saveList<ColorSchemeData>('color_schemes', defaultColorSchemes);
    saveList<StyleTheme>('style_themes', defaultStyleThemes);
    saveTextFile("time_format_string", "h:mm a");

    // Save the schema to disk on first launch
    appSettings.save();
  }

  appSettings.load();
}

void initializeDefaultAlarms() {
  saveList<Alarm>('alarms', []);
}
