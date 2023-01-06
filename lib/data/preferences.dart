import 'package:clock_app/types/city.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<City>> getFavoriteCities() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  final String? encodedFavoriteCities =
      preferences.getString('favorite_cities');

  if (encodedFavoriteCities == null) {
    return [];
  }

  return City.decode(encodedFavoriteCities);
}

saveFavoriteCities(List<City> cities) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('favorite_cities', City.encode(cities));
}
