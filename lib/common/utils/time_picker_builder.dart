import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';

MediaQuery getTimePickerBuilder(BuildContext context, Widget? child) {
  bool shouldUse24h = MediaQuery.of(context).alwaysUse24HourFormat ||
      appSettings.getSetting("Time Format").value == TimeFormat.h24;

  return MediaQuery(
    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: shouldUse24h),
    child: child!,
  );
}
