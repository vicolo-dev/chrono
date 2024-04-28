import 'package:flutter/material.dart';

class SelectChoice<T> {
  final String description;
  final String name;
  final T value;
  final Color? color;

  const SelectChoice(
      {required this.value,
      required this.name,
      this.description = "",
      this.color});
}
