import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

List<T> loadList<T extends JsonSerializable>(String key) {
  final String? encodedFavoriteCities =
      SettingsManager.preferences?.getString(key);

  if (encodedFavoriteCities == null) {
    return [];
  }

  return decodeList(encodedFavoriteCities);
}

void saveList<T extends JsonSerializable>(String key, List<T> cities) {
  SettingsManager.preferences?.setString(key, encodeList(cities));
}
