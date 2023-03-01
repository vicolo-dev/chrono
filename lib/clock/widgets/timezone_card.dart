import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card_content.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as timezone;

class TimeZoneCard extends StatelessWidget {
  TimeZoneCard({
    Key? key,
    required this.city,
  }) : super(key: key) {
    timezoneLocation = timezone.getLocation(city.timezone);
    offset = (timezoneLocation.currentTimeZone.offset -
            DateTime.now().timeZoneOffset.inMilliseconds) /
        3600000;
  }

  late final timezone.Location timezoneLocation;
  late final double offset;
  final City city;

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
    return TimezoneCardContent(
      title: city.name,
      subtitle: getOffsetDescription(),
      timezoneLocation: timezoneLocation,
    );
  }
}
