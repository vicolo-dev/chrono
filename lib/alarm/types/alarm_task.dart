import 'package:clock_app/alarm/data/alarm_task_schemas.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

enum AlarmTaskType {
  math,
  retype,
  sequence,
  shake,
  memory,
}

typedef AlarmTaskBuilder = Widget Function(
    Function() onSolve, SettingGroup settings);

class AlarmTaskSchema extends JsonSerializable {
  final String name;
  final SettingGroup settings;
  final AlarmTaskBuilder _builder;

  const AlarmTaskSchema(this.name, this.settings, this._builder);

  AlarmTaskSchema.from(AlarmTaskSchema schema)
      : name = schema.name,
        settings = schema.settings.copy(),
        _builder = schema._builder;

  Widget getBuilder(Function() onSolve) {
    return _builder(onSolve, settings);
  }

  void loadFromJson(Json? json) {
    if (json == null) return;
    settings.loadValueFromJson(json['settings']);
  }

  AlarmTaskSchema copy() {
    return AlarmTaskSchema.from(this);
  }

  @override
  Json toJson() {
    return {
      'settings': settings.valueToJson(),
    };
  }
}

class AlarmTask extends CustomizableListItem {
  late final AlarmTaskType type;
  late final AlarmTaskSchema _schema;

  AlarmTask(this.type) : _schema = alarmTaskSchemasMap[type]!.copy();

  AlarmTask.from(AlarmTask task)
      : type = task.type,
        _schema = task._schema.copy();

  AlarmTask.fromJson(Json json) {
    if (json == null) {
      type = AlarmTaskType.math;
      _schema = alarmTaskSchemasMap[type]!.copy();
      return;
    }
    type = AlarmTaskType.values.byName(json['type']);
    _schema = alarmTaskSchemasMap[type]!.copy();
    _schema.loadFromJson(json['schema']);
  }

  @override
  copy() {
    return AlarmTask.from(this);
  }

  @override
  int get id => _schema.name.hashCode;
  @override
  bool get isDeletable => true;
  AlarmTaskSchema get schema => _schema;
  String get name => _schema.name;
  @override
  SettingGroup get settings => _schema.settings;
  Widget Function(Function() onSolve) get builder => _schema.getBuilder;

  @override
  Json toJson() {
    return {
      'schema': _schema.toJson(),
      'type': type.name,
    };
  }
}
