import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/types/setting.dart';

List<SelectSettingOption<FileItem>> getRingtoneOptions() {
  return loadListSync<FileItem>("ringtones")
      .map((ringtone) => SelectSettingOption<FileItem>(ringtone.name, ringtone))
      .toList();
}
