import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as timezone;

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({
    Key? key,
    required this.format,
    required this.fontSize,
    required this.height,
    required this.timezoneLocation,
  }) : super(key: key);

  final String format;
  final double fontSize;
  final double height;

  final timezone.Location? timezoneLocation;

  @override
  Widget build(BuildContext context) {
    DateTime now;
    if (timezoneLocation != null) {
      now = timezone.TZDateTime.now(timezoneLocation!);
    } else {
      now = DateTime.now();
    }
    String formattedTime = DateFormat(format).format(now);
    return Text(
      formattedTime,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: fontSize,
            height: height,
          ),
    );
  }
}
