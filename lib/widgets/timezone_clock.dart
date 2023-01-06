import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/timezone.dart' as timezone;

class TimeZoneClock extends StatelessWidget {
  const TimeZoneClock({
    Key? key,
    required this.timezoneLocation,
    required this.fontSize,
  }) : super(key: key);

  final timezone.Location timezoneLocation;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) {
        var date = timezone.TZDateTime.now(timezoneLocation);
        String formattedTime = DateFormat('kk:mm').format(date);
        return Text(formattedTime,
            style: Theme.of(context).textTheme.displayMedium);
      },
    );
  }
}
