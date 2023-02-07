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
    for (var item in items) {
      json[item.name] = item.serialize();
    }
    return json;
  }

  load(Map<String, dynamic> json) {
    for (var item in items) {
      item.deserialize(json[item.name]);
    }
  }
}
