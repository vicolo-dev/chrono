import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/clock/digital_clock.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/timezone.dart' as timezone;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeZoneSearchCard extends StatelessWidget {
  TimeZoneSearchCard(
      {super.key,
      required this.city,
      required this.onTap,
      this.disabled = false}) {
    timezoneLocation = timezone.getLocation(city.timezone);
  }

  final bool disabled;
  late final timezone.Location timezoneLocation;
  final City city;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gmtOffset = timezoneLocation.currentTimeZone.offset;
    final gmtOffsetHour = gmtOffset / 3600000;
    final gmtOffsetMinutes = (gmtOffset % 3600000) / 60000;
    Color? textColor = disabled
        ? Theme.of(context).colorScheme.onBackground.withOpacity(0.6)
        : null;
    return SizedBox(
      width: double.infinity,
      child: CardContainer(
        elevationMultiplier: disabled ? 0.5 : 1,
        onTap: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          if (disabled) {
            showSnackBar(
                context, AppLocalizations.of(context)!.cityAlreadyInFavorites);
          } else {
            onTap();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: textColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    const SizedBox(height: 4),
                    TimerBuilder.periodic(
                      const Duration(seconds: 1),
                      builder: (context) {
                        return Text(
                          city.country,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: textColor,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  DigitalClock(
                    timezoneLocation: timezoneLocation,
                    scale: 0.3,
                    color: textColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'GMT ${gmtOffset > 0 ? '+' : '-'}${gmtOffsetHour.abs().toStringAsFixed(0).padLeft(2, '0')}:${gmtOffsetMinutes.toStringAsFixed(0).padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
// TimezoneCardContent(
//           title: city.name,
//           subtitle: city.country,
//           timezoneLocation: timezoneLocation,
//           textColor: ,
//         ),
//       ),
//     );
  }
}
