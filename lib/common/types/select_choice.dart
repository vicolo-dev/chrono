import 'package:flutter/material.dart';

// enum SelectType { color, string, audio }

class SelectChoice<T> {
  final String description;
  final String name;
  final T value;
  // SelectType type = SelectType.string;

  SelectChoice(
      {required this.value, required this.name, this.description = ""}) {
    // if (value is Color) {
    // type = SelectType.color;
    // } else if (value is String) {
    // type = SelectType.string;
    // }
  }
}
