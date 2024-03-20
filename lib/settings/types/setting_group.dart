import 'dart:convert';

import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SettingGroup extends SettingItem {
  final int? _version;
  final IconData? _icon;
  final List<String> _summarySettings;
  final bool? _showExpandedView;
  final List<SettingItem> _settingItems;
  final List<Setting> _settings;
  final List<SettingPageLink> _settingPageLinks;
  final List<SettingAction> _settingActions;
  final List<SettingGroup> _settingGroups;
  final bool _isSearchable;

  IconData? get icon => _icon;
  List<String> get summarySettings => _summarySettings;
  bool? get showExpandedView => _showExpandedView;
  List<Setting> get settings => _settings;
  List<SettingPageLink> get settingPageLinks => _settingPageLinks;
  List<SettingAction> get settingActions => _settingActions;
  List<SettingGroup> get settingGroups => _settingGroups;
  List<SettingItem> get settingItems => _settingItems;
  bool get isSearchable => _isSearchable;
  bool get isEmpty => !_settings.any((setting) => setting.isEnabled);

  SettingGroup(
    String name,
    this._settingItems, {
    int? version,
    IconData? icon,
    List<SettingEnableConditionParameter> enableConditions = const [],
    List<String> summarySettings = const [],
    String description = "",
    bool? showExpandedView,
    bool isSearchable = false,
    List<String> searchTags = const [],
  })  : _icon = icon,
        _summarySettings = summarySettings,
        _showExpandedView = showExpandedView,
        _isSearchable = isSearchable,
        _settingGroups = [],
        _settings = [],
        _settingPageLinks = [],
        _settingActions = [],
        _version = version,
        super(name, description, searchTags, enableConditions) {
    for (SettingItem item in _settingItems) {
      item.parent = this;
      if (item is Setting) {
        _settings.add(item);
      } else if (item is SettingPageLink) {
        _settingPageLinks.add(item);
      } else if (item is SettingAction) {
        _settingActions.add(item);
      } else if (item is SettingGroup) {
        _settingGroups.add(item);
        _settingGroups.addAll(item.settingGroups);
        _settings.addAll(item.settings);
        _settingPageLinks.addAll(item.settingPageLinks);
        _settingActions.addAll(item.settingActions);
      }

      for (var enableCondition in item.enableConditions) {
        Setting setting = getSettingFromPath(enableCondition.settingPath);
        item.enableSettings
            .add(SettingEnableCondition(setting, enableCondition.value));
        // print(
        //     "${item.name} is enabled by ${setting.name} = ${enableCondition.value}");
        setting.changesEnableCondition = true;
      }
    }
  }

  @override
  SettingGroup copy() {
    return SettingGroup(
      name,
      _settingItems.map((setting) => setting.copy()).toList(),
      icon: icon,
      searchTags: searchTags,
      enableConditions: enableConditions,
      version: _version,
      isSearchable: isSearchable,
      showExpandedView: showExpandedView,
      summarySettings: _summarySettings,
      description: description,
    );
  }

  SettingGroup getGroup(String name) {
    return _settingGroups.firstWhere((item) => item.name == name);
  }

  Setting getSettingFromPath(List<String> path) {
    SettingItem currentItem = this;
    for (var pathItem in path) {
      // print("current item: ${currentItem.name}");
      // if (pathItem == "..") {
      //   if (currentItem.parent == null) {
      //     throw Exception("Could not find setting with path $path");
      //   } else {
      //     currentItem = currentItem.parent!;
      //     continue;
      //   }
      // }
      if (currentItem is SettingGroup) {
        currentItem = currentItem.getSettingItem(pathItem);
      }
    }
    if (currentItem is Setting) {
      return currentItem;
    } else {
      throw Exception("Could not find setting with path $path");
    }
  }

  SettingItem getSettingItem(String name) {
    try {
      return _settingItems.firstWhere((item) => item.name == name);
    } catch (e) {
      if (kDebugMode) {
        print("Could not find setting item $name: $e");
      }
      rethrow;
    }
  }

  Setting getSetting(String name) {
    try {
      return _settings.firstWhere((item) => item.name == name);
    } catch (e) {
      if (kDebugMode) {
        print("Could not find setting $name: $e");
      }
      rethrow;
    }
  }

  void restoreDefaults(
    BuildContext context,
    Map<String, bool> settingsToRestore,
  ) {
    for (var settingItem in _settingItems) {
      if (settingItem is SettingPageLink) {
        continue;
      }
      if (settingsToRestore.containsKey(settingItem.id)) {
        if (!settingsToRestore[settingItem.id]!) {
          continue;
        }
      }
      if (settingItem is Setting) {
        settingItem.restoreDefault(context);
      } else if (settingItem is SettingGroup) {
        settingItem.restoreDefaults(context, settingsToRestore);
      }
    }
  }

  @override
  dynamic valueToJson() {
    Json json = {};
    if (_version != null) json["version"] = _version;
    for (var setting in _settingItems) {
      json[setting.name] = setting.valueToJson();
    }
    return json;
  }

  void callAllListeners() {
    for (var setting in settings) {
      setting.callListeners(setting);
    }
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null) return;
    if (_version != null && value["version"] != _version) {
      //TODO: Add migration code

      //In case of name change:
      //value["New Name"] = value["Old Name"];
      //OR
      //value["Group 1"]["New Name"] = value["Group 1"]["Old Name"];
      //value.remove("Old Name");

      //Incase of addition
      //value["New Setting"] = defaultValue;

      //Incase of removal
      //value.remove("Old Setting");

      if (name == "AlarmSettings") {
        if (value["version"] == 1) {
          final old1 = value["Snooze"]["Prevent Disabling while Snoozed"];
          final old2 = value["Snooze"]["Prevent Deleting while Snoozed"];
          if (old1) {
            value["Snooze"]["While Snoozed"]["Prevent Disabling"] = old1;
          }
          if (old2) value["Snooze"]["While Snoozed"]["Prevent Deletion"] = old2;
        }
      }
    }
    for (var setting in _settingItems) {
      if (value != null) setting.loadValueFromJson(value[setting.name]);
    }
  }

  Future<void> save() {
    return GetStorage().write(id, json.encode(valueToJson()));
  }

  void load() {
    loadValueFromJson(json.decode(GetStorage().read(id)));
  }
}
