import 'package:flutter/material.dart';

class PopupAction {
  IconData icon;
  String name;
  Function action;
  Color? color;

  PopupAction(this.name, this.action, this.icon, [this.color]);
}
