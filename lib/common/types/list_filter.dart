import 'package:clock_app/common/types/list_item.dart';

abstract class ListFilterItem<Item> {
  bool Function(Item) get filterFunction;
}

class ListFilter<Item extends ListItem> {
  final String name;
  final bool Function(Item) filterFunction;

  const ListFilter(this.name, this.filterFunction);
}

class ListFilterSearch<Item extends ListItem> extends ListFilterItem<Item> {
  final String name;
  String searchText = '';
  @override
  bool Function(Item) get filterFunction {
    // if (searchText.isEmpty) {
      return (Item item) => true;
    // }
    // return (Item item) => item.searchText.contains(searchText);
  }
  ListFilterSearch(this.name);
}

class ListFilterMultiSelect<Item extends ListItem> extends ListFilterItem<Item> {
  final String name;
  final List<ListFilter<Item>> filters;
  List<int> selectedFilterIndices = [];
  ListFilterMultiSelect(this.name, this.filters);
  @override
  bool Function(Item) get filterFunction {
    if (selectedFilterIndices.isEmpty) {
      return (Item item) => true;
    }
    return (Item item) => selectedFilterIndices.any((index) =>
        filters[index].filterFunction(item));
  }
}

class ListFilterSelect<Item extends ListItem> extends ListFilterItem<Item> {
  final String name;
  final List<ListFilter<Item>> filters;
  int selectedFilterIndex = 0;
  ListFilterSelect(this.name, this.filters);

  @override
  bool Function(Item) get filterFunction =>
      filters[selectedFilterIndex].filterFunction;
}
