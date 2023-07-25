import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

class SettingEnableConditionParameter {
  String settingName;
  dynamic value;

  SettingEnableConditionParameter(this.settingName, this.value);
}

class SettingEnableCondition {
  Setting setting;
  dynamic value;

  SettingEnableCondition(this.setting, this.value);
}

abstract class Setting<T> extends SettingItem {
  String description;
  T _value;
  final T _defaultValue;
  List<SettingEnableConditionParameter> enableConditions;
  // Settings which influence whether this setting is enabled
  List<SettingEnableCondition> enableSettings;
  // Whether another setting depends on the value of this setting
  bool changesEnableCondition;
  void Function(BuildContext context, T)? onChange;
  // Whether to show this setting in settings screen
  final bool isVisual;

  final List<void Function(dynamic)> _settingListeners;
  List<void Function(dynamic)> get settingListeners => _settingListeners;
  bool get isEnabled {
    for (var enableSetting in enableSettings) {
      if (enableSetting.setting.value != enableSetting.value) {
        return false;
      }
    }
    return true;
  }

  Setting(String name, this.description, T defaultValue, this.onChange,
      this.enableConditions, this.isVisual)
      : _value = defaultValue,
        _defaultValue = defaultValue,
        _settingListeners = [],
        enableSettings = [],
        changesEnableCondition = false,
        super(name);

  void addListener(void Function(dynamic) listener) {
    _settingListeners.add(listener);
  }

  void removeListener(void Function(dynamic) listener) {
    _settingListeners.remove(listener);
  }

  void setValue(BuildContext context, T value) {
    _value = value;
    for (var listener in _settingListeners) {
      listener(value);
    }
    onChange?.call(context, value);
  }

  void restoreDefault(BuildContext context) {
    setValue(context, _defaultValue);
  }

  void setValueWithoutNotify(T value) {
    _value = value;
  }

  dynamic get value => _value;
  dynamic get defaultValue => _defaultValue;

  @override
  dynamic toJson() {
    return _value;
  }

  @override
  void fromJson(dynamic value) {
    _value = value;
  }
}

class CustomSetting<T extends JsonSerializable> extends Setting<T> {
  Widget Function(CustomSetting<T>) builder;
  String Function(CustomSetting<T>) nameGetter;

