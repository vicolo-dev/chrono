import 'package:clock_app/common/types/json.dart';
import 'package:flutter/material.dart';

class Time extends JsonSerializable {
  final int hour;
  final int minute;
  final int second;

  const Time({this.hour = 0, this.minute = 0, this.second = 0});

  Time.fromTimeOfDay(TimeOfDay timeOfDay)
      : hour = timeOfDay.hour,
        minute = timeOfDay.minute,
        second = 0;

  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);

  Time.fromDateTime(DateTime dateTime)
      : hour = dateTime.hour,
        minute = dateTime.minute,
        second = dateTime.second;

  factory Time.now() => Time.fromDateTime(DateTime.now());
  factory Time.fromNow(Duration duration) => Time.now().add(duration);

  Time add(Duration duration) => Time.fromDateTime(toDateTime().add(duration));

  DateTime toDateTime() {
    DateTime currentDateTime = DateTime.now();
    return DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, hour, minute);
  }

  Time.fromJson(Json json)
      : hour = json['hours'],
        minute = json['minutes'],
        second = json['seconds'];

  @override
  Json toJson() {
    return {
      'hours': hour,
      'minutes': minute,
      'seconds': second,
    };
  }

  double toHours() => hour + minute / 60.0 + second / 3600.0;
  double toMinutes() => hour * 60 + minute + second / 60.0;
  int toSeconds() => hour * 3600 + minute * 60 + second;

  bool isBetween(Time start, Time end) {
    double time = toHours();
    double startTime = start.toHours();
    double endTime = end.toHours();
    if (startTime < endTime) {
      return time >= startTime && time <= endTime;
    } else {
      return time >= startTime || time <= endTime;
    }
  }
}
