import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/clock/logic/initialize_default_favorite_cities.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeSettings() async {
  await SettingsManager.initialize();
  SharedPreferences? preferences = SettingsManager.preferences;

  // Used to clear the preferences in case of a change in format of the data
  // Comment this out after the preferences are cleared
  preferences?.clear();

  bool? firstLaunch = SettingsManager.preferences?.getBool('first_launch');
  if (firstLaunch == null) {
    preferences?.setBool('first_launch', false);
    initializeDefaultFavoriteCities();
    saveList<Alarm>('alarms', []);

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
}
