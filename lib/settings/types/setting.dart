import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_item.dart';
import 'package:clock_app/settings/types/setting_item.dart';
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

  final T Function(T)? _valueCopyGetter;

  bool get isEnabled {
    for (var enableSetting in enableSettings) {
      if (enableSetting.setting.value != enableSetting.value) {
        return false;
      }
    }
    return true;
  }

  Setting(
    String name,
    String description,
    T defaultValue,
    this.onChange,
    this.enableConditions,
    List<String> searchTags,
    this.isVisual, {
    T Function(T)? valueCopyGetter,
  })  : _value = valueCopyGetter?.call(defaultValue) ?? defaultValue,
        _defaultValue = valueCopyGetter?.call(defaultValue) ?? defaultValue,
        enableSettings = [],
        changesEnableCondition = false,
        _valueCopyGetter = valueCopyGetter,
        super(name, description, searchTags);

  void setValue(BuildContext context, T value) {
    _value = _valueCopyGetter?.call(value) ?? value;
    callListeners(this);
    onChange?.call(context, value);
  }

  void restoreDefault(BuildContext context) {
    setValue(context, _defaultValue);
  }

  void setValueWithoutNotify(T value) {
    _value = _valueCopyGetter?.call(value) ?? value;
  }

  dynamic get value => _value;
  dynamic get defaultValue => _defaultValue;

  @override
  dynamic valueToJson() {
    return _value;
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null || value is! T) return;
    _value = value;
  }
}

class ListSetting<T extends CustomizableListItem> extends Setting<List<T>> {
  List<T> possibleItems;
  Widget Function(T item) cardBuilder;
  Widget Function(T item) addCardBuilder;
  Widget Function(T item)? itemPreviewBuilder;
  // The widget that will be used to display the value of this setting.
  Widget Function(BuildContext context, ListSetting<T> setting)
      valueDisplayBuilder;

  ListSetting(
    String name,
    List<T> defaultValue,
    this.possibleItems, {
    required this.cardBuilder,
    required this.valueDisplayBuilder,
    required this.addCardBuilder,
    this.itemPreviewBuilder,
    String description = "",
    void Function(BuildContext, List<T>)? onChange,
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
    List<String> searchTags = const [],
  }) : super(
          name,
          description,
          copyItemList(defaultValue),
          onChange,
          enableConditions,
          searchTags,
          isVisual,
          valueCopyGetter: copyItemList,
        );

  @override
  ListSetting<T> copy() {
    return ListSetting<T>(
      name,
      _value,
      possibleItems,
      valueDisplayBuilder: valueDisplayBuilder,
      cardBuilder: cardBuilder,
      addCardBuilder: addCardBuilder,
      description: description,
      onChange: onChange,
      enableConditions: enableConditions,
      isVisual: isVisual,
      itemPreviewBuilder: itemPreviewBuilder,
      searchTags: searchTags,
    );
  }

  Widget getValueDisplayWidget(BuildContext context) {
    return valueDisplayBuilder(context, this);
  }

  Widget getItemAddCard(T item) {
    return addCardBuilder(item);
  }

  Widget getItemCard(T item) {
    return cardBuilder(item);
  }

  Widget? getPreviewCard(T item) {
    return itemPreviewBuilder?.call(item);
  }

  @override
  dynamic valueToJson() {
    return _value.map((e) => e.toJson()).toList();
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null) return;
    _value = (value as List).map((e) => fromJsonFactories[T]!(e) as T).toList();
  }
}

class CustomSetting<T extends JsonSerializable> extends Setting<T> {
  // The screen that will be navigated to when this setting is tapped.
  Widget Function(BuildContext, CustomSetting<T>) screenBuilder;
  // The widget that will be used to display the value of this setting.
  Widget Function(BuildContext, CustomSetting<T>) valueDisplayBuilder;
  T Function(T)? copyValue;

  CustomSetting(
    String name,
    T defaultValue,
    this.screenBuilder,
    this.valueDisplayBuilder, {
    String description = "",
    void Function(BuildContext, T)? onChange,
    this.copyValue,
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual) {
    copyValue ??= (T value) => value;
  }

  Widget getScreenBuilder(BuildContext context) {
    return screenBuilder(context, this);
  }

  Widget getValueDisplayWidget(BuildContext context) {
    return valueDisplayBuilder(context, this);
  }

  @override
  CustomSetting<T> copy() {
    return CustomSetting<T>(
      name,
      copyValue?.call(_value) ?? _value,
      screenBuilder,
      valueDisplayBuilder,
      description: description,
      onChange: onChange,
      enableConditions: enableConditions,
      isVisual: isVisual,
      searchTags: searchTags,
      copyValue: copyValue,
    );
  }

  @override
  dynamic valueToJson() {
    return _value.toJson();
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null || value is! Json) return;
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
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual);

  @override
  SwitchSetting copy() {
    return SwitchSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
      isVisual: isVisual,
      searchTags: searchTags,
    );
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
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual);

  @override
  NumberSetting copy() {
    return NumberSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
      isVisual: isVisual,
      searchTags: searchTags,
    );
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
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual);

  @override
  dynamic valueToJson() {
    return _value.value;
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null || value is! int) return;
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
      isVisual: isVisual,
      searchTags: searchTags,
    );
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
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual);

  @override
  StringSetting copy() {
    return StringSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
      isVisual: isVisual,
      searchTags: searchTags,
    );
  }
}

class SliderSetting extends Setting<double> {
  final double min;
  final double max;
  final bool maxIsInfinity;
  final double? snapLength;
  final String unit;

