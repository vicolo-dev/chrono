import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/debug.dart';
import 'package:flutter/material.dart';

class ListSortOption<Item extends ListItem> {
  final String name;
  final String abbreviation;
  final int Function(Item, Item) sortFunction;

  ListSortOption(this.name, this.abbreviation, this.sortFunction);
}

abstract class ListFilterItem<Item extends ListItem> {
  bool Function(Item) get filterFunction;
  String get displayName;
  bool get isActive;
  void reset();
}

ListFilter<Item> defaultFilter<Item extends ListItem>() {
  return ListFilter<Item>(
    'All',
    (item) => true,
    id: -1,
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

  int get id => _id;

  @override
  bool Function(Item) get filterFunction {
    // print("Filtering $name $isSelected");
    return isSelected ? _filterFunction : (Item item) => true;
  }

  @override
  String get displayName => name;

  @override
  bool get isActive => isSelected;

  @override
  void reset() {
    isSelected = false;
  }
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
  @override
  String get displayName => name;

  @override
  bool get isActive => false;

  @override
  void reset() {}
}

abstract class FilterMultiSelect<Item extends ListItem>
    extends ListFilterItem<Item> {
  List<int> get selectedIndices;
  List<ListFilter<Item>> get selectedFilters;
  List<ListFilter<Item>> get filters;
  set selectedIndices(List<int> indices);
  @override
  bool Function(Item) get filterFunction {
    final currentFilters = filters;

    if (!currentFilters.any((filter) => filter.isSelected)) {
      return (Item item) => true;
    }
    return (Item item) => currentFilters
        .where((filter) => filter.isSelected)
        .any((filter) => filter.filterFunction(item));
  }
}

class ListFilterMultiSelect<Item extends ListItem>
    extends FilterMultiSelect<Item> {
  final String name;
  @override
  final List<ListFilter<Item>> filters;
  ListFilterMultiSelect(this.name, this.filters);

  @override
  List<int> get selectedIndices => filters
      .where((filter) => filter.isSelected)
      .map((filter) => filters.indexOf(filter))
      .toList();

  @override
  List<ListFilter<Item>> get selectedFilters =>
      filters.where((filter) => filter.isSelected).toList();

  @override
  set selectedIndices(List<int> indices) {
    for (int i = 0; i < filters.length; i++) {
      filters[i].isSelected = indices.contains(i);
    }
  }

  @override
  String get displayName => name;

  @override
  bool get isActive => filters.any((filter) => filter.isSelected);

  @override
  void reset() {
    for (var filter in filters) {
      filter.isSelected = false;
    }
  }
}

class DynamicListFilterMultiSelect<Item extends ListItem>
    extends FilterMultiSelect<Item> {
  final String name;
  final List<ListFilter<Item>> Function() getFilters;
  List<int> selectedIds;
  DynamicListFilterMultiSelect(this.name, this.getFilters) : selectedIds = [];
  @override
  @override
  String get displayName => name;

  @override
  List<ListFilter<Item>> get selectedFilters =>
      filters.where((filter) => selectedIds.contains(filter.id)).toList();

  @override
  List<int> get selectedIndices {
    final currentFilters = filters;
    return currentFilters
        .where((filter) => filter.isSelected)
        .map((filter) => currentFilters.indexOf(filter))
        .toList();
  }

  @override
  set selectedIndices(List<int> indices) {
    final currentFilters = filters;
    selectedIds = indices.map((index) => currentFilters[index].id).toList();
  }

  @override
  List<ListFilter<Item>> get filters {
    final currentFilters = getFilters();
    for (var filter in currentFilters) {
      filter.isSelected = selectedIds.contains(filter.id);
    }
    return currentFilters;
  }

  @override
  bool get isActive => selectedIds.isNotEmpty;

  @override
  void reset() {
    selectedIndices = [];
  }
}

abstract class FilterSelect<Item extends ListItem>
    extends ListFilterItem<Item> {
  int get selectedIndex;
  set selectedIndex(int index);
  ListFilter<Item> get selectedFilter;
  List<ListFilter<Item>> get filters;
  @override
  bool Function(Item) get filterFunction {
    try {
      return selectedFilter.filterFunction;
    } catch (e) {
      printDebug("Error in getting filter function($displayName): $e");
      return (Item item) => true;
    }
  }
}

class ListFilterSelect<Item extends ListItem> extends FilterSelect<Item> {
  final String name;
  @override
  final List<ListFilter<Item>> filters;
  ListFilterSelect(this.name, this.filters) {
    filters.insert(0, defaultFilter<Item>());
    if (filters.isNotEmpty) {
      filters[0].isSelected = true;
    }
  }

  @override
  int get selectedIndex {
    return filters.indexWhere((filter) => filter.isSelected);
  }

  @override
  ListFilter<Item> get selectedFilter {
    return filters.firstWhere((filter) => filter.isSelected);
  }

  @override
  set selectedIndex(int index) {
    for (int i = 0; i < filters.length; i++) {
      filters[i].isSelected = i == index;
    }
  }

  @override
  String get displayName => name;

  @override
  bool get isActive => !filters[0].isSelected;

  @override
  void reset() {
    selectedIndex = 0;
  }
}

class DynamicListFilterSelect<Item extends ListItem>
    extends FilterSelect<Item> {
  final String name;
  final List<ListFilter<Item>> Function() getFilters;
  int selectedId;
  DynamicListFilterSelect(this.name, this.getFilters) : selectedId = -1;

  @override
  List<ListFilter<Item>> get filters {
    final filters = getFilters();
    filters.insert(0, defaultFilter<Item>());

    for (var filter in filters) {
      filter.isSelected = filter.id == selectedId;
    }

    return filters;
  }

  @override
  int get selectedIndex {
    final currentFilters = filters;
    if (!currentFilters.any((filter) => filter.id == selectedId)) {
      selectedIndex = 0;
    }
    final index =
        currentFilters.indexWhere((filter) => filter.id == selectedId);
    return index == -1 ? 0 : index;
  }

  @override
  ListFilter<Item> get selectedFilter {
    return filters.firstWhere((filter) => filter.id == selectedId, orElse: () {
      return filters[0];
    });
  }

  @override
  set selectedIndex(int index) {
    selectedId = filters[index].id;
  }

  @override
  String get displayName => name;

  @override
  bool get isActive => selectedIndex != 0;

  @override
  void reset() {
    selectedIndex = 0;
  }
}

class ListFilterAction<Item extends ListItem> {
  final String name;
  final IconData icon;
  final Color? color;
  final Function() action;

  ListFilterAction(
      {this.color,
      required this.name,
      required this.icon,
      required this.action});
}

class ListFilterCustomAction<Item extends ListItem> {
  final String name;
  final IconData icon;
  final Color? color;
  final Function(List<Item>) action;

  ListFilterCustomAction(
      {this.color,
      required this.name,
      required this.icon,
      required this.action});
}
