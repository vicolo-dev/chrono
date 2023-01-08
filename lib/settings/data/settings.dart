import 'dart:ui';

import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/settings/types/setting.dart';

List<SettingGroup> settings = [
  SettingGroup(
      "General",
      [
        SelectSetting(
          "Time Format",
          [
            SettingOption("12 hour"),
            SettingOption("24 hour"),
            SettingOption("System")
          ],
          1,
          "12 or 24 hour time",
        ),
      ],
      FluxIcons.settings),
  SettingGroup(
    "Appearance",
    [
      SelectSetting(
          "Theme",
          [
            SettingOption("Light"),
            SettingOption("Dark"),
            SettingOption("Amoled"),
            SettingOption("System"),
          ],
          1),
      ColorSetting("Accent Color", const Color.fromARGB(255, 9, 163, 184)),
    ],
    FluxIcons.settings,
  ),
];

const List<City> initialFavoriteCities = [
  City("New York", "United States", "America/New_York"),
  City("London", "United Kingdom", "Europe/London"),
  City("Paris", "France", "Europe/Paris"),
  City("Tokyo", "Japan", "Asia/Tokyo"),
];

class Settings {
  static SharedPreferences? _preferences;

  static initialize() async {
    _preferences = await SharedPreferences.getInstance();

    // Comment this out after the preferences are cleared
    // _preferences?.clear();

    bool? firstLaunch = _preferences?.getBool('first_launch');
    if (firstLaunch == null) {
      _preferences?.setBool('first_launch', false);
      saveFavoriteCities(initialFavoriteCities);

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

  static List<City> loadFavoriteCities() {
    final String? encodedFavoriteCities =
        _preferences?.getString('favorite_cities');

    if (encodedFavoriteCities == null) {
      return [];
    }

    return City.decode(encodedFavoriteCities);
  }

  static void saveFavoriteCities(List<City> cities) {
    _preferences?.setString('favorite_cities', City.encode(cities));
  }
}
