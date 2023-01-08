import 'dart:convert';

class City {
  final String name;
  final String country;
  final String timezone;

  const City(this.name, this.country, this.timezone);

  factory City.fromJson(Map<String, dynamic> jsonData) {
    return City(
      jsonData['name'],
      jsonData['country'],
      jsonData['timezone'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'country': country,
        'timezone': timezone,
      };

  static String encode(List<City> cities) => json.encode(
        cities.map<Map<String, dynamic>>((city) => city.toMap()).toList(),
      );

  static List<City> decode(String cities) =>
      (json.decode(cities) as List<dynamic>)
          .map<City>((item) => City.fromJson(item))
          .toList();
}
