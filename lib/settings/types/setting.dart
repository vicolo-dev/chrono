import 'package:flutter/material.dart';

abstract class SettingItem {
  String name;

  SettingItem(this.name);

  SettingItem copy();

  dynamic serialize();

  void deserialize(dynamic value);
}

class SettingGroup extends SettingItem {
  String description;
  IconData? icon;
  List<String> summarySettings;

  List<SettingItem> settingItems;

  SettingGroup(String name, this.settingItems,
      {this.icon, this.summarySettings = const [], this.description = ""})
      : super(name);

  @override
  SettingGroup copy() {
    return SettingGroup(
      name,
      settingItems.map((setting) => setting.copy()).toList(),
      icon: icon,
      summarySettings: summarySettings,
      description: description,
    );
  }

  List<Setting> get settings {
    List<Setting> allSettings = [];
    for (var item in settingItems) {
      if (item is Setting) {
        allSettings.add(item);
      } else if (item is SettingGroup) {
        allSettings.addAll(item.settings);
      }
    }
    return allSettings;
  }

  @override
  dynamic serialize() {
    Map<String, dynamic> json = {};
    for (var setting in settingItems) {
      json[setting.name] = setting.serialize();
    }
    return json;
  }

  @override
  void deserialize(dynamic value) {
    for (var setting in settingItems) {
      setting.deserialize(value[setting.name]);
    }
  }
}

class SettingEnableCondition {
  String settingName;
  dynamic value;

  SettingEnableCondition(this.settingName, this.value);
}

abstract class Setting<T> extends SettingItem {
  String description;
  T _value;
  List<SettingEnableCondition> enableConditions;
  void Function(BuildContext context, T)? onChange;

  Setting(String name, this.description, T defaultValue, this.onChange,
      this.enableConditions)
      : _value = defaultValue,
        super(name);

  void setValue(BuildContext context, T value) {
    _value = value;
    onChange?.call(context, value);
  }

  dynamic get value => _value;

  @override
  dynamic serialize() {
    return _value;
  }

  @override
  void deserialize(dynamic value) {
    _value = value;
  }
}

class SwitchSetting extends Setting<bool> {
  SwitchSetting(
    String name,
    bool defaultValue, {
    void Function(BuildContext, bool)? onChange,
    String description = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions);

  @override
  SwitchSetting copy() {
    return SwitchSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
    );
  }
}

class NumberSetting extends Setting<double> {
  NumberSetting(
    String name,
    double defaultValue, {
    void Function(BuildContext, double)? onChange,
    String description = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions);

  @override
  NumberSetting copy() {
    return NumberSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
    );
  }
}

class ColorSetting extends Setting<Color> {
  ColorSetting(
    String name,
    Color defaultValue, {
    void Function(BuildContext, Color)? onChange,
    String description = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions);

  @override
  dynamic serialize() {
    return _value.value;
  }

  @override
  void deserialize(dynamic value) {
    _value = Color(value);
  }

  @override
  ColorSetting copy() {
    return ColorSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
    );
  }
}

class StringSetting extends Setting<String> {
  StringSetting(
    String name,
    String defaultValue, {
    void Function(BuildContext, String)? onChange,
    String description = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions);

  @override
  StringSetting copy() {
    return StringSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
    );
  }
}

class SliderSetting extends Setting<double> {
  double min;
  double max;
  String unit;

  SliderSetting(
    String name,
    this.min,
    this.max,
    double defaultValue, {
    void Function(BuildContext context, double)? onChange,
    String description = "",
    this.unit = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions);

  @override
  SliderSetting copy() {
    return SliderSetting(
      name,
      min,
      max,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
      unit: unit,
    );
  }
}

class SelectSetting<T> extends Setting<int> {
  final List<SelectSettingOption<T>> _options;
  void Function(BuildContext, int, T)? onSelect;

  List<SelectSettingOption<T>> get options => _options;
  int get selectedIndex => _value;
  @override
  dynamic get value => options[selectedIndex].value;
  bool get isColor => T == Color;

  int getIndexOfValue(T value) {
    return options.indexWhere((element) => element.value == value);
  }

  T getValueOfIndex(int index) {
    return options[index].value;
  }

  void onSelectOption(BuildContext context, int index) {
    onSelect?.call(context, index, options[index].value);
  }

  SelectSetting(
    String name,
    this._options, {
    void Function(BuildContext, int)? onChange,
    this.onSelect,
    int defaultValue = 0,
    String description = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions);

  @override
  SelectSetting<T> copy() {
    return SelectSetting(
      name,
      _options,
      defaultValue: _value,
      onChange: onChange,
      onSelect: onSelect,
      description: description,
      enableConditions: enableConditions,
    );
  }
}

class DynamicSelectSetting<T> extends SelectSetting<T> {
  List<SelectSettingOption<T>> Function() optionsGetter;

  @override
  List<SelectSettingOption<T>> get options => optionsGetter();

  DynamicSelectSetting(
    String name,
    this.optionsGetter, {
    void Function(BuildContext, int index)? onChange,
    void Function(BuildContext, int index, T value)? onSelect,
    int defaultValue = 0,
    String description = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(
          name,
          [],
          defaultValue: defaultValue,
          onChange: onChange,
          onSelect: onSelect,
          description: description,
          enableConditions: enableConditions,
        );

  @override
  DynamicSelectSetting<T> copy() {
    return DynamicSelectSetting(
      name,
      optionsGetter,
      onChange: onChange,
      onSelect: onSelect,
      description: description,
      defaultValue: _value,
      enableConditions: enableConditions,
    );
  }
}

class ToggleSetting<T> extends Setting<List<bool>> {
  List<ToggleSettingOption<T>> options;

  List<T> get selected {
    List<T> values = [];
    for (int i = 0; i < _value.length; i++) {
      if (_value[i]) {
        values.add(options[i].value);
      }
    }
    return values;
  }

  ToggleSetting(
    String name,
    this.options, {
    void Function(BuildContext, List<bool>)? onChange,
    List<bool> defaultValue = const [],
    String description = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(
          name,
          description,
          defaultValue.length == options.length
              ? defaultValue
              : List.generate(options.length, (index) => index == 0),
          onChange,
          enableConditions,
        );

  @override
  ToggleSetting<T> copy() {
    return ToggleSetting(
      name,
      options,
      defaultValue: _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
    );
  }

  void toggle(BuildContext context, int index) {
    if (_value.where((option) => option == true).length == 1 && _value[index]) {
      return;
    }
    _value[index] = !_value[index];
    onChange?.call(context, _value);
  }

  @override
  dynamic serialize() {
    return _value.map((e) => e ? "1" : "0").toList();
  }

  @override
  void deserialize(dynamic value) {
    _value = (value as List).map((e) => e == "1").toList();
  }
}

class DateTimeSetting extends Setting<DateTime> {
  DateTimeSetting(
    String name,
    DateTime defaultValue, {
    void Function(BuildContext, DateTime)? onChange,
    String description = "",
    List<SettingEnableCondition> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions);

  @override
  DateTimeSetting copy() {
    return DateTimeSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
    );
  }
}

class ToggleSettingOption<T> {
  String name;
  T value;

  ToggleSettingOption(this.name, this.value);
}

class SelectSettingOption<T> {
  String name;
  String description;
  T value;

  SelectSettingOption(this.name, this.value, {this.description = ""});
}
