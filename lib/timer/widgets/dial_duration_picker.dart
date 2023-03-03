import 'dart:math' as math;

import 'package:clock_app/theme/text.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

class DialDurationPicker extends StatefulWidget {
  const DialDurationPicker(
      {super.key,
      required this.duration,
      required this.onChange,
      this.showHours = true});

  final TimeDuration duration;
  final void Function(TimeDuration) onChange;
  final bool showHours;

  @override
  State<DialDurationPicker> createState() => _DialDurationPickerState();
}

class _DialDurationPickerState extends State<DialDurationPicker> {
  @override
  Widget build(BuildContext context) {
    double originalWidth = MediaQuery.of(context).size.width;
    double width = originalWidth - 48;

    double leftPadding = 8;

    return Stack(
      children: [
        Positioned(
          left: leftPadding,
          top: leftPadding,
          child: TimerKnob(
            maxValue: 60,
            minValue: 0,
            value: widget.duration.seconds,
            size: Size(width, width),
            onChanged: (value) {
              widget.onChange(TimeDuration(
                  hours: widget.duration.hours,
                  minutes: widget.duration.minutes,
                  seconds: value));
            },
            handleLabel: 'S',
            handleLabelOffset: 5,
            divisions: 12,
            snapDivisions: 60,
            fillColor:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
          ),
        ),
        Positioned(
          left: 40 + leftPadding,
          top: 40 + leftPadding,
          child: TimerKnob(
            maxValue: 60,
            minValue: 0,
            value: widget.duration.minutes,
            size: Size(width - 80, width - 80),
            onChanged: (value) {
              widget.onChange(TimeDuration(
                  hours: widget.duration.hours,
                  minutes: value,
                  seconds: widget.duration.seconds));
            },
            handleLabel: 'M',
            handleLabelOffset: 7,
            divisions: 12,
            snapDivisions: 60,
            fillColor:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
          ),
        ),
        if (widget.showHours)
          Positioned(
            left: 80 + leftPadding,
            top: 80 + leftPadding,
            child: TimerKnob(
              maxValue: 24,
              minValue: 0,
              value: widget.duration.hours,
              size: Size(width - 160, width - 160),
              onChanged: (value) {
                widget.onChange(TimeDuration(
                    hours: value,
                    minutes: widget.duration.minutes,
                    seconds: widget.duration.seconds));
              },
              handleLabel: 'H',
              handleLabelOffset: 6,
              divisions: 8,
              snapDivisions: 24,
              fillColor:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            ),
          ),
      ],
    );
  }
}

class TimerKnob extends StatefulWidget {
  final int value;
  final double minValue;
  final double maxValue;
  final ValueChanged<int> onChanged;
  final Size size;
  final String handleLabel;
  final double handleLabelOffset;
  final double divisions;
  final double snapDivisions;
  final Color fillColor;

  const TimerKnob({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.size,
    required this.handleLabel,
    required this.handleLabelOffset,
    required this.divisions,
    required this.snapDivisions,
    required this.fillColor,
  });

  @override
  State<TimerKnob> createState() => _TimerKnobState();
}

class _TimerKnobState extends State<TimerKnob> {
  double _angle = 0.0;
  late int _currentDuration;

  @override
  void initState() {
    super.initState();
    _currentDuration = widget.value;
    _angle = _durationToAngle(_currentDuration);
  }

  @override
  Widget build(BuildContext context) {
    final center = Offset(widget.size.width / 2, widget.size.height / 2);
    final radius = math.min(center.dx, center.dy);

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTapUp: _onTapUp,
      child: CustomPaint(
        size: widget.size,
        painter: _TimerKnobPainter(
          angle: _angle,
          radius: radius,
          handleLabel: widget.handleLabel,
          handleLabelOffset: widget.handleLabelOffset,
          divisions: widget.divisions,
          fillColor: widget.fillColor,
          maxValue: widget.maxValue,
          knobColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }

  void _onTapUp(TapUpDetails tapUpDetails) {
    _updateAngle(tapUpDetails.localPosition, snapToMajor: true);
    widget.onChanged(_currentDuration);
  }

  void _onPanStart(DragStartDetails details) {
    _updateAngle(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateAngle(details.localPosition);
    widget.onChanged(_currentDuration);
  }

  void _onPanEnd(DragEndDetails details) {
    widget.onChanged(_currentDuration);
  }

  void _updateAngle(Offset position, {bool snapToMajor = false}) {
    final center = Offset(
      (context.size?.width)! / 2,
      (context.size?.height)! / 2,
    );
    double angle = (position - center).direction;

    double snapDivisions =
        snapToMajor ? widget.divisions : widget.snapDivisions;

    //round the angle to the nearest 6 degrees
    final snapAngle = (math.pi * 2) / snapDivisions;
    angle = (angle / snapAngle).round() * snapAngle;

    setState(() {
      _angle = angle;
      _currentDuration = _angleToDuration(angle);
    });
  }

  double _durationToAngle(int duration) {
    final percentage =
        (duration - widget.minValue) / (widget.maxValue - widget.minValue);
    final angle = percentage * (math.pi * 2) - (math.pi / 2);
    return angle;
  }

  int _angleToDuration(double angle) {
    final clampedAngle = angle % (math.pi * 2);
    final percentage = (clampedAngle / (math.pi * 2) + 0.25) % 1.0;
    final duration =
        percentage * (widget.maxValue - widget.minValue) + widget.minValue;
    return duration.round();
  }
}

class _TimerKnobPainter extends CustomPainter {
  final double angle;
  final double radius;
  final String handleLabel;
  final double handleLabelOffset;
  final double divisions;
  final Color fillColor;
  final Color knobColor;
  final Color textColor;
  final double maxValue;

  _TimerKnobPainter({
    required this.angle,
    required this.radius,
    required this.handleLabel,
    required this.handleLabelOffset,
    required this.divisions,
    required this.fillColor,
    required this.maxValue,
    required this.knobColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final trackCirclePaint = Paint()
      ..color = fillColor
      ..blendMode = BlendMode.srcOver
      // ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final knobCirclePaint = Paint()
      ..color = knobColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    double trackRadius = radius;

    canvas.drawCircle(center, trackRadius, trackCirclePaint);

    double markerAngleDelta = math.pi / (divisions / 2);
    for (double i = 0; i < math.pi * 2; i += markerAngleDelta) {
      int num = ((i / markerAngleDelta) * (maxValue / divisions)).round();
      final textSpan = TextSpan(
        text: '$num',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Rubik',
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);

      final offset = Offset(
          center.dx + math.cos(i - math.pi / 2) * (trackRadius - 20) - 6,
          center.dy + math.sin(i - math.pi / 2) * (trackRadius - 20) - 6);

      textPainter.paint(canvas, offset);
    }

    final knobAngle = angle;
    final knobPositionRadius = trackRadius - 20;
    final knobX = center.dx + math.cos(knobAngle) * (knobPositionRadius);
    final knobY = center.dy + math.sin(knobAngle) * (knobPositionRadius);
    final knobCenter = Offset(knobX, knobY);

    double knobRadius = 16.0;

    canvas.drawCircle(knobCenter, knobRadius, knobCirclePaint);

    final textSpan = TextSpan(
      text: handleLabel,
      style: textTheme.displaySmall?.copyWith(
        fontFamily: 'Rubik',
        color: Colors.white,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final textCenter = Offset(knobX - handleLabelOffset, knobY - 9);
    textPainter.paint(canvas, textCenter);
  }

  @override
  bool shouldRepaint(_TimerKnobPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
