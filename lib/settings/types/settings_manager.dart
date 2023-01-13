import 'package:clock_app/settings/data/settings_data.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clock_app/clock/data/favorite_cities.dart';

class SettingsManager {
  static SharedPreferences? _preferences;

  static SharedPreferences? get preferences => _preferences;

  static initialize() async {
    _preferences = await SharedPreferences.getInstance();

    // Used to clear the preferences in case of a change in format of the data
    // Comment this out after the preferences are cleared
    _preferences?.clear();

    bool? firstLaunch = _preferences?.getBool('first_launch');
    if (firstLaunch == null) {
      _preferences?.setBool('first_launch', false);
      initializeDefaultFavoriteCities();

      for (SettingGroup group in settings) {
        for (Setting setting in group.settings) {
          if (setting is ToggleSetting) {
            _preferences?.setBool(setting.name, setting.defaultValue);
          } else if (setting is NumberSetting) {
            _preferences?.setDouble(setting.name, setting.defaultValue);
          } else if (setting is ColorSetting) {
            _preferences?.setInt(setting.name, setting.defaultValue.value);
          } else if (setting is StringSetting) {
            _preferences?.setString(setting.name, setting.defaultValue);
          } else if (setting is SliderSetting) {
            _preferences?.setDouble(setting.name, setting.defaultValue);
          } else if (setting is SelectSetting) {
            _preferences?.setInt(setting.name, setting.defaultValue);
          }
        }
      }
    }
  }
}
