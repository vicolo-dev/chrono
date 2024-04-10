import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

class Tag extends ListItem {
  final int _id;
  String name;
  String description;
  Color color;
  Tag(this.name, {this.description = "", this.color = Colors.blue})
      : _id = UniqueKey().hashCode;

  Tag.fromJson(Json json)
      : _id = json?['id'] ?? UniqueKey().hashCode,
        name = json?['name'] ?? "Unknown",
        description = json?['description'] ?? "",
        color = Color(json?['color'] ?? 0);

  Tag.from(Tag tag)
      : _id = UniqueKey().hashCode,
        name = tag.name,
        description = tag.description,
        color = tag.color;

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
