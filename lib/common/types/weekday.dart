import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

class Weekday extends ListItem {
  @override
  int id;
  String Function(BuildContext) getAbbreviation;
  String Function(BuildContext) getDisplayName;
  String Function(BuildContext) getFullName;

  Weekday(this.id, this.getAbbreviation, this.getDisplayName, this.getFullName);

  @override
  copy() {
    return Weekday(id, getAbbreviation, getDisplayName, getFullName);
  }

  @override
  void copyFrom(other) {
    id = other.id;
    getAbbreviation = other.getAbbreviation;
    getDisplayName = other.getDisplayName;
    getFullName = other.getFullName;
  }

  @override
  bool get isDeletable => false;

  @override
  Json? toJson() {
    return {
      'id': id,
    };
  }
}
