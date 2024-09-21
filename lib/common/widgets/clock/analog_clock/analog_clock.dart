import 'package:clock_app/common/logic/card_decoration.dart';
import 'package:clock_app/common/types/clock_settings_types.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/clock/analog_clock/analog_clock_display.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/timezone.dart' as timezone;

class AnalogClock extends StatelessWidget {
  final bool showDigitalClock;
  final ClockTicksType ticksType;
  final ClockNumbersType numbersType;
  final ClockNumeralType numeralType;
  final timezone.Location? timezoneLocation;
  final bool showSeconds;

  const AnalogClock({
    super.key,
    this.showDigitalClock = false,
    this.ticksType = ClockTicksType.none,
    this.numbersType = ClockNumbersType.quarter,
    this.numeralType = ClockNumeralType.arabic,
    this.showSeconds = false,
    this.timezoneLocation,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return TimerBuilder.periodic(const Duration(seconds: 1),
        builder: (context) {
      DateTime dateTime;
      if (timezoneLocation != null) {
        dateTime = timezone.TZDateTime.now(timezoneLocation!);
      } else {
        dateTime = DateTime.now();
      }
      return Column(
        children: [
          AnalogClockDisplay(
            decoration: getCardDecoration(context,
                color: getCardColor(context), boxShape: BoxShape.circle),
            width: 220.0,
            height: 220.0,
            isLive: true,
            hourHandColor: colorScheme.onSurface,
            minuteHandColor: colorScheme.onSurface,
            secondHandColor: colorScheme.primary,
            showSecondHand: showSeconds,
            numberColor: colorScheme.onSurface,
            numbersType: numbersType,
            ticksType: ticksType,
            tickColor: colorScheme.onSurface.withOpacity(0.6),
            numeralType: numeralType,
            textScaleFactor: 1.4,
            digitalClockColor: colorScheme.onSurface.withOpacity(0.6),
            showDigitalClock: showDigitalClock,
            dateTime: dateTime,
            // showTicksInsteadOfMinorNumbers: true,
            // dateTime: DateTime(2019, 1, 1, 9, 12, 15),
          ),
        ],
      );
    });
  }
}
