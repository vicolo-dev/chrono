import 'package:clock_app/clock/types/time.dart';
import 'package:flutter/material.dart';

String getTimeFormatString(BuildContext context, TimeFormat timeFormat,
    {bool showMeridiem = true, String separator = "default"}) {
  if (timeFormat == TimeFormat.device) {
    if (MediaQuery.of(context).alwaysUse24HourFormat) {
      timeFormat = TimeFormat.h24;
    } else {
      timeFormat = TimeFormat.h12;
    }
  }

if (separator == "default") {
  separator = ":";
}

  return timeFormat == TimeFormat.h12
      ? "h${separator}mm${showMeridiem ? " a" : ""}"
      : "HH${separator}mm";
}
