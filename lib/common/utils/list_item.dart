import 'package:clock_app/common/types/list_item.dart';

List<T> copyItemList<T extends ListItem>(List<T> list) {
  return list.map((element) => element.copy() as T).toList();
}
