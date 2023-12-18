typedef Json = Map<String, dynamic>?;

abstract class JsonSerializable {
  const JsonSerializable();

  JsonSerializable.fromJson(Json json);
  Json toJson();
}
