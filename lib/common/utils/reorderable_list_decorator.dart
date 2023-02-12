import 'package:clock_app/theme/border.dart';
import 'package:flutter/material.dart';

Widget reorderableListDecorator(BuildContext context, Widget? child) {
  return Material(
    shadowColor: Colors.black.withOpacity(0.3),
    borderRadius: defaultBorderRadius,
    elevation: Theme.of(context).cardTheme.elevation! * 6,
    color: Colors.transparent,
    child: child,
  );
}
