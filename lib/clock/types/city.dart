import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/id.dart';

class City extends ListItem {
  late String _name = "Unknown";
  late String _country = "Unknown";
  late String _timezone = 'America/Detroit';
  late int _id;

  String get name => _name;
  String get country => _country;
  String get timezone => _timezone;

  @override
  int get id => _id;
  @override
  bool get isDeletable => true;

  City(this._name, this._country, this._timezone) : _id = getId();

  @override
  copy() {
    return City(name, country, timezone);
  }

  City.fromJson(Json json) {
    if (json == null) {
      _id = getId();
      return;
    }
    _name = json['name'] ?? 'Unknown';
    _country = json['country'] ?? 'Unknown';
    _timezone = json['timezone'] ?? 'America/Detroit';
    _id = json['id'] ?? getId();
  }

  @override
  Json toJson() => {
        'name': name,
        'country': country,
        'timezone': timezone,
        'id': id,
      };

  @override
  void copyFrom(other) {
        _name = other.name;
        _country = other.country;
        _timezone = other.timezone;
        _id = other.id;
  }
}
