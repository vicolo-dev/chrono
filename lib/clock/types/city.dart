import 'package:clock_app/common/utils/json_serialize.dart';

class City extends JsonSerializable {
  final String name;
  final String country;
  final String timezone;

  String get id => "$name,$country";

  const City(this.name, this.country, this.timezone);

  factory City.fromJson(Map<String, dynamic> jsonData) {
    return City(
      jsonData['name'],
      jsonData['country'],
      jsonData['timezone'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'timezone': timezone,
      };
}
