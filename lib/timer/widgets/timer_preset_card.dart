import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:flutter/material.dart';

class TimerPresetCard extends StatefulWidget {
  const TimerPresetCard({
    Key? key,
    required this.preset,
    required this.onPressDelete,
    required this.onPressDuplicate,
  }) : super(key: key);

  final TimerPreset preset;
  final VoidCallback onPressDelete;
  final VoidCallback onPressDuplicate;

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
            Expanded(
              flex: 999,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.preset.name,
                    style: Theme.of(context).textTheme.displaySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  Text(
                    widget.preset.duration.toReadableString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
            ),
            CardEditMenu(
              onPressDelete: widget.onPressDelete,
              onPressDuplicate: widget.onPressDuplicate,
            ),
          ],
        ));
  }
}
