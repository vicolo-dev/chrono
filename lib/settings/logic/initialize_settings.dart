import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/audio/logic/system_ringtones.dart';
import 'package:clock_app/clock/data/default_favorite_cities.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/common/data/default_tags.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/schedule_id.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/theme/data/default_color_schemes.dart';
import 'package:clock_app/theme/data/default_style_themes.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/timer/data/default_timer_presets.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';


Future<void> _clearSettings() async {
  // List<ClockTimer> timers = await loadList<ClockTimer>('timers');
  // List<Alarm> alarms = await loadList<Alarm>('alarms');
  // We need to remove all scheduled alarms and timers before clearing the data
  // Otherwise, there would be no way to remove them in the future

  // for (var timer in timers) {
  //   timer.reset();
  // }
  await cancelAllAlarms();
  await cancelAllTimers();
  await GetStorage().erase();

  // Delete all files in custom melodies directory
  final ringtonesDir = Directory(await getRingtonesDirectoryPath());
  ringtonesDir.deleteSync(recursive: true);
  ringtonesDir.createSync(recursive: true);

  final dataDir = Directory(await getAppDataDirectoryPath());
  dataDir.deleteSync(recursive: true);
  dataDir.createSync(recursive: true);

  AwesomeNotifications().cancelAll();
}

Future<void> initializeStorage([bool clearSettingsOnDebug = true]) async {
  await GetStorage.init();

  // Used to clear the preferences in case of a change in format of the data
  // Comment this out after the preferences are cleared
  if (kDebugMode && clearSettingsOnDebug) await _clearSettings();

  bool? firstLaunch = GetStorage().read('first_launch');
  if (firstLaunch == null) {
    // This is used to show alarm and timer edit animations
    GetStorage().write('first_alarm_created', false);
    GetStorage().write('first_timer_created', false);
  }

  await initList<Alarm>("alarms", []);
  await initList<Tag>("tags", defaultTags);
  await initList<AlarmEvent>("alarm_events", []);
  await initList<ScheduleId>('schedule_ids', []);
  await initList<ClockTimer>('timers', []);
  await initList<City>('favorite_cities', initialFavoriteCities);
  await initList<ClockStopwatch>('stopwatches', [ClockStopwatch()]);
  await initList<ColorSchemeData>('color_schemes', defaultColorSchemes);
  await initList<StyleTheme>('style_themes', defaultStyleThemes);
  await initList<TimerPreset>("timer_presets", defaultTimerPresets);
  await initList<FileItem>("ringtones", await getSystemRingtones());
  await initTextFile("time_format_string", "h:mm a");
}

Future<void> initializeSettings() async {
  bool? firstLaunch = GetStorage().read('first_launch');
  if (firstLaunch == null) {
    GetStorage().write('first_launch', true);
    // Save the schema to disk on first launch
    await appSettings.save();
  }

  appSettings.load();
}
