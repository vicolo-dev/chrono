import 'package:clock_app/settings/types/setting.dart';

class Settings {
  List<SettingItem> items;

  Settings(this.items);

  Setting getSetting(String name) {
    return items
        .whereType<Setting>()
        .firstWhere((element) => element.name == name, orElse: () {
      // search in groups
      List<SettingGroup> groups = items.whereType<SettingGroup>().toList();
      for (var group in groups) {
        List<Setting> settings = group.settings
            .whereType<Setting>()
            .where((element) => element.name == name)
            .toList();
        if (settings.isNotEmpty) {
          return settings.first;
        }
      }

      return StringSetting("Error", "Setting not found");
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    for (var setting in items) {
      if (setting is Setting) {
        json[setting.name] = setting.serialize();
      }
    }
    return json;
  }

  load(Map<String, dynamic> json) {
    for (var setting in items) {
      if (setting is Setting) {
        setting.deserialize(json[setting.name]);
      }
    }
  }
}