  SliderSetting(
    String name,
    this.min,
    this.max,
    double defaultValue, {
    void Function(BuildContext context, double)? onChange,
    String description = "",
    bool isVisual = true,
    this.maxIsInfinity = false,
    this.snapLength,
    this.unit = "",
    List<SettingEnableConditionParameter> enableConditions = const [],
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual);

  // @override
  // dynamic get value =>
  //     (maxIsInfinity && _value >= max - 0.0001) ? double.infinity : _value;

  @override
  SliderSetting copy() {
    return SliderSetting(
      name,
      min,
      max,
      _value,
      onChange: onChange,
      description: description,
      snapLength: snapLength,
      maxIsInfinity: maxIsInfinity,
      enableConditions: enableConditions,
      unit: unit,
      isVisual: isVisual,
      searchTags: searchTags,
    );
  }
}

class SelectSetting<T> extends Setting<int> {
  final List<SelectSettingOption<T>> _options;

  List<SelectSettingOption<T>> get options => _options;
  int get selectedIndex => _value;
  @override
  dynamic get value => options[selectedIndex].value;
  // bool get isColor => T == Color;

  int getIndexOfValue(T value) {
    int index = options.indexWhere((element) => element.value == value);
    return index == -1 ? 0 : index;
  }

  T getValueOfIndex(int index) {
    if (index < 0 || index >= options.length) index = 0;
    return options[index].value;
  }

  @override
  void restoreDefault(BuildContext context) {
    setValue(context, _defaultValue);
  }

  SelectSetting(
    String name,
    this._options, {
    void Function(BuildContext, int)? onChange,
    int defaultValue = 0,
    String description = "",
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual);

  @override
  SelectSetting<T> copy() {
    return SelectSetting(
      name,
      _options,
      defaultValue: _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
      isVisual: isVisual,
      searchTags: searchTags,
    );
  }
}

// DynamicSelectSetting uses item id as its _value, instead of the index.
// This is so that if the options changes, the value remains the same;
class DynamicSelectSetting<T extends ListItem> extends Setting<int> {
  List<SelectSettingOption<T>> Function() optionsGetter;
  List<SelectSettingOption<T>> get options => optionsGetter();
  @override
  dynamic get value => options[selectedIndex].value;
  int get selectedIndex => getIndexOfId(_value);

  DynamicSelectSetting(
    String name,
    this.optionsGetter, {
    void Function(BuildContext, int)? onChange,
    String description = "",
    int defaultValue = -1,
    bool isVisual = true,
    bool shouldCloseOnSelect = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual) {
    if (defaultValue != -1) {
      _value = defaultValue;
    }
  }

  @override
  DynamicSelectSetting<T> copy() {
    return DynamicSelectSetting(name, optionsGetter,
        onChange: onChange,
        defaultValue: _value,
        description: description,
        enableConditions: enableConditions,
        isVisual: isVisual,
        searchTags: searchTags);
  }

  void setIndex(BuildContext context, int index) {
    setValue(context, getIdAtIndex(index));
  }

  @override
  void restoreDefault(BuildContext context) {
    setIndex(context, 0);
  }

  int getIndexOfValue(T value) {
    return getIndexOfId(value.id);
  }

  int getIndexOfId(int id) {
    int index = options.indexWhere((element) => element.value.id == id);
    return index == -1 ? 0 : index;
  }

  int getIdAtIndex(int index) {
    final settingsOptions = optionsGetter();
    if (settingsOptions.isEmpty) return -1;
    if (index < 0 || index >= settingsOptions.length) index = 0;
    return settingsOptions[index].value.id;
  }

  @override
  dynamic valueToJson() {
    return _value;
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null || value is! int) return;
    // If the value is no longer in the options, return the first option
    // If options is empty, set id to -1
    if (getIndexOfId(value) == -1) value = getIdAtIndex(0);
    _value = value;
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
    bool isVisual = true,
    List<SettingEnableConditionParameter> enableConditions = const [],
    List<String> searchTags = const [],
  }) : super(
          name,
          description,
          defaultValue.length == options.length
              ? List.from(defaultValue)
              : List.generate(options.length, (index) => index == 0),
          onChange,
          enableConditions,
          searchTags,
          isVisual,
          valueCopyGetter: List.from,
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
      isVisual: isVisual,
      searchTags: searchTags,
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
  dynamic valueToJson() {
    return _value.map((e) => e ? "1" : "0").toList();
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null) return;
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
    List<String> searchTags = const [],
  }) : super(
          name,
          description,
          defaultValue,
          onChange,
          enableConditions,
          searchTags,
          isVisual,
          valueCopyGetter: List.from,
        );

  @override
  DateTimeSetting copy() {
    return DateTimeSetting(
      name,
      _value,
      rangeOnly: rangeOnly,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
      isVisual: isVisual,
      searchTags: searchTags,
    );
  }

  @override
  dynamic valueToJson() {
    return _value.map((e) => e.millisecondsSinceEpoch).toList();
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null) return;
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
    List<String> searchTags = const [],
  }) : super(name, description, defaultValue, onChange, enableConditions,
            searchTags, isVisual);

  @override
  DurationSetting copy() {
    return DurationSetting(
      name,
      _value,
      onChange: onChange,
      description: description,
      enableConditions: enableConditions,
      isVisual: isVisual,
      searchTags: searchTags,
    );
  }

  @override
  dynamic valueToJson() {
    return _value.inMilliseconds;
  }

  @override
  void loadValueFromJson(dynamic value) {
    if (value == null || value is! int) return;
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
