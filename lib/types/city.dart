import 'dart:convert';

class City {
  final String name;
  final String country;
  final String timezone;

  City(this.name, this.country, this.timezone);

  factory City.fromJson(Map<String, dynamic> jsonData) {
    return City(
      jsonData['name'],
      jsonData['country'],
      jsonData['timezone'],
    );
  }

  static Map<String, dynamic> toMap(City city) => {
        'name': city.name,
        'country': city.country,
        'timezone': city.timezone,
      };

  City.fromMap(Map<dynamic, dynamic> map)
      : name = map['name'],
        country = map['country'],
        timezone = map['timezone'];

  static String encode(List<City> cities) => json.encode(
        cities.map<Map<String, dynamic>>((city) => City.toMap(city)).toList(),
      );

  static List<City> decode(String cities) =>
      (json.decode(cities) as List<dynamic>)
          .map<City>((item) => City.fromJson(item))
          .toList();
}
