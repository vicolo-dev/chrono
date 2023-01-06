import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class MainClock extends StatelessWidget {
  const MainClock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, MMM d').format(now);
    String meridiem = DateFormat('a').format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            // eliminate padding between children
            children: [
              TimerBuilder.periodic(
                const Duration(seconds: 1),
                builder: (context) {
                  DateTime now = DateTime.now();
                  String formattedTime = DateFormat('h:mm').format(now);
                  return Text(
                    formattedTime,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(height: 0.75),
                  );
                },
              ),
              const SizedBox(width: 5),
              Text(meridiem,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(height: 1)),
            ]),
        Text(formattedDate,
            style:
                Theme.of(context).textTheme.displaySmall?.copyWith(height: 1)),
      ],
    );
  }
}
