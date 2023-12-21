import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text,
    {bool fab = false, bool navBar = false}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context)
      .showSnackBar(getSnackbar(text, fab: fab, navBar: navBar));
}

SnackBar getSnackbar(String text, {bool fab = false, bool navBar = false}) {
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
    bottom = 16;
  }

  return SnackBar(
    content: Container(
      alignment: Alignment.centerLeft,
      height: 28,
      child: Text(text),
    ),
    margin: EdgeInsets.only(
      left: left,
      right: right,
      bottom: bottom,
    ),
    elevation: 2,
    dismissDirection: DismissDirection.none,
  );
}
