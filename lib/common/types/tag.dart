import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

class Tag extends ListItem {
  final int _id;
  final String name;
  final String description;
  final Color color;
  Tag({required this.name, this.description = "", this.color = Colors.blue}):_id=UniqueKey().hashCode;

  Tag.fromJson(Map<String, dynamic> json):
  _id = json['id'],
  name = json['name'],
  description = json['description'],
  color = json['color'];

  @override
  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': name,
    'description': description,
    'color': color
  };

  @override
  copy() {
    return Tag(name: name, description: description, color: color);
  }

  @override
  int get id => _id;

  @override
  bool get isDeletable => true;
}
