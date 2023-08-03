import 'package:clock_app/alarm/widgets/tasks/arithmetic_task_widget.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

enum AlarmTaskType {
  arithmetic,
  shake,
}

typedef AlarmTaskBuilder = Widget Function(Function() onSolve);

class AlarmTaskSchema extends JsonSerializable {
  final String name;
  final SettingGroup settings;
  final AlarmTaskBuilder builder;

  const AlarmTaskSchema(this.name, this.settings, this.builder);

  void loadFromJson(Json json) {
    settings.loadValueFromJson(json['settings']);
  }

  AlarmTaskSchema copy() {
    return AlarmTaskSchema(
      name,
      settings.copy(),
      builder,
    );
  }

  @override
  Json toJson() {
    return {
      'settings': settings.valueToJson(),
    };
  }
}

Map<AlarmTaskType, AlarmTaskSchema> alarmTaskSchemasMap = {
  AlarmTaskType.arithmetic: AlarmTaskSchema(
    "Arithmetic",
    SettingGroup("Arithmetic Task Settings", []),
    (onSolve) {
      return ArithmeticTask(
        onSolve: onSolve,
      );
    },
  )
};

// class AlarmTaskList extends JsonSerializable {
//   final List<AlarmTask> tasks;

//   AlarmTaskList(this.tasks);

//   AlarmTaskList.fromJson(Json json) : tasks = listFromString(json['tasks']);

//   @override
//   Json toJson() {
//     return {
//       'tasks': listToString(tasks),
//     };
//   }
// }

class AlarmTask extends ListItem {
  final int _id;
  final AlarmTaskType type;
  late final AlarmTaskSchema _schema;

  AlarmTask(this.type)
      : _id = UniqueKey().hashCode,
        _schema = alarmTaskSchemasMap[type]!.copy();

  AlarmTask.fromJson(Json json)
      : _id = json['id'],
        type = AlarmTaskType.values.byName(json['type']) {
    _schema = alarmTaskSchemasMap[type]!.copy();
    _schema.loadFromJson(json['schema']);
  }

  @override
  copy() {
    return AlarmTask(type);
  }

  @override
  int get id => _id;
  @override
  bool get isDeletable => true;
  AlarmTaskSchema get schema => _schema;
  String get name => _schema.name;
  SettingGroup get settings => _schema.settings;
  AlarmTaskBuilder get builder => _schema.builder;

  @override
  Json toJson() {
    return {
      'id': _id,
      'schema': _schema.toJson(),
      'type': type.name,
    };
  }
}
