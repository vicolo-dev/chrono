import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text,
    {bool fab = false, bool navBar = false, bool error = false}) {
  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;
  Color? color = error ? colorScheme.error : null;
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context)
      .showSnackBar(getSnackbar(text, fab: fab, navBar: navBar, color: color));
}

SnackBar getSnackbar(String text,
    {bool fab = false, bool navBar = false, Color? color}) {
  double left = 20;
  double right = 20;
  double bottom = 12;

  if (fab) {
    final leftHandedMode = appSettings
        .getGroup("Accessibility")
        .getSetting("Left Handed Mode")
        .value;
    if (leftHandedMode) {
      left = 64 + 16;
    } else {
      right = 64 + 16;
    }
  }

  if (navBar) {
    bottom = 4;
  }

  final useMaterialStyle = appSettings
      .getGroup("Appearance")
      .getGroup("Style")
      .getSetting("Use Material Style")
      .value;

  if (useMaterialStyle) {
    bottom += 20;
  }

  return SnackBar(
    content: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 28),
      child: Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.centerLeft,
        color: color,
        // height: 28,
        child: Text(text),
      ),
    ),
    margin: EdgeInsets.only(
      left: left,
      right: right,
      bottom: bottom,
    ),
    padding:  EdgeInsets.zero,
    elevation: 2,
    dismissDirection: DismissDirection.none,
  );
}
