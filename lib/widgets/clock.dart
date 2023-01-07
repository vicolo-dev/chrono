import 'package:clock_app/types/time.dart';
import 'package:clock_app/widgets/time_display.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/timezone.dart' as timezone;

class Clock extends StatelessWidget {
  const Clock({
    Key? key,
    this.scale = 1,
    this.shouldShowDate = false,
    this.shouldShowSeconds = false,
    this.timeFormat = TimeFormat.H12,
    this.timezoneLocation,
  }) : super(key: key);

  final double scale;
  final bool shouldShowDate;
  final TimeFormat timeFormat;
  final bool shouldShowSeconds;
  final timezone.Location? timezoneLocation;

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TimeDisplay(
                    format: '${timeFormat == TimeFormat.H12 ? 'h' : 'kk'}:mm',
                    fontSize: 72 * scale,
                    height: shouldShowDate ? 0.75 : null,
                    timezoneLocation: timezoneLocation,
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
                          timezoneLocation: timezoneLocation,
                        ),
                      Row(
                        children: timeFormat == TimeFormat.H12
                            ? [
                                TimeDisplay(
                                  format: 'a',
                                  fontSize:
                                      (shouldShowSeconds ? 24 : 32) * scale,
                                  height: 1,
                                  timezoneLocation: timezoneLocation,
                                ),
                                if (shouldShowSeconds)
                                  SizedBox(width: 16 * scale),
                              ]
                            : [
                                if (shouldShowSeconds)
                                  SizedBox(width: 56 * scale),
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
                timezoneLocation: timezoneLocation,
              ),
          ],
        );
      },
    );
  }
}
