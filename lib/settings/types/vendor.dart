import 'package:clock_app/common/types/json.dart';

class Vendor {
  final String name;
  final String url;

  const Vendor({
    required this.name,
    required this.url,
  });

  Vendor.fromJson(Json json)
      : name = json['name'],
        url = json['url'] {}
}
