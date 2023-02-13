import 'package:clock_app/settings/types/setting.dart';

class Settings {
  List<SettingItem> items;

  final Map<String, List<void Function(dynamic)>> _settingListeners;

  final List<Setting> _settings = [];

  Settings(this.items) : _settingListeners = {} {
    for (var item in items) {
      if (item is Setting) {
        settings.add(item);
      } else if (item is SettingGroup) {
        settings.addAll(item.settings);
      }
    }
  }

  Map<String, List<void Function(dynamic)>> get settingListeners =>
      _settingListeners;

  List<Setting> get settings => _settings;

  void addSettingListener(String settingName, void Function(dynamic) listener) {
    if (!_settingListeners.containsKey(settingName)) {
      _settingListeners[settingName] = [];
    }

    _settingListeners[settingName]?.add(listener);
  }

  void removeSettingListener(
      String settingName, void Function(dynamic) listener) {
    if (_settingListeners.containsKey(settingName)) {
      _settingListeners[settingName]?.remove(listener);
    }
  }

  Settings copy() {
    return Settings(items.map((item) => item.copy()).toList());
  }

  Setting getSetting(String name) {
    return settings.firstWhere((setting) => setting.name == name);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    for (var item in items) {
      json[item.name] = item.serialize();
    }
    return json;
  }

  void load(Map<String, dynamic> json) {
    for (var item in items) {
      item.deserialize(json[item.name]);
    }
  }
}
