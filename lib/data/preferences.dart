import 'package:clock_app/types/city.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;

  static initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static List<City> getFavoriteCities() {
    final String? encodedFavoriteCities =
        _preferences?.getString('favorite_cities');

    if (encodedFavoriteCities == null) {
      return [];
    }

    return City.decode(encodedFavoriteCities);
  }

  static void saveFavoriteCities(List<City> cities) {
    _preferences?.setString('favorite_cities', City.encode(cities));
  }
}
