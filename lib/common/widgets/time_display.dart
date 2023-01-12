import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({
    Key? key,
    required this.format,
    required this.fontSize,
    this.height,
    this.color,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;
  final String format;
  final double fontSize;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat(format).format(dateTime);
    return Text(
      formattedTime,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: fontSize,
            height: height,
            color: color,
          ),
    );
  }
}
