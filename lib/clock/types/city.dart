import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

class City extends ListItem {
  late String _name = "Unknown";
  late String _country = "Unknown";
  late String _timezone = 'America/Detroit';
  late int _id;

  String get name => _name;
  String get country => _country;
  String get timezone => _timezone;

  @override
  int get id => _id;
  @override
  bool get isDeletable => true;

  City(this._name, this._country, this._timezone) : _id = UniqueKey().hashCode;

  @override
  copy() {
    return City(name, country, timezone);
  }

  City.fromJson(Json json) {
    if (json == null) {
      _id = UniqueKey().hashCode;
      return;
    }
    _name = json['name'] ?? 'Unknown';
    _country = json['country'] ?? 'Unknown';
    _timezone = json['timezone'] ?? 'America/Detroit';
    _id = json['id'] ?? UniqueKey().hashCode;
  }

  @override
  Json toJson() => {
        'name': name,
        'country': country,
        'timezone': timezone,
        'id': id,
      };
}
