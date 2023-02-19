import 'package:clock_app/common/widgets/delete_action_pane.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TimerCard extends StatefulWidget {
  const TimerCard({
    Key? key,
    required this.timer,
    required this.onDelete,
    required this.onDuplicate,
    required this.onTap,
  }) : super(key: key);

  final Timer timer;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onTap;

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: widget.onTap,
          child: Slidable(
              groupTag: 'timers',
              key: widget.key,
              startActionPane:
                  getDuplicateActionPane(widget.onDuplicate, context),
              endActionPane: getDeleteActionPane(widget.onDelete, context),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        widget.timer.duration.toString(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }
}
