import 'package:flutter/material.dart';

import 'package:timezone/timezone.dart' as timezone;

import 'package:clock_app/widgets/timezone_clock.dart';
import 'package:clock_app/types/city.dart';

class TimeZoneSearchCard extends StatelessWidget {
  TimeZoneSearchCard({
    Key? key,
    required this.city,
    required this.onTap,
  }) : super(key: key) {
    timezoneLocation = timezone.getLocation(city.timezone);
  }

  late final timezone.Location timezoneLocation;
  final City city;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Padding(
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
                        city.country,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  TimeZoneClock(
                      timezoneLocation: timezoneLocation, fontSize: 22),
                ],
              ),
            ),
            onTap: () => onTap(),
          )),
    );
  }
}
