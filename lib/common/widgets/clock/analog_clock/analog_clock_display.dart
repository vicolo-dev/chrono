library analog_clock;

import 'dart:async';
import 'package:clock_app/common/types/clock_settings_types.dart';
import 'package:flutter/material.dart';
import 'analog_clock_painter.dart';

class AnalogClockDisplay extends StatelessWidget {
  final DateTime dateTime;
  final bool showDigitalClock;
  final ClockTicksType ticksType;
  final ClockNumbersType numbersType;
  final ClockNumeralType numeralType;
  final bool showSecondHand;
  final bool useMilitaryTime;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color tickColor;
  final Color digitalClockColor;
  final Color numberColor;
  final bool showTicksInsteadOfMinorNumbers;
  final double textScaleFactor;
  final double width;
  final double height;
  final BoxDecoration decoration;

  const AnalogClockDisplay(
      {required this.dateTime,
      this.showDigitalClock = true,
      this.ticksType = ClockTicksType.none,
      this.numbersType = ClockNumbersType.quarter,
      this.numeralType = ClockNumeralType.arabic,
      this.showSecondHand = true,
      this.useMilitaryTime = true,
      this.hourHandColor = Colors.black,
      this.minuteHandColor = Colors.black,
      this.secondHandColor = Colors.redAccent,
      this.tickColor = Colors.grey,
      this.digitalClockColor = Colors.black,
      this.numberColor = Colors.black,
      this.textScaleFactor = 1.0,
      this.showTicksInsteadOfMinorNumbers = false,
      this.width = double.infinity,
      this.height = double.infinity,
      this.decoration = const BoxDecoration(),
      isLive,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      child: Center(
          child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
                  width: double.infinity,
                  child: CustomPaint(
                    painter: AnalogClockPainter(
                        dateTime: dateTime,
                        numbersType: numbersType,
                        numeralType: numeralType,
                        ticksType: ticksType,
                        showDigitalClock: showDigitalClock,
                        showTicksInsteadOfMinorNumbers:
                            showTicksInsteadOfMinorNumbers,
                        showSecondHand: showSecondHand,
                        useMilitaryTime: useMilitaryTime,
                        hourHandColor: hourHandColor,
                        minuteHandColor: minuteHandColor,
                        secondHandColor: secondHandColor,
                        tickColor: tickColor,
                        digitalClockColor: digitalClockColor,
                        textScaleFactor: textScaleFactor,
                        numberColor: numberColor),
                  )))),
    );
  }
}
