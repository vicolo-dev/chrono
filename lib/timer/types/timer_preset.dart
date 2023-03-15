import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/foundation.dart';

class TimerPreset extends ListItem {
  final int _id;
  String name;
  TimeDuration duration;
  TimerPreset(this.name, this.duration) : _id = UniqueKey().hashCode;

  @override
  int get id => _id;

  TimerPreset.from(TimerPreset preset)
      : _id = UniqueKey().hashCode,
        name = preset.name,
        duration = TimeDuration.from(preset.duration);

  @override
  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': name,
        'duration': duration.toJson(),
      };

  TimerPreset.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        name = json['name'],
        duration = TimeDuration.fromJson(json['duration']);
}
