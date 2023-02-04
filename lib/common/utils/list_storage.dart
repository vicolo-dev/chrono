import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/settings/types/settings_manager.dart';

List<T> loadList<T extends JsonSerializable>(String key) {
  final String? encodedList = SettingsManager.preferences?.getString(key);

  if (encodedList == null) {
    return [];
  }

  return decodeList<T>(encodedList);
}

Future<void> saveList<T extends JsonSerializable>(
    String key, List<T> list) async {
  // print('saved: ${encodeList(list)}');
  await SettingsManager.preferences?.setString(key, encodeList(list));
  // await SettingsManager.reload();
}
