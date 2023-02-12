import 'package:clock_app/clock/data/default_favorite_cities.dart';
import 'package:clock_app/common/utils/list_storage.dart';

void initializeDefaultFavoriteCities() {
  saveList('favorite_cities', initialFavoriteCities);
}
