import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/foundation.dart';

class TimerPreset extends ListItem {
  late final int _id;
  String name = "Preset";
  TimeDuration duration = const TimeDuration(minutes: 5);
  TimerPreset(this.name, this.duration) : _id = UniqueKey().hashCode;

  @override
  int get id => _id;
  @override
  bool get isDeletable => true;

  TimerPreset.from(TimerPreset preset)
      : _id = UniqueKey().hashCode,
        name = preset.name,
        duration = TimeDuration.from(preset.duration);

  @override
  Json toJson() => {
        'id': _id,
        'name': name,
        'duration': duration.toJson(),
      };

  TimerPreset.fromJson(Json json) {
    if (json == null) {
      _id = UniqueKey().hashCode;
      return;
    }
    _id = json['id'] ?? UniqueKey().hashCode;
    name = json['name'] ?? "Preset";
    duration = TimeDuration.fromJson(json['duration']);
  }

  @override
  copy() {
    return TimerPreset(name, duration);
  }
}
