import 'dart:convert';

import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/clock/types/city.dart';

final fromJsonFactories = <Type, Function>{
  Alarm: (Map<String, dynamic> json) => Alarm.fromJson(json),
  City: (Map<String, dynamic> json) => City.fromJson(json),
};

abstract class JsonSerializable {
  const JsonSerializable();
  JsonSerializable.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

String encodeList<T extends JsonSerializable>(List<T> items) => json.encode(
      items.map<Map<String, dynamic>>((item) => item.toJson()).toList(),
    );

List<T> decodeList<T extends JsonSerializable>(String encodedItems) =>
    (json.decode(encodedItems) as List<dynamic>)
        .map<T>((json) => fromJsonFactories[T]!(json))
        .toList();
