import 'package:clock_app/widgets/time_display.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/timezone.dart' as timezone;

class Clock extends StatelessWidget {
  const Clock({
    Key? key,
    this.scale = 1,
    this.shouldShowDate = false,
    this.timezoneLocation,
  }) : super(key: key);

  final double scale;
  final bool shouldShowDate;

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
                    format: 'h:mm',
                    fontSize: 72 * scale,
                    height: 0.75,
                    timezoneLocation: timezoneLocation,
                  ),
                  SizedBox(width: 4 * scale),
                  Column(
                    verticalDirection: VerticalDirection.up,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimeDisplay(
                        format: 'ss',
                        fontSize: 36 * scale,
                        height: 1,
                        timezoneLocation: timezoneLocation,
                      ),
                      Row(
                        children: [
                          TimeDisplay(
                            format: 'a',
                            fontSize: 24 * scale,
                            height: 1,
                            timezoneLocation: timezoneLocation,
                          ),
                          SizedBox(width: 12 * scale),
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
