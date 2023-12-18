import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

abstract class ThemeItem extends CustomizableListItem {
  late final int _id;
  final SettingGroup _settings;
  bool _isDefault = false;

  ThemeItem(SettingGroup defaultSettings, bool isDefault, [int? id])
      : _id = id ?? UniqueKey().hashCode,
        _settings = defaultSettings,
        _isDefault = isDefault;

  ThemeItem.from(ThemeItem themeItem)
      : _id = UniqueKey().hashCode,
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

  ThemeItem.fromJson(Json json, SettingGroup settings) : _settings = settings {
    if (json == null) {
      _id = UniqueKey().hashCode;
      return;
    }
    _id = json['id'] ?? UniqueKey().hashCode;
    _isDefault = json['isDefault'] ?? false;
    settings.loadValueFromJson(json['settings']);
  }
}
