import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/alarm/widgets/tasks/math_task.dart';
import 'package:clock_app/alarm/widgets/tasks/retype_task.dart';
import 'package:clock_app/alarm/widgets/tasks/sequence_task.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';

Map<AlarmTaskType, AlarmTaskSchema> alarmTaskSchemasMap = {
  AlarmTaskType.math: AlarmTaskSchema(
    "Math Problems",
    SettingGroup("Math Problems Settings", [
      SelectSetting(
        "Difficulty",
        [
          SelectSettingOption(
              "Easy (X + Y)", MathTaskDifficultyLevel([Operator.add])),
          SelectSettingOption(
              "Medium (X × Y)", MathTaskDifficultyLevel([Operator.multiply])),
          SelectSettingOption("Hard (X × Y + Z)",
              MathTaskDifficultyLevel([Operator.multiply, Operator.add])),
          SelectSettingOption("Very Hard (X × Y × Z)",
              MathTaskDifficultyLevel([Operator.multiply, Operator.multiply])),
        ],
      ),
    ]),
    (onSolve, settings) {
      return MathTask(
        onSolve: onSolve,
        settings: settings,
      );
    },
  ),
  AlarmTaskType.retype: AlarmTaskSchema(
    "Retype Text",
    SettingGroup("Retype Text Settings", [
      SliderSetting("Number of characters", 5, 20, 5, snapLength: 1),
      SwitchSetting("Include numbers", false),
      SwitchSetting("Include lowercase", false),
    ]),
    (onSolve, settings) {
      return RetypeTask(onSolve: onSolve, settings: settings);
    },
  ),
  AlarmTaskType.sequence: AlarmTaskSchema(
    "Sequence",
    SettingGroup("Sequence Settings", [
      SliderSetting("Sequence length", 3, 10, 3, snapLength: 1),
      SliderSetting("Grid size", 2, 5, 3, snapLength: 1),
    ]),
    (onSolve, settings) {
      return SequenceTask(onSolve: onSolve, settings: settings);
    },
  ),
};
