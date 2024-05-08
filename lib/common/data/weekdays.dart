import 'package:clock_app/common/types/weekday.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<Weekday> weekdays = [
  Weekday(1, (context) => AppLocalizations.of(context)!.mondayLetter,
      (context) => AppLocalizations.of(context)!.mondayShort),
  Weekday(2, (context) => AppLocalizations.of(context)!.tuesdayLetter,
      (context) => AppLocalizations.of(context)!.tuesdayShort),
  Weekday(3, (context) => AppLocalizations.of(context)!.wednesdayLetter,
      (context) => AppLocalizations.of(context)!.wednesdayShort),
  Weekday(4, (context) => AppLocalizations.of(context)!.thursdayLetter,
      (context) => AppLocalizations.of(context)!.thursdayShort),
  Weekday(5, (context) => AppLocalizations.of(context)!.fridayLetter,
      (context) => AppLocalizations.of(context)!.fridayShort),
  Weekday(6, (context) => AppLocalizations.of(context)!.saturdayLetter,
      (context) => AppLocalizations.of(context)!.saturdayShort),
  Weekday(7, (context) => AppLocalizations.of(context)!.sundayLetter,
      (context) => AppLocalizations.of(context)!.sundayShort),
];