  CustomSetting(
    String name,
    T defaultValue,
    this.builder,
    this.nameGetter, {
    String description = "",
    void Function(BuildContext, T)? onChange,
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  Widget getWidget() {
    return builder(this);
  }

  String getValueName() {
    return nameGetter(this);
  }

  @override
  CustomSetting<T> copy() {
    return CustomSetting<T>(
      name,
      _defaultValue,
      builder,
      nameGetter,
      description: description,
      onChange: onChange,
      enableConditions: enableConditions,
      isVisual: isVisual,
    );
  }

  @override
  dynamic toJson() {
    return _value.toJson();
  }

  @override
  void fromJson(dynamic value) {
    _value = fromJsonFactories[T]!(value);
  }
}

class SwitchSetting extends Setting<bool> {
  SwitchSetting(
    String name,
    bool defaultValue, {
    void Function(BuildContext, bool)? onChange,
    String description = "",
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  @override
  SwitchSetting copy() {
    return SwitchSetting(name, _value,
        onChange: onChange,
        description: description,
        enableConditions: enableConditions,
        isVisual: isVisual);
  }
}

class NumberSetting extends Setting<double> {
  NumberSetting(
    String name,
    double defaultValue, {
    void Function(BuildContext, double)? onChange,
    String description = "",
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  @override
  NumberSetting copy() {
    return NumberSetting(name, _value,
        onChange: onChange,
        description: description,
        enableConditions: enableConditions,
        isVisual: isVisual);
  }
}

class ColorSetting extends Setting<Color> {
  ColorSetting(
    String name,
    Color defaultValue, {
    void Function(BuildContext, Color)? onChange,
    String description = "",
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  @override
  dynamic toJson() {
    return _value.value;
  }

  @override
  void fromJson(dynamic value) {
    _value = Color(value);
  }

  @override
  ColorSetting copy() {
    return ColorSetting(name, _value,
        onChange: onChange,
        description: description,
        enableConditions: enableConditions,
        isVisual: isVisual);
  }
}

class StringSetting extends Setting<String> {
  StringSetting(
    String name,
    String defaultValue, {
    void Function(BuildContext, String)? onChange,
    String description = "",
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  @override
  StringSetting copy() {
    return StringSetting(name, _value,
        onChange: onChange,
        description: description,
        enableConditions: enableConditions,
        isVisual: isVisual);
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
    bool isVisual = true,
    this.unit = "",
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  @override
  SliderSetting copy() {
    return SliderSetting(name, min, max, _value,
        onChange: onChange,
        description: description,
        enableConditions: enableConditions,
        unit: unit,
        isVisual: isVisual);
  }
}

class SelectSetting<T> extends Setting<int> {
  final List<SelectSettingOption<T>> _options;
  void Function(BuildContext, int, T)? onSelect;
  final bool shouldCloseOnSelect;

  List<SelectSettingOption<T>> get options => _options;
  int get selectedIndex => _value;
  @override
  dynamic get value => options[selectedIndex].value;
  // bool get isColor => T == Color;

  int getIndexOfValue(T value) {
    return options.indexWhere((element) => element.value == value);
  }

  T getValueOfIndex(int index) {
    return options[index].value;
  }

  void onSelectOption(BuildContext context, int index) {
    onSelect?.call(context, index, options[index].value);
  }

  @override
  void restoreDefault(BuildContext context) {
    setValue(context, _defaultValue);
    onSelectOption(context, _defaultValue);
  }

  SelectSetting(
    String name,
    this._options, {
    void Function(BuildContext, int)? onChange,
    this.onSelect,
    int defaultValue = 0,
    String description = "",
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
    this.shouldCloseOnSelect = true,
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  @override
  SelectSetting<T> copy() {
    return SelectSetting(name, _options,
        defaultValue: _value,
        onChange: onChange,
        onSelect: onSelect,
        description: description,
        enableConditions: enableConditions,
        shouldCloseOnSelect: shouldCloseOnSelect,
        isVisual: isVisual);
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
    bool isVisual = true,
    bool shouldCloseOnSelect = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(
          name,
          [],
          defaultValue: defaultValue,
          onChange: onChange,
          onSelect: onSelect,
          description: description,
          enableConditions: enableConditions,
          shouldCloseOnSelect: shouldCloseOnSelect,
          isVisual: isVisual,
        );

  @override
  DynamicSelectSetting<T> copy() {
    return DynamicSelectSetting(name, optionsGetter,
        onChange: onChange,
        onSelect: onSelect,
        description: description,
        defaultValue: _value,
        enableConditions: enableConditions,
        shouldCloseOnSelect: shouldCloseOnSelect,
        isVisual: isVisual);
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

  ToggleSetting(String name, this.options,
      {void Function(BuildContext, List<bool>)? onChange,
      List<bool> defaultValue = const [],
      String description = "",
      bool isVisual = true,
      List<SettingEnableConditionParameter> enableConditions = const []})
      : super(
          name,
          description,
          defaultValue.length == options.length
              ? defaultValue
              : List.generate(options.length, (index) => index == 0),
          onChange,
          enableConditions,
          isVisual,
        );

  @override
  ToggleSetting<T> copy() {
    return ToggleSetting(name, options,
        defaultValue: _value,
        onChange: onChange,
        description: description,
        enableConditions: enableConditions,
        isVisual: isVisual);
  }

  void toggle(BuildContext context, int index) {
    if (_value.where((option) => option == true).length == 1 && _value[index]) {
      return;
    }
    _value[index] = !_value[index];
    onChange?.call(context, _value);
  }

  @override
  dynamic toJson() {
    return _value.map((e) => e ? "1" : "0").toList();
  }

  @override
  void fromJson(dynamic value) {
    _value = (value as List).map((e) => e == "1").toList();
  }
}

class DateTimeSetting extends Setting<List<DateTime>> {
  final bool rangeOnly;

  DateTimeSetting(
    String name,
    List<DateTime> defaultValue, {
    this.rangeOnly = false,
    void Function(BuildContext, List<DateTime>)? onChange,
    String description = "",
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  @override
  DateTimeSetting copy() {
    return DateTimeSetting(name, List.from(_value),
        rangeOnly: rangeOnly,
        onChange: onChange,
        description: description,
        enableConditions: enableConditions,
        isVisual: isVisual);
  }

  @override
  List<DateTime> get value => List.from(_value);

  @override
  void setValue(BuildContext context, List<DateTime> value) {
    _value = List.from(value);
    onChange?.call(context, _value);
  }

  @override
  void setValueWithoutNotify(List<DateTime> value) {
    _value = List.from(value);
  }

  @override
  dynamic toJson() {
    return _value.map((e) => e.millisecondsSinceEpoch).toList();
  }

  @override
  void fromJson(dynamic value) {
    _value = (value as List)
        .map((e) => DateTime.fromMillisecondsSinceEpoch(e))
        .toList();
  }

  void addDateTime(BuildContext context, DateTime dateTime) {
    _value.add(dateTime);
    onChange?.call(context, _value);
  }

  void removeDateTime(BuildContext context, DateTime dateTime) {
    _value.remove(dateTime);
    onChange?.call(context, _value);
  }
}

class DurationSetting extends Setting<TimeDuration> {
  DurationSetting(
    String name,
    TimeDuration defaultValue, {
    void Function(BuildContext, TimeDuration)? onChange,
    String description = "",
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            isVisual);

  @override
  DurationSetting copy() {
    return DurationSetting(name, _value,
        onChange: onChange,
        description: description,
        enableConditions: enableConditions,
        isVisual: isVisual);
  }

  @override
  dynamic toJson() {
    return _value.inMilliseconds;
  }

  @override
  void fromJson(dynamic value) {
    _value = TimeDuration.fromMilliseconds(value);
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
