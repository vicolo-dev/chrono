import 'package:flutter/material.dart';

Widget reorderableListDecorator(BuildContext context, Widget? child) {
  return Material(
    shadowColor: Colors.black.withOpacity(0.3),
    shape: Theme.of(context).cardTheme.shape,
    elevation: Theme.of(context).cardTheme.elevation! * 6,
    color: Colors.transparent,
    child: child,
  );
}
