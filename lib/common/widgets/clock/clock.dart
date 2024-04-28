import 'package:clock_app/navigation/types/alignment.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/timezone.dart' as timezone;

import 'clock_display.dart';

class Clock extends StatelessWidget {
  const Clock({
    super.key,
    this.scale = 1,
    this.shouldShowDate = false,
    this.shouldShowSeconds = false,
    this.color,
    this.timezoneLocation,
    this.horizontalAlignment = ElementAlignment.start,
  });

  final ElementAlignment horizontalAlignment;
  final double scale;
  final bool shouldShowDate;
  final bool shouldShowSeconds;
  final Color? color;
  final timezone.Location? timezoneLocation;

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) {
        DateTime dateTime;
        if (timezoneLocation != null) {
          dateTime = timezone.TZDateTime.now(timezoneLocation!);
        } else {
          dateTime = DateTime.now();
        }
        return ClockDisplay(
          scale: scale,
          shouldShowDate: shouldShowDate,
          color: color,
          shouldShowSeconds: shouldShowSeconds,
          dateTime: dateTime,
          horizontalAlignment: horizontalAlignment,
        );
      },
    );
  }
}
