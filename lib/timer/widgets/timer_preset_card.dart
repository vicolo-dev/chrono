import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:flutter/material.dart';

class TimerPresetCard extends StatefulWidget {
  const TimerPresetCard({
    Key? key,
    required this.preset,
    required this.onPressDelete,
  }) : super(key: key);

  final TimerPreset preset;
  final VoidCallback onPressDelete;

  @override
  State<TimerPresetCard> createState() => _TimerPresetCardState();
}

class _TimerPresetCardState extends State<TimerPresetCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 4, top: 8, bottom: 8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.preset.name,
                    style: Theme.of(context).textTheme.displaySmall),
                Text(widget.preset.duration.toReadableString(),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: widget.onPressDelete,
              icon: Icon(Icons.close_rounded,
                  color: Theme.of(context).colorScheme.error),
            ),
          ],
        ));
  }
}
