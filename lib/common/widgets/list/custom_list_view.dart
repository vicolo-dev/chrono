import 'package:clock_app/common/logic/get_list_filter_chips.dart';
import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/list/delete_alert_dialogue.dart';
import 'package:clock_app/common/widgets/list/list_filter_chip.dart';
import 'package:clock_app/common/widgets/list/list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:great_list_view/great_list_view.dart';

typedef ItemCardBuilder = Widget Function(
  BuildContext context,
  int index,
  AnimatedWidgetBuilderData data,
);

class CustomListView<Item extends ListItem> extends StatefulWidget {
  const CustomListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.listController,
    this.onTapItem,
    this.onReorderItem,
    this.onDeleteItem,
    this.onAddItem,
    this.placeholderText = '',
    // Called whenever an item is added, deleted or reordered
    this.onModifyList,
    this.isReorderable = true,
    this.isDeleteEnabled = true,
    this.isDuplicateEnabled = true,
    this.shouldInsertOnTop = true,
    this.listFilters = const [],
    this.customActions = const [],
    this.sortOptions = const [],
    this.initialSortIndex = 0,
    this.onChangeSortIndex,
  });

  final List<Item> items;
  final Widget Function(Item item) itemBuilder;
  final void Function(Item item, int index)? onTapItem;
  final Function(Item item)? onReorderItem;
  final Function(Item item)? onDeleteItem;
  final Function(Item item)? onAddItem;
  // Called whenever an item is added, deleted or reordered
  final void Function()? onModifyList;
  final String placeholderText;
  final ListController<Item> listController;
  final bool isReorderable;
  final bool isDeleteEnabled;
  final bool isDuplicateEnabled;
  final int initialSortIndex;
  final bool shouldInsertOnTop;
  final List<ListFilterItem<Item>> listFilters;
  final List<ListFilterCustomAction<Item>> customActions;
  final List<ListSortOption<Item>> sortOptions;
  final Function(int index)? onChangeSortIndex;

  @override
  State<CustomListView> createState() => _CustomListViewState<Item>();
}

