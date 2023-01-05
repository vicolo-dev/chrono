class City {
  final String name;
  final String country;
  final String timezone;

  City(this.name, this.country, this.timezone);

  City.fromMap(Map<dynamic, dynamic> map)
      : name = map['City'],
        country = map['Country'],
        timezone = map['Timezone'];
}
