import 'package:flutter/material.dart';

class Weekday {
  final int id;
  final String Function(BuildContext) getAbbreviation;
  final String Function(BuildContext) getDisplayName;

  const Weekday(this.id, this.getAbbreviation, this.getDisplayName);
}
