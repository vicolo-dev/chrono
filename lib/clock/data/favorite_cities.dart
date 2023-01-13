import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/common/utils/list_storage.dart';

const List<City> initialFavoriteCities = [
  City("New York City", "United States", "America/New_York"),
  City("London", "United Kingdom", "Europe/London"),
  City("Paris", "France", "Europe/Paris"),
  City("Tokyo", "Japan", "Asia/Tokyo"),
];

void initializeDefaultFavoriteCities() {
  saveList('favorite_cities', initialFavoriteCities);
}

// List<City> loadFavoriteCities() {
//   final String? encodedFavoriteCities =
//       SettingsManager.preferences?.getString('favorite_cities');

//   if (encodedFavoriteCities == null) {
//     return [];
//   }

//   return decodeList(encodedFavoriteCities);
// }

// void saveFavoriteCities(List<City> cities) {
//   SettingsManager.preferences?.setString('favorite_cities', encodeList(cities));
// }
