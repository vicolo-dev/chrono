 import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/widgets/list/list_filter_chip.dart';
import 'package:flutter/material.dart';

Widget getListFilterChip<Item extends ListItem>(ListFilterItem<Item> item, VoidCallback onFilterChange){
    if (item.runtimeType == ListFilter<Item>) {
      return ListFilterChip<Item>(
        listFilter: item as ListFilter<Item>,
        onChange: onFilterChange,
      );
    } else if (item.runtimeType == ListFilterSelect<Item>) {
      return ListFilterSelectChip<Item>(
        listFilter: item as ListFilterSelect<Item>,
        onChange: onFilterChange,
      );
    } else if (item.runtimeType == ListFilterMultiSelect<Item>) {
      return ListFilterMultiSelectChip<Item>(
        listFilter: item as ListFilterMultiSelect<Item>,
        onChange: onFilterChange,
      );
    } else if (item.runtimeType == DynamicListFilterSelect<Item>) {
      return ListFilterSelectChip<Item>(
        listFilter: item as DynamicListFilterSelect<Item>,
        onChange: onFilterChange,
      );
    } else if (item.runtimeType == DynamicListFilterMultiSelect<Item>) {
      return ListFilterMultiSelectChip<Item>(
        listFilter: item as DynamicListFilterMultiSelect<Item>,
        onChange: onFilterChange,
      );
    } else {
      return const Text("Unknown Filter Type");
    }
  }

