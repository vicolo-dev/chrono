import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timezone/timezone.dart' as timezone;

import 'package:clock_app/widgets/timezone_clock.dart';
import '../types/city.dart';

class TimeZoneCard extends StatelessWidget {
  TimeZoneCard({
    Key? key,
    required this.city,
    required this.onDelete,
  }) : super(key: key) {
    timezoneLocation = timezone.getLocation(city.timeZone);
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
        SlidableAction(
          onPressed: (context) => onDelete(),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
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
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                offset != 0
                    ? ' ${formatTimeOffset(offset.abs())} ${offset == 1 ? 'hour' : 'hours'} ${offset < 0 ? 'behind' : 'ahead'}'
                    : 'Same time',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const Spacer(),
          TimeZoneClock(timezoneLocation: timezoneLocation, fontSize: 22),
        ],
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Slidable(
            key: key,
            startActionPane: deleteActionPane,
            endActionPane: deleteActionPane,
            child: contents),
      ),
    );
  }
}
