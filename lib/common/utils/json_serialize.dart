import 'dart:convert';

import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/schedule_id.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/common/utils/time_of_day.dart';

final fromJsonFactories = <Type, Function>{
  Alarm: (Json json) => Alarm.fromJson(json),
  City: (Json json) => City.fromJson(json),
  ClockTimer: (Json json) => ClockTimer.fromJson(json),
  ClockStopwatch: (Json json) => ClockStopwatch.fromJson(json),
  TimerPreset: (Json json) => TimerPreset.fromJson(json),
  ColorSchemeData: (Json json) => ColorSchemeData.fromJson(json),
  StyleTheme: (Json json) => StyleTheme.fromJson(json),
  AlarmTask: (Json json) => AlarmTask.fromJson(json),
  Time: (Json json) => Time.fromJson(json),
  Lap: (Json json) => Lap.fromJson(json),
  TimeOfDay: (Json json) => TimeOfDayUtils.fromJson(json),
  FileItem: (Json json) => FileItem.fromJson(json),
  AlarmEvent: (Json json) => AlarmEvent.fromJson(json),
  ScheduleId: (Json json) => ScheduleId.fromJson(json),
  Tag: (Json json) => Tag.fromJson(json),
};

String listToString<T extends JsonSerializable>(List<T> items) => json.encode(
      items.map<Json>((item) => item.toJson()).toList(),
    );

List<T> listFromString<T extends JsonSerializable>(String encodedItems) {
  if (!fromJsonFactories.containsKey(T)) {
    throw Exception(
        "No fromJson factory for type '$T'. Please add one in the file 'common/utils/json_serialize.dart'");
  }
  try {
    List<dynamic> rawList = json.decode(encodedItems) as List<dynamic>;
    Function fromJson = fromJsonFactories[T]!;
    List<T> list = rawList.map<T>((json) => fromJson(json)).toList();
    return list;
  } catch (e) {
    logger.e("Error decoding string: ${e.toString()}");
    rethrow;
  }
}
