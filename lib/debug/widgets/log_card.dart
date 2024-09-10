import 'package:clock_app/debug/types/log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class LogCard extends StatefulWidget {
  const LogCard({
    super.key,
    required this.log,
  });

  final Log log;

  @override
  State<LogCard> createState() => _LogCardState();
}

class LevelColor {
  Color backgroundColor;
  Color textColor;

  LevelColor(this.backgroundColor, this.textColor);
}

Map<Level, LevelColor> levelColors = {
  Level.debug: LevelColor(Colors.brown, Colors.white),
  Level.trace: LevelColor(Colors.grey, Colors.white),
  Level.info: LevelColor(Colors.blue, Colors.white),
  Level.warning: LevelColor(Colors.orange, Colors.white),
  Level.error: LevelColor(Colors.red, Colors.white),
  Level.fatal: LevelColor(Colors.purple, Colors.white),
};

class _LogCardState extends State<LogCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: levelColors[widget.log.level]?.backgroundColor,
                  ),
                  child: Text(widget.log.level.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: levelColors[widget.log.level]?.textColor,
                          )),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  DateFormat('yyyy-MM-dd | kk:mm:ss')
                      .format(widget.log.dateTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
              ],
            ),
            Text(
              widget.log.message,
              style: Theme.of(context).textTheme.bodyMedium,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
              // softWrap: false,
            ),
          ],
        ));
  }
}