class _CustomListViewState<Item extends ListItem>
    extends State<CustomListView<Item>> {
  late List<Item> currentList = List.from(widget.items);
  double _itemCardHeight = 0;
  final _scrollController = ScrollController();
  final _controller = AnimatedListController();
  late int selectedSortIndex = widget.initialSortIndex;

  @override
  void initState() {
    super.initState();
    widget.listController.setChangeItems(_handleChangeItems);
    widget.listController.setAddItem(_handleAddItem);
    widget.listController.setDeleteItem(_handleDeleteItem);
    widget.listController.setGetItemIndex(_getItemIndex);
    widget.listController.setDuplicateItem(_handleDuplicateItem);
    widget.listController.setReloadItems(_handleReloadItems);
    widget.listController.setClearItems(_handleClear);
    widget.listController.setGetItems(() => widget.items);
    updateCurrentList();
    // widget.listController.setChangeItemWithId(_handleChangeItemWithId);
  }

  void _handleReloadItems(List<Item> items) {
    setState(() {
      widget.items.clear();
      widget.items.addAll(items);

      updateCurrentList();
    });
    // TODO: MAN THIS SUCKS, WHY YOU GOTTA DO THIS
    _controller.notifyRemovedRange(
        0, widget.items.length - 1, _getChangeListBuilder());
    _controller.notifyInsertedRange(0, widget.items.length);
  }

  void updateCurrentList() {
    if (selectedSortIndex > widget.sortOptions.length) {
      selectedSortIndex = 0;
    }
    currentList.clear();
    if (selectedSortIndex != 0) {
      final temp = [...widget.items];
      temp.sort(widget.sortOptions[selectedSortIndex - 1].sortFunction);
      currentList.addAll(temp);
    } else {
      currentList.addAll(widget.items);
    }
  }

  int _getItemIndex(Item item) =>
      currentList.indexWhere((element) => element.id == item.id);

  void _updateItemHeight() {
    if (_itemCardHeight == 0) {
      _itemCardHeight = _controller.computeItemBox(0)?.height ?? 0;
    }
  }

  void _notifyChangeList() {
    _controller.notifyChangedRange(
      0,
      currentList.length,
      _getChangeListBuilder(),
    );
  }

  ItemCardBuilder _getChangeWidgetBuilder(Item item) {
    _updateItemHeight();
    return (context, index, data) => data.measuring
        ? SizedBox(height: _itemCardHeight)
        : ListItemCard<Item>(
            key: ValueKey(item),
            onTap: () {},
            onDelete: () {},
            onDuplicate: () {},
            child: widget.itemBuilder(item),
          );
  }

  ItemCardBuilder _getChangeListBuilder() => (context, index, data) =>
      _getChangeWidgetBuilder(widget.items[index])(context, index, data);

  bool _handleReorderItems(int oldIndex, int newIndex, Object? slot) {
    if (newIndex >= widget.items.length || selectedSortIndex != 0) return false;
    widget.onReorderItem?.call(widget.items[oldIndex]);
    widget.items.insert(newIndex, widget.items.removeAt(oldIndex));
    updateCurrentList();
    widget.onModifyList?.call();

    return true;
  }

  void _handleChangeItems(
      ItemChangerCallback<Item> callback, bool callOnModifyList) {
    final initialList = List.from(currentList);

    callback(widget.items);

    setState(() {
      updateCurrentList();
    });

    final deletedItems = List.from(initialList
        .where((element) => currentList.where((e) => e.id == element.id).isEmpty)
        .toList());
    final addedItems = List.from(currentList
        .where((element) => initialList.where((e) => e.id == element.id).isEmpty)
        .toList());

    for (var deletedItem in deletedItems) {
      _controller.notifyRemovedRange(
        initialList.indexWhere((element) => element.id == deletedItem.id),
        1,
        _getChangeWidgetBuilder(deletedItem),
      );
    }

    print("--------- $addedItems");
    for (var addedItem in addedItems) {
      _controller.notifyInsertedRange(
        currentList.indexWhere((element) => element.id == addedItem.id),
        1,
      );
    }

    _notifyChangeList();

    if (callOnModifyList) widget.onModifyList?.call();
  }

  Future<void> _handleDeleteItem(Item deletedItem,
      [bool callOnModifyList = true]) async {
    int index = _getItemIndex(deletedItem);

    setState(() {
      widget.items.removeWhere((element) => element.id == deletedItem.id);
      updateCurrentList();
    });

    _controller.notifyRemovedRange(
      index,
      1,
      _getChangeWidgetBuilder(deletedItem),
    );
    await widget.onDeleteItem?.call(deletedItem);
    if (callOnModifyList) widget.onModifyList?.call();
  }

  Future<void> _handleDeleteItemList(List<Item> deletedItems) async {
    for (var item in deletedItems) {
      int index = _getItemIndex(item);

      setState(() {
        widget.items.removeWhere((element) => element.id == item.id);
        updateCurrentList();
      });

      _controller.notifyRemovedRange(
        index,
        1,
        _getChangeWidgetBuilder(deletedItems.first),
      );
    }
    for (var item in deletedItems) {
      await widget.onDeleteItem?.call(item);
    }

    widget.onModifyList?.call();
  }

  void _handleClear() {
    _handleDeleteItemList(List<Item>.from(widget.items));
  }

  Future<void> _handleAddItem(Item item, {int index = -1}) async {
    if (index == -1) {
      index = widget.shouldInsertOnTop ? 0 : widget.items.length;
    }
    widget.items.insert(index, item);
    await widget.onAddItem?.call(item);
    setState(() {
      updateCurrentList();
    });

    int currentListIndex = _getItemIndex(item);
    _controller.notifyInsertedRange(currentListIndex, 1);
    // _scrollToIndex(index);
    // TODO: Remove this delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToIndex(currentListIndex);
    });
    _updateItemHeight();
    widget.onModifyList?.call();
  }

  void _handleDuplicateItem(Item item) {
    _handleAddItem(item.copy(), index: _getItemIndex(item) + 1);
  }

  void _scrollToIndex(int index) {
    // if (_scrollController.offset == 0) {
    //   _scrollController.jumpTo(1);
    // }
    if (_itemCardHeight == 0 && index != 0) return;
    _scrollController.animateTo(index * _itemCardHeight,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  _getItemBuilder() {
    return (BuildContext context, Item item, data) {
      for (var filter in widget.listFilters) {
        // print("${filter.displayName} ${filter.filterFunction}");
        if (!filter.filterFunction(item)) {
          return Container();
        }
      }
      return data.measuring
          ? SizedBox(height: _itemCardHeight)
          : ListItemCard<Item>(
              key: ValueKey(item),
              onTap: () {
                return widget.onTapItem?.call(item, _getItemIndex(item));
              },
              onDelete:
                  widget.isDeleteEnabled ? () => _handleDeleteItem(item) : null,
              onDuplicate: () => _handleDuplicateItem(item),
              isDeleteEnabled: item.isDeletable && widget.isDeleteEnabled,
              isDuplicateEnabled: widget.isDuplicateEnabled,
              child: widget.itemBuilder(item),
            );
    };
  }

  void onFilterChange() {
    setState(() {
      _notifyChangeList();
    });
  }

  List<Item> getCurrentList() {
    final List<Item> items = List.from(widget.items);

    if (selectedSortIndex != 0) {
      items.sort(widget.sortOptions[selectedSortIndex - 1].sortFunction);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    if (selectedSortIndex > widget.sortOptions.length) {
      updateCurrentList();
    }

    List<Widget> getFilterChips() {
      List<Widget> widgets = [];
      int activeFilterCount =
          widget.listFilters.where((filter) => filter.isActive).length;
      if (activeFilterCount > 0) {
        widgets.add(ListFilterActionChip(
          actions: [
            ListFilterAction(
              name: "Clear all filters",
              icon: Icons.clear_rounded,
              action: () {
                for (var filter in widget.listFilters) {
                  filter.reset();
                }
                onFilterChange();
              },
            ),
            ...widget.customActions.map((action) => ListFilterAction(
                  name: action.name,
                  icon: action.icon,
                  action: () => action.action(widget.items
                      .where((item) => widget.listFilters
                          .every((filter) => filter.filterFunction(item)))
                      .toList()),
                )),
            ListFilterAction(
              name: "Delete all filtered items",
              icon: Icons.delete_rounded,
              color: colorScheme.error,
              action: () async {
                Navigator.pop(context);
                final result = await showDeleteAlertDialogue(context);
                if (result == null || result == false) return;

                final toRemove = List<Item>.from(widget.items.where((item) =>
                    widget.listFilters
                        .every((filter) => filter.filterFunction(item))));
                await _handleDeleteItemList(toRemove);

                widget.onModifyList?.call();
              },
            )
          ],
          activeFilterCount: activeFilterCount,
        ));
      }
      widgets.addAll(widget.listFilters
          .map((filter) => getListFilterChip(filter, onFilterChange)));
      if (widget.sortOptions.isNotEmpty) {
        widgets.add(
          ListSortChip(
            selectedIndex: selectedSortIndex,
            sortOptions: [
              ListSortOption("Default", "", (a, b) => 0),
              ...widget.sortOptions,
            ],
            onChange: (index) => setState(() {
              selectedSortIndex = index;
              widget.onChangeSortIndex?.call(index);
              updateCurrentList();
              _notifyChangeList();
            }),
          ),
        );
      }
      return widgets;
    }

    // timeDilation = 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: getFilterChips(),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Stack(children: [
            widget.items.isEmpty
                ? SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        widget.placeholderText,
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.6),
                                ),
                      ),
                    ),
                  )
                : Container(),
            SlidableAutoCloseBehavior(
              child: AutomaticAnimatedListView<Item>(
                list: currentList,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                comparator: AnimatedListDiffListComparator<Item>(
                  sameItem: (a, b) => a.id == b.id,
                  sameContent: (a, b) => a.id == b.id,
                ),
                itemBuilder: _getItemBuilder(),
                // animator: DefaultAnimatedListAnimator,
                listController: _controller,
                scrollController: _scrollController,
                addLongPressReorderable: widget.isReorderable,
                reorderModel: widget.isReorderable && selectedSortIndex == 0
                    ? AnimatedListReorderModel(
                        onReorderStart: (index, dx, dy) => true,
                        onReorderFeedback: (int index, int dropIndex,
                                double offset, double dx, double dy) =>
                            null,
                        onReorderMove: (int index, int dropIndex) => true,
                        onReorderComplete: _handleReorderItems,
                      )
                    : null,
                reorderDecorationBuilder:
                    widget.isReorderable ? reorderableListDecorator : null,
                footer: const SizedBox(height: 64 + 80),
                // cacheExtent: double.infinity,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
