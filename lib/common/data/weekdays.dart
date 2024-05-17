import 'package:clock_app/common/types/weekday.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<Weekday> weekdays = [
  Weekday(
      1,
      (context) => AppLocalizations.of(context)!.mondayLetter,
      (context) => AppLocalizations.of(context)!.mondayShort,
      (context) => AppLocalizations.of(context)!.mondayFull),
  Weekday(
      2,
      (context) => AppLocalizations.of(context)!.tuesdayLetter,
      (context) => AppLocalizations.of(context)!.tuesdayShort,
      (context) => AppLocalizations.of(context)!.tuesdayFull),
  Weekday(
      3,
      (context) => AppLocalizations.of(context)!.wednesdayLetter,
      (context) => AppLocalizations.of(context)!.wednesdayShort,
      (context) => AppLocalizations.of(context)!.wednesdayFull),
  Weekday(
      4,
      (context) => AppLocalizations.of(context)!.thursdayLetter,
      (context) => AppLocalizations.of(context)!.thursdayShort,
      (context) => AppLocalizations.of(context)!.thursdayFull),
  Weekday(
      5,
      (context) => AppLocalizations.of(context)!.fridayLetter,
      (context) => AppLocalizations.of(context)!.fridayShort,
      (context) => AppLocalizations.of(context)!.fridayFull),
  Weekday(
      6,
      (context) => AppLocalizations.of(context)!.saturdayLetter,
      (context) => AppLocalizations.of(context)!.saturdayShort,
      (context) => AppLocalizations.of(context)!.saturdayFull),
  Weekday(
      7,
      (context) => AppLocalizations.of(context)!.sundayLetter,
      (context) => AppLocalizations.of(context)!.sundayShort,
      (context) => AppLocalizations.of(context)!.sundayFull),
];
