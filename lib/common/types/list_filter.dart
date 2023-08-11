import 'package:clock_app/common/types/list_item.dart';

class ListFilter<Item extends ListItem> {
  final String name;
  final bool Function(Item) filterFunction;

  const ListFilter(this.name, this.filterFunction);
}
