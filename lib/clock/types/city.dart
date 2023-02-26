import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

class City extends ListItem {
  final String _name;
  final String _country;
  final String _timezone;
  late final int _id;

  String get name => _name;
  String get country => _country;
  String get timezone => _timezone;
  @override
  int get id => _id;

  City(this._name, this._country, this._timezone) : _id = UniqueKey().hashCode;

  City.fromJson(Map<String, dynamic> jsonData)
      : _name = jsonData['name'],
        _country = jsonData['country'],
        _timezone = jsonData['timezone'],
        _id = jsonData['id'];

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'timezone': timezone,
        'id': id,
      };
}
