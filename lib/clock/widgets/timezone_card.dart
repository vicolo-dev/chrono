import 'package:clock_app/clock/widgets/timzone_card_content.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timezone/timezone.dart' as timezone;

import 'package:clock_app/clock/types/city.dart';

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

  String getOffsetDescription() {
    DateTime currentTime = DateTime.now();
    DateTime cityTime = timezone.TZDateTime.now(timezoneLocation);

    String hourDifference = formatTimeOffset(offset.abs());
    String hourLabel = offset == 1 ? 'hour' : 'hours';
    String relativeLabel = offset < 0 ? 'behind' : 'ahead';
    String differentOffsetLabel = '$hourDifference $hourLabel $relativeLabel';
    String offsetLabel = offset != 0 ? differentOffsetLabel : 'Same time';

    String differentDayLabel = currentTime.day < cityTime.day
        ? ' (next day)'
        : currentTime.day > cityTime.day
            ? ' (previous day)'
            : '';

    return '$offsetLabel$differentDayLabel';
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

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Slidable(
            groupTag: 'cities',
            key: key,
            startActionPane: deleteActionPane,
            endActionPane: deleteActionPane,
            child: TimezoneCardContent(
              title: city.name,
              subtitle: getOffsetDescription(),
              timezoneLocation: timezoneLocation,
            )),
      ),
    );
  }
}
