import 'dart:convert';

import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/clock/logic/initialize_default_favorite_cities.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:get_storage/get_storage.dart';

Future<void> initializeSettings() async {
  // await SettingsManager.initialize();
  await GetStorage.init();
  // Used to clear the preferences in case of a change in format of the data
  // Comment this out after the preferences are cleared
  // GetStorage().erase();

  bool? firstLaunch = GetStorage().read('first_launch');
  if (firstLaunch == null) {
    GetStorage().write('first_launch', true);

    initializeDefaultFavoriteCities();
    saveList<Alarm>('alarms', []);
    saveList<ClockTimer>('timers', []);
    saveList<ClockStopwatch>('stopwatches', [ClockStopwatch()]);
    appSettings.save("settings");

    // for (SettingGroup group in settings) {
    //   for (Setting setting in group.settings) {
    //     if (setting is SwitchSetting) {
    //       preferences?.setBool(setting.name, setting._value);
    //     } else if (setting is NumberSetting) {
    //       preferences?.setDouble(setting.name, setting._value);
    //     } else if (setting is ColorSetting) {
    //       preferences?.setInt(setting.name, setting._value.value);
    //     } else if (setting is StringSetting) {
    //       preferences?.setString(setting.name, setting._value);
    //     } else if (setting is SliderSetting) {
    //       preferences?.setDouble(setting.name, setting._value);
    //     } else if (setting is SelectSetting) {
    //       preferences?.setInt(setting.name, setting._value);
    //     }
    //   }
    // }
  }

  appSettings.load("settings");
}
