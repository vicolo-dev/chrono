import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/id.dart';
import 'package:clock_app/settings/types/setting_group.dart';

abstract class ThemeItem extends CustomizableListItem {
  late int _id;
  SettingGroup _settings;
  bool _isDefault = false;

  ThemeItem(SettingGroup defaultSettings, bool isDefault, [int? id])
      : _id = id ?? getId(),
        _settings = defaultSettings,
        _isDefault = isDefault;

  ThemeItem.from(ThemeItem themeItem)
      : _id = getId(),
        _isDefault = false,
        _settings = themeItem.settings.copy();

  @override
  int get id => _id;
  @override
  bool get isDeletable => !_isDefault;
  @override
  SettingGroup get settings => _settings;
  bool get isDefault => _isDefault;
  String get name;

  @override
  Json toJson() {
    return {
      'id': id,
      'isDefault': isDefault,
      'settings': settings.valueToJson(),
    };
  }

  @override
  void copyFrom(dynamic other){
    _id = other._id;
    _isDefault = other._isDefault;
    _settings = other._settings.copy();
  }

  ThemeItem.fromJson(Json json, SettingGroup settings) : _settings = settings {
    if (json == null) {
      _id = getId();
      return;
    }
    _id = json['id'] ?? getId();
    _isDefault = json['isDefault'] ?? false;
    settings.loadValueFromJson(json['settings']);
  }
}
