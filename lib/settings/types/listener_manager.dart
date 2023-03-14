import 'dart:isolate';

import 'package:clock_app/common/utils/debug.dart';
import 'package:flutter/foundation.dart';

class ListenerManager {
  static final Map<String, List<void Function()>> _listeners = {};

  // static SharedPreferences? get preferences {
  //   if (_preferences == null) {
  //     throw Exception('SettingsManager not initialized');
  //   }
  //   return _preferences;
  // }

  // static Future<void> initialize() async {
  //   _preferences = await SharedPreferences.getInstance();
  // }

  // static Future<void> reload() async {
  //   await _preferences?.reload();
  // }

  static void addOnChangeListener(String key, void Function() listener) {
    final listeners = _listeners[key];
    if (listeners == null) {
      _listeners[key] = [listener];
    } else {
      listeners.add(listener);
    }
  }

  static void removeOnChangeListener(String key, void Function() listener) {
    _listeners[key]?.remove(listener);
  }

  // static void removeAllOnChangeListener(String key) {
  //   _listeners.remove(key);
  // }

  static void notifyListeners(String key) {
    _listeners[key]?.forEach((listener) => listener());
  }
}
