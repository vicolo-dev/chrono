import 'package:clock_app/common/types/clock_settings_types.dart';
import 'package:flutter/material.dart';
import 'dart:math';

const List<String> romanNumerals = [
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  'VIII',
  'IX',
  'X',
  'XI',
  'XII'
];

const List<String> arabicNumerals = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12'
];

class AnalogClockPainter extends CustomPainter {
  DateTime dateTime;
  final bool showDigitalClock;
  final ClockTicksType ticksType;
  final ClockNumbersType numbersType;
    final ClockNumeralType numeralType;
  final bool showSecondHand;
  final bool showTicksInsteadOfMinorNumbers;
  final bool useMilitaryTime;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color tickColor;
  final Color digitalClockColor;
  final Color numberColor;
  final double textScaleFactor;

  static const double baseSize = 320.0;
  static const double minutesInHour = 60.0;
  static const double secondsInMinute = 60.0;
  static const double hoursInClock = 12.0;
  static const double handPinHoleSize = 8.0;
  static const double strokeWidth = 3.0;

  AnalogClockPainter(
      {required this.dateTime,
      this.numbersType = ClockNumbersType.quarter,
      this.numeralType = ClockNumeralType.arabic,
      this.showDigitalClock = true,
      this.ticksType = ClockTicksType.none,
      this.showSecondHand = true,
      this.hourHandColor = Colors.black,
      this.minuteHandColor = Colors.black,
      this.secondHandColor = Colors.redAccent,
      this.tickColor = Colors.grey,
      this.showTicksInsteadOfMinorNumbers = false,
      this.digitalClockColor = Colors.black,
      this.numberColor = Colors.black,
      this.textScaleFactor = 1.0,
      this.useMilitaryTime = true});

  @override
  void paint(Canvas canvas, Size size) {
    double scaleFactor = size.shortestSide / baseSize;

    if (ticksType != ClockTicksType.none) {
      _paintTickMarks(canvas, size, scaleFactor);
    }
    if (numbersType != ClockNumbersType.none) {
      _drawNumbers(canvas, size, scaleFactor);
    }

    if (showDigitalClock) {
      _paintDigitalClock(canvas, size, scaleFactor, useMilitaryTime);
    }

    _paintClockHands(canvas, size, scaleFactor);
    _paintPinHole(canvas, size, scaleFactor);
  }

  @override
  bool shouldRepaint(AnalogClockPainter oldDelegate) {
    return oldDelegate.dateTime.isBefore(dateTime);
  }

