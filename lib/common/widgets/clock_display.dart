import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/common/widgets/time_display.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

class ClockDisplay extends StatelessWidget {
  const ClockDisplay({
    Key? key,
    this.scale = 1,
    this.color,
    this.shouldShowDate = false,
    this.shouldShowSeconds = false,
    required this.dateTime,
    this.timeFormat = TimeFormat.h12,
    this.horizontalAlignment = ElementAlignment.start,
  }) : super(key: key);

  final TimeFormat timeFormat;
  final double scale;
  final bool shouldShowDate;
  final Color? color;
  final DateTime dateTime;
  final bool shouldShowSeconds;
  final ElementAlignment horizontalAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.values[horizontalAlignment.index],
      children: <Widget>[
        Row(
            mainAxisAlignment:
                MainAxisAlignment.values[horizontalAlignment.index],
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              TimeDisplay(
                format: '${timeFormat == TimeFormat.h12 ? 'h' : 'kk'}:mm',
                fontSize: 72 * scale,
                height: shouldShowDate ? 0.75 : null,
                color: color,
                dateTime: dateTime,
              ),
              SizedBox(width: 4 * scale),
              Column(
                verticalDirection: VerticalDirection.up,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (shouldShowSeconds)
                    TimeDisplay(
                      format: 'ss',
                      fontSize: 36 * scale,
                      height: 1,
                      color: color,
                      dateTime: dateTime,
                    ),
                  Row(
                    children: timeFormat == TimeFormat.h12
                        ? [
                            TimeDisplay(
                              format: 'a',
                              fontSize: (shouldShowSeconds ? 24 : 32) * scale,
                              height: 1,
                              color: color,
                              dateTime: dateTime,
                            ),
                            if (shouldShowSeconds) SizedBox(width: 16 * scale),
                          ]
                        : [
                            if (shouldShowSeconds) SizedBox(width: 56 * scale),
                          ],
                  ),
                ],
              ),
            ]),
        if (shouldShowDate)
          TimeDisplay(
            format: 'EEE, MMM d',
            fontSize: 16 * scale,
            height: 1,
            dateTime: dateTime,
            color: color ?? ColorTheme.textColorSecondary,
          ),
      ],
    );
  }
}
