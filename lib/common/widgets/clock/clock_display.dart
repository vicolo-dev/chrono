import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/common/widgets/clock/time_display.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';

class ClockDisplay extends StatefulWidget {
  const ClockDisplay({
    Key? key,
    this.scale = 1,
    this.color,
    this.shouldShowDate = false,
    this.shouldShowSeconds = false,
    required this.dateTime,
    this.horizontalAlignment = ElementAlignment.start,
  }) : super(key: key);

  final double scale;
  final bool shouldShowDate;
  final Color? color;
  final DateTime dateTime;
  final bool shouldShowSeconds;
  final ElementAlignment horizontalAlignment;

  @override
  State<ClockDisplay> createState() => _ClockDisplayState();
}

class _ClockDisplayState extends State<ClockDisplay> {
  late TimeFormat timeFormat;

  void setTimeFormat(dynamic newTimeFormat) {
    setState(() {
      timeFormat = newTimeFormat;
      if (timeFormat == TimeFormat.device) {
        if (MediaQuery.of(context).alwaysUse24HourFormat) {
          timeFormat = TimeFormat.h24;
        } else {
          timeFormat = TimeFormat.h12;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setTimeFormat(appSettings.getSetting("Time Format").value);
    appSettings.addSettingListener("Time Format", setTimeFormat);
  }

  @override
  void dispose() {
    appSettings.removeSettingListener("Time Format", setTimeFormat);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.values[widget.horizontalAlignment.index],
      children: <Widget>[
        Row(
            mainAxisAlignment:
                MainAxisAlignment.values[widget.horizontalAlignment.index],
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              TimeDisplay(
                format: '${timeFormat == TimeFormat.h12 ? 'h' : 'kk'}:mm',
                fontSize: 72 * widget.scale,
                height: widget.shouldShowDate ? 0.75 : null,
                color: widget.color,
                dateTime: widget.dateTime,
              ),
              SizedBox(width: 4 * widget.scale),
              Column(
                verticalDirection: VerticalDirection.up,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.shouldShowSeconds)
                    TimeDisplay(
                      format: 'ss',
                      fontSize: 36 * widget.scale,
                      height: 1,
                      color: widget.color,
                      dateTime: widget.dateTime,
                    ),
                  Row(
                    children: timeFormat == TimeFormat.h12
                        ? [
                            TimeDisplay(
                              format: 'a',
                              fontSize: (widget.shouldShowSeconds ? 24 : 32) *
                                  widget.scale,
                              height: 1,
                              color: widget.color,
                              dateTime: widget.dateTime,
                            ),
                            if (widget.shouldShowSeconds)
                              SizedBox(width: 16 * widget.scale),
                          ]
                        : [
                            if (widget.shouldShowSeconds)
                              SizedBox(width: 56 * widget.scale),
                          ],
                  ),
                ],
              ),
            ]),
        if (widget.shouldShowDate)
          TimeDisplay(
            format: 'EEE, MMM d',
            fontSize: 16 * widget.scale,
            height: 1,
            dateTime: widget.dateTime,
            color: widget.color ??
                Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
          ),
      ],
    );
  }
}
