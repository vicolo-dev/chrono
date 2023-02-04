import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static SharedPreferences? _preferences;

  static Map<String, void Function()> _listeners = {};

  static SharedPreferences? get preferences {
    if (_preferences == null) {
      throw Exception('SettingsManager not initialized');
    }
    return _preferences;
  }

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> reload() async {
    await _preferences?.reload();
  }

  static void addOnChangeListener(String key, void Function() listener) {
    _listeners[key] = listener;
  }

  static void removeOnChangeListener(String key) {
    _listeners.remove(key);
  }

  static void notifyListeners(String key) {
    _listeners[key]?.call();
  }
}
