import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/timezone.dart' as timezone;

import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/clock.dart';
import 'package:clock_app/clock/types/time.dart';

class TimeZoneCard extends StatelessWidget {
  TimeZoneCard({
    Key? key,
    required this.city,
    required this.onDelete,
  }) : super(key: key) {
    timezoneLocation = timezone.getLocation(city.timezone);
    offset = (timezoneLocation.currentTimeZone.offset -
            DateTime.now().timeZoneOffset.inMilliseconds) /
        3600000;
  }

  late final timezone.Location timezoneLocation;
  late final double offset;
  final City city;
  final Function onDelete;

  String formatTimeOffset(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    var deleteActionPane = ActionPane(
      motion: const ScrollMotion(),
      // extentRatio: Platform == 0.25,
      children: [
        CustomSlidableAction(
          onPressed: (context) => onDelete(),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete),
              Text('Delete',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ],
    );

    var contents = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Flutter doesn't allow per character overflow, so this is a workaround
                  city.name.replaceAll('', '\u{200B}'),
                  style: Theme.of(context).textTheme.displaySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                TimerBuilder.periodic(
                  const Duration(seconds: 1),
                  builder: (context) {
                    DateTime currentTime = DateTime.now();
                    DateTime cityTime =
                        timezone.TZDateTime.now(timezoneLocation);
                    return Text(
                      '${offset != 0 ? '${formatTimeOffset(offset.abs())} ${offset == 1 ? 'hour' : 'hours'} ${offset < 0 ? 'behind' : 'ahead'}' : 'Same time'}${currentTime.day < cityTime.day ? ' (next day)' : currentTime.day > cityTime.day ? ' (previous day)' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Clock(
            timezoneLocation: timezoneLocation,
            scale: 0.3,
            timeFormat: TimeFormat.H12,
          ),
        ],
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        child: Slidable(
            groupTag: 'cities',
            key: key,
            startActionPane: deleteActionPane,
            endActionPane: deleteActionPane,
            child: contents),
      ),
    );
  }
}
