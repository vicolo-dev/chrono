import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

class Tag extends ListItem {
  final int _id;
  final String name;
  final String description;
  final Color color;
  Tag(this.name, {this.description = "", this.color = Colors.blue}):_id=UniqueKey().hashCode;

  Tag.fromJson(Json json):
  _id = json?['id'] ?? UniqueKey().hashCode,
  name = json?['name'] ?? "Unknown",
  description = json?['description'] ?? "",
  color = Color(json?['color'] ?? 0);

  @override
  Json toJson() => {
    'id': _id,
    'name': name,
    'description': description,
    'color': color.value,
  };

  @override
  copy() {
    return Tag(name, description: description, color: color);
  }

  @override
  int get id => _id;

  @override
  bool get isDeletable => true;
}
