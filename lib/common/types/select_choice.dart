import 'package:flutter/material.dart';

enum SelectType { color, string }

class SelectChoice<T> {
  final String description;
  final T value;
  SelectType type = SelectType.string;

  SelectChoice({required this.value, this.description = ""}) {
    if (value is Color) {
      type = SelectType.color;
    } else if (value is String) {
      type = SelectType.string;
    }
  }
}
