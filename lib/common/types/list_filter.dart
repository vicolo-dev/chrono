import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/foundation.dart';

abstract class ListFilterItem<Item> {
  bool Function(Item) get filterFunction;
}

ListFilter<Item> defaultFilter<Item extends ListItem>() {
  return ListFilter<Item>(
    'All',
    (item) => true,
  );
}

class ListFilter<Item extends ListItem> extends ListFilterItem<Item> {
  final int _id;
  final String name;
  bool isSelected = false;
  final bool Function(Item) _filterFunction;

  ListFilter(this.name, bool Function(Item) filterFunction, {int? id})
      : _id = id ?? UniqueKey().hashCode,
        _filterFunction = filterFunction;

  void setSelected(bool selected) {
    isSelected = selected;
  }

  int get id => _id;

  @override
  bool Function(Item) get filterFunction =>
      isSelected ? _filterFunction : (Item item) => true;
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

class ListFilterMultiSelect<Item extends ListItem>
    extends ListFilterItem<Item> {
  final String name;
  final List<ListFilter<Item>> filters;
  ListFilterMultiSelect(this.name, this.filters) {
    // filters.insert(0, defaultFilter<Item>());
    // if (filters.isNotEmpty) {
    //   filters[0].setSelected(true);
    // }
  }
  @override
  bool Function(Item) get filterFunction {
    if (!filters.any((filter) => filter.isSelected)) {
      return (Item item) => true;
    }
    return (Item item) => filters.any((filter) => filter.filterFunction(item));
  }
}

class DynamicListFilterMultiSelect<Item extends ListItem>
    extends ListFilterItem<Item> {
  final String name;
  final List<ListFilter<Item>> Function() getfilters;
  DynamicListFilterMultiSelect(this.name, this.getfilters);
  @override
  bool Function(Item) get filterFunction {
    final filters = getfilters();
    if (!filters.any((filter) => filter.isSelected)) {
      return (Item item) => true;
    }
    return (Item item) => filters.any((filter) => filter.filterFunction(item));
  }
}

class ListFilterSelect<Item extends ListItem> extends ListFilterItem<Item> {
  final String name;
  final List<ListFilter<Item>> filters;
  ListFilterSelect(this.name, this.filters) {
    filters.insert(0, defaultFilter<Item>());
    if (filters.isNotEmpty) {
      filters[0].setSelected(true);
    }
  }

  int get selectedFilterIndex {
    return filters.indexWhere((filter) => filter.isSelected);
  }

  // String get name => selectedFilterIndex == 0 ? _name : selectedFilter.name;
  // String get groupName => _name;

  ListFilter get selectedFilter {
    return filters.firstWhere((filter) => filter.isSelected);
  }

  set selectedFilterIndex(int index) {
    for (int i = 0; i < filters.length; i++) {
      filters[i].setSelected(i == index);
    }
  }

  @override
  bool Function(Item) get filterFunction {
    try {
      return filters.firstWhere((filter) => filter.isSelected).filterFunction;
    } catch (e) {
      return (Item item) => true;
    }
  }
}

class DynamicListFilterSelect<Item extends ListItem>
    extends ListFilterItem<Item> {
  final String name;
  final List<ListFilter<Item>> Function() getfilters;
  DynamicListFilterSelect(this.name, this.getfilters);
  @override
  bool Function(Item) get filterFunction {
    final filters = getfilters();
    try {
      return filters.firstWhere((filter) => filter.isSelected).filterFunction;
    } catch (e) {
      return (Item item) => true;
    }
  }
}
