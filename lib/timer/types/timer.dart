import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

class Timer extends JsonSerializable {
  TimeDuration duration;
  int id;

  Timer(this.duration) : id = UniqueKey().hashCode;

  Timer.fromTimer(Timer timer)
      : duration = timer.duration,
        id = UniqueKey().hashCode;

  @override
  Map<String, dynamic> toJson() {
    return {
      'duration': duration.inSeconds,
      'id': id,
    };
  }

  Timer.fromJson(Map<String, dynamic> json)
      : duration = TimeDuration.fromSeconds(json['duration']),
        id = json['id'];
}
