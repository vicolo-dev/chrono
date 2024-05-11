import 'package:flutter/material.dart';

class MenuAction {
  IconData icon;
  String name;
  Function(BuildContext context) action;
  Color? color;

  MenuAction(this.name, this.action, this.icon, [this.color]);
}
