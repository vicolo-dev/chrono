import 'package:clock_app/theme/border.dart';
import 'package:flutter/material.dart';

Widget reorderableListDecorator(
    Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      return Material(
        shadowColor: Colors.black.withOpacity(0.3),
        borderRadius: defaultBorderRadius,
        elevation: 6,
        color: Colors.transparent,
        child: child,
      );
    },
    child: child,
  );
}
