import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/developer/types/log.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<ListSortOption<Log>> logSortOptions = [
  ListSortOption((context) => "Earliest first", sortDateAscending),
  ListSortOption((context) => "Latest first", sortDateDescending),
];

int sortDateAscending(Log a, Log b) {
  return a.id.compareTo(b.id);
}

int sortDateDescending(Log a, Log b) {
  return b.id.compareTo(a.id);
}

