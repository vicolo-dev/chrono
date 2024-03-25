import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_item.dart';

// TODO: OMG ALL THESE NAMES ARE SO BAD, PLEASE THINK OF NEW ONES :(

abstract class EnableConditionParameter {
  void setupEnableSettings(SettingGroup group, SettingItem item);
  void setupChangesEnableCondition(SettingGroup group, SettingItem item);
  EnableConditionEvaluator getEvaluator(SettingGroup group);
}

class ValueCondition extends EnableConditionParameter {
  List<String> settingPath;
  bool Function(dynamic settingValue) condition;

  ValueCondition(this.settingPath, this.condition);

  @override
  EnableConditionEvaluator getEvaluator(SettingGroup group) {
    Setting setting = group.getSettingFromPath(settingPath);
    return ValueConditionEvaluator(setting, condition);
  }

  @override
  void setupEnableSettings(SettingGroup group, SettingItem item) {
    item.enableSettings.add(getEvaluator(group));
    // print(
    //     "${item.name} is enabled by ${setting.name} = ${enableCondition.value}");
  }

  @override
  void setupChangesEnableCondition(SettingGroup group, SettingItem item) {
    Setting setting = group.getSettingFromPath(settingPath);
    setting.changesEnableCondition = true;
  }
}

class CompoundCondition extends EnableConditionParameter {
  EnableConditionParameter parameter1;
  EnableConditionParameter parameter2;
  bool Function(bool parameter1Result, bool parameter2Result) condition;
  CompoundCondition(this.parameter1, this.parameter2, this.condition);

  @override
  EnableConditionEvaluator getEvaluator(SettingGroup group) {
    return CompoundConditionEvaluator(parameter1.getEvaluator(group),
        parameter2.getEvaluator(group), condition);
  }

  @override
  void setupEnableSettings(SettingGroup group, SettingItem item) {
    item.enableSettings.add(getEvaluator(group));
    // print(
    //     "${item.name} is enabled by ${setting.name} = ${enableCondition.value}");
  }

  @override
  void setupChangesEnableCondition(SettingGroup group, SettingItem item) {
    parameter1.setupChangesEnableCondition(group, item);
    parameter2.setupChangesEnableCondition(group, item);
  }
}

abstract class EnableConditionEvaluator {
  bool evaluate();
}

class ValueConditionEvaluator extends EnableConditionEvaluator {
  Setting setting;
  bool Function(dynamic settingValue) condition;

  ValueConditionEvaluator(this.setting, this.condition);

  @override
  bool evaluate() {
    return condition(setting.value);
  }
}

class CompoundConditionEvaluator extends EnableConditionEvaluator {
  EnableConditionEvaluator condition1;
  EnableConditionEvaluator condition2;
  bool Function(bool parameter1Result, bool parameter2Result) condition;
  CompoundConditionEvaluator(this.condition1, this.condition2, this.condition);

  @override
  bool evaluate() {
    return condition(condition1.evaluate(), condition2.evaluate());
  }
}
