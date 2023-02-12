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
  @override
  Widget build(BuildContext context) {
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
              Expanded(
                flex: 3,
                child: Text(
                  '${widget.value.toStringAsFixed(0)} ${'minutes'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
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
