import 'package:clock_app/settings/types/setting.dart';

class SettingEnableConditionParameter {
  List<String> settingPath;
  dynamic value;

  SettingEnableConditionParameter(this.settingPath, this.value);
}

class SettingEnableCondition {
  Setting setting;
  dynamic value;

  SettingEnableCondition(this.setting, this.value);
}
