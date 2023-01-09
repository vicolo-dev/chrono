import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/settings/logic/settings.dart';

const List<City> initialFavoriteCities = [
  City("New York", "United States", "America/New_York"),
  City("London", "United Kingdom", "Europe/London"),
  City("Paris", "France", "Europe/Paris"),
  City("Tokyo", "Japan", "Asia/Tokyo"),
];

void initializeDefaultFavoriteCities() {
  saveFavoriteCities(initialFavoriteCities);
}

List<City> loadFavoriteCities() {
  final String? encodedFavoriteCities =
      Settings.preferences?.getString('favorite_cities');

  if (encodedFavoriteCities == null) {
    return [];
  }

  return City.decode(encodedFavoriteCities);
}

void saveFavoriteCities(List<City> cities) {
  Settings.preferences?.setString('favorite_cities', City.encode(cities));
}
