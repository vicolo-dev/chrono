import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/settings/types/setting.dart';

List<SelectSettingOption<Tag>> getTagOptions() {
  return loadListSync<Tag>("tags")
      .map((tag) => SelectSettingOption<Tag>(tag.name, tag))
      .toList();
}