  _paintPinHole(canvas, size, scaleFactor) {
    Paint midPointStrokePainter = Paint()
      ..color = showSecondHand ? secondHandColor : minuteHandColor
      ..strokeWidth = strokeWidth * scaleFactor
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), handPinHoleSize * scaleFactor,
        midPointStrokePainter);
  }

  void _drawNumbers(Canvas canvas, Size size, double scaleFactor) {
    TextStyle style = TextStyle(
        color: numberColor,
        fontWeight: FontWeight.bold,
        fontSize: 18.0 * scaleFactor * textScaleFactor);
    double p = 30.0;
    if (ticksType != ClockTicksType.none) p += 12.0;

    double r = size.shortestSide / 2;
    double longHandLength = r - (p * scaleFactor);

    List<String> numerals =
        numeralType == ClockNumeralType.roman ? romanNumerals : arabicNumerals;

    for (var h = 1; h <= 12; h++) {
      if (numbersType != ClockNumbersType.all && h % 3 != 0) continue;
      double angle = (h * pi / 6) - pi / 2; //+ pi / 2;
      Offset offset =
          Offset(longHandLength * cos(angle), longHandLength * sin(angle));
      TextSpan span = TextSpan(style: style, text: numerals[h - 1].toString());
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, size.center(offset - tp.size.center(Offset.zero)));
    }
  }

  Offset _getHandOffset(double percentage, double length) {
    final radians = 2 * pi * percentage;
    final angle = -pi / 2.0 + radians;

    return Offset(length * cos(angle), length * sin(angle));
  }

  // ref: https://www.codenameone.com/blog/codename-one-graphics-part-2-drawing-an-analog-clock.html
  void _paintTickMarks(Canvas canvas, Size size, double scaleFactor) {
    double r = size.shortestSide / 2;
    double tick = 5 * scaleFactor,
        mediumTick = 2.0 * tick,
        longTick = 3.0 * tick;
    double p = longTick + 4 * scaleFactor;
    Paint tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 2.0 * scaleFactor;

    for (int i = 1; i <= 60; i++) {
      // default tick length is short
      double len = tick;
      if (i % 15 == 0) {
        // Longest tick on quarters (every 15 ticks)
        len = longTick;
      } else if (i % 5 == 0) {
        // Medium ticks on the '5's (every 5 ticks)
        len = mediumTick;
      } else {
        if (ticksType != ClockTicksType.all) {
          continue;
        }
      }
      // Get the angle from 12 O'Clock to this tick (radians)
      double angleFrom12 = i / 60.0 * 2.0 * pi;

      // Get the angle from 3 O'Clock to this tick
      // Note: 3 O'Clock corresponds with zero angle in unit circle
      // Makes it easier to do the math.
      double angleFrom3 = pi / 2.0 - angleFrom12;

      canvas.drawLine(
          size.center(Offset(cos(angleFrom3) * (r + len - p),
              sin(angleFrom3) * (r + len - p))),
          size.center(
              Offset(cos(angleFrom3) * (r - p), sin(angleFrom3) * (r - p))),
          tickPaint);
    }
  }

  void _paintClockHands(Canvas canvas, Size size, double scaleFactor) {
    double r = size.shortestSide / 2;
    double p = 0.0;
    if (ticksType != ClockTicksType.none) p += 28.0;
    if (numbersType != ClockNumbersType.none) p += 24.0;
    if (numbersType == ClockNumbersType.all) p += 24.0;
    double longHandLength = r - (p * scaleFactor);
    double shortHandLength = r - (p + 36.0) * scaleFactor;

    Paint handPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.bevel
      ..strokeWidth = strokeWidth * scaleFactor;
    double seconds = dateTime.second / secondsInMinute;
    double minutes = (dateTime.minute + seconds) / minutesInHour;
    double hour = (dateTime.hour + minutes) / hoursInClock;

    canvas.drawLine(
        size.center(_getHandOffset(hour, handPinHoleSize * scaleFactor)),
        size.center(_getHandOffset(hour, shortHandLength)),
        handPaint..color = hourHandColor);

    canvas.drawLine(
        size.center(_getHandOffset(minutes, handPinHoleSize * scaleFactor)),
        size.center(_getHandOffset(minutes, longHandLength)),
        handPaint..color = minuteHandColor);
    if (showSecondHand) {
      canvas.drawLine(
          size.center(_getHandOffset(seconds, handPinHoleSize * scaleFactor)),
          size.center(_getHandOffset(seconds, longHandLength)),
          handPaint..color = secondHandColor);
    }
  }

  void _paintDigitalClock(
      Canvas canvas, Size size, double scaleFactor, bool useMilitaryTime) {
    int hourInt = dateTime.hour;
    String meridiem = '';
    if (!useMilitaryTime) {
      if (hourInt > 12) {
        hourInt = hourInt - 12;
        meridiem = ' PM';
      } else {
        meridiem = ' AM';
      }
    }
    String hour = hourInt.toString().padLeft(2, "0");
    String minute = dateTime.minute.toString().padLeft(2, "0");
    String second = dateTime.second.toString().padLeft(2, "0");
    TextSpan digitalClockSpan = TextSpan(
        style: TextStyle(
            color: digitalClockColor,
            fontSize: 18 * scaleFactor * textScaleFactor),
        text: "$hour:$minute:$second$meridiem");
    TextPainter digitalClockTP = TextPainter(
        text: digitalClockSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    digitalClockTP.layout();
    digitalClockTP.paint(
        canvas,
        size.center(
            -digitalClockTP.size.center(Offset(0.0, -size.shortestSide / 6))));
  }
}
