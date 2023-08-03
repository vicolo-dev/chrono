import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/settings/types/setting_group.dart';

abstract class ListItem extends JsonSerializable {
  int get id;
  bool get isDeletable;

  dynamic copy();
}

abstract class CustomizableListItem extends ListItem {
  SettingGroup get settings;
}
