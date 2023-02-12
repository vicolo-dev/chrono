import 'package:flutter/material.dart';

class SliderCard extends StatefulWidget {
  const SliderCard(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.min,
      required this.max,
      required this.name,
      this.unit = ''})
      : super(key: key);

  final String name;
  final double value;
  final double min;
  final double max;
  final String unit;
  final void Function(double value)? onChanged;

  @override
  State<SliderCard> createState() => _SliderCardState();
}

class _SliderCardState extends State<SliderCard> {
  Size calcTextSize(int length, TextStyle style) {
    String text = '0' * length;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    String valueString = '${widget.value.toStringAsFixed(0)} ${widget.unit}';
    String maxValueString = '${widget.max.toStringAsFixed(0)} ${widget.unit}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              SizedBox(
                width: calcTextSize(maxValueString.length,
                        Theme.of(context).textTheme.bodyMedium!)
                    .width,
                child: Text(
                  valueString,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 4),
              // const SizedBox(width: 8.0),
              Expanded(
                flex: 7,
                child: Slider(
                  value: widget.value,
                  onChanged: widget.onChanged,
                  min: widget.min,
                  max: widget.max,
                ),
              ),
              // const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
