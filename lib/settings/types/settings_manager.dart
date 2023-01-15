import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static SharedPreferences? _preferences;

  static SharedPreferences? get preferences => _preferences;

  static initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }
}
