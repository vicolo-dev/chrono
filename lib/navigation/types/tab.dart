import 'package:flutter/widgets.dart';

class Tab {
  final String id;
  final String title;
  final IconData icon;
  final Widget widget;

  Tab({
    required this.id,
    required this.title,
    required this.icon,
    required this.widget,
  });
}
