import 'package:clock_app/widgets/clock.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timezone/timezone.dart' as timezone;

import '../types/city.dart';

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                offset != 0
                    ? '${formatTimeOffset(offset.abs())} ${offset == 1 ? 'hour' : 'hours'} ${offset < 0 ? 'behind' : 'ahead'}'
                    : 'Same time',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          Clock(timezoneLocation: timezoneLocation, scale: 0.5),
        ],
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        clipBehavior: Clip.hardEdge,
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
