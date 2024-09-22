import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/id.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:clock_app/timer/types/time_duration.dart';

class TimerPreset extends ListItem {
  late int _id;
  String name = "Preset";
  TimeDuration duration = const TimeDuration(minutes: 5);
  TimerPreset(this.name, this.duration) : _id = getId();

  @override
  int get id => _id;
  @override
  bool get isDeletable => true;

  TimerPreset.from(TimerPreset preset)
      : _id = getId(),
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
      _id = getId();
      return;
    }
    _id = json['id'] ?? getId();
    name = json['name'] ?? "Preset";
    duration = TimeDuration.fromJson(json['duration']);
  }

  @override
  void copyFrom(dynamic other) {
    if (other is TimerPreset) {
      _id = other.id;
      name = other.name;
      duration = TimeDuration.from(other.duration);
    }
  }

  bool isEqualTo(TimerPreset other) {
    return name == other.name && duration == other.duration;
  }

  @override
  copy() {
    return TimerPreset(name, duration);
  }
}
