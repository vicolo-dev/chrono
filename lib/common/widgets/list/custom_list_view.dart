import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/list/animated_reorderable_list/animated_reorderable_listview.dart';
import 'package:clock_app/common/widgets/list/animated_reorderable_list/animation/fade_in.dart';
import 'package:clock_app/common/widgets/list/delete_alert_dialogue.dart';
import 'package:clock_app/common/widgets/list/list_filter_bar.dart';
import 'package:clock_app/common/widgets/list/list_item_card.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    this.isSelectable = false,
    this.listFilters = const [],
    this.customActions = const [],
    this.sortOptions = const [],
    this.initialSortIndex = 0,
    this.onChangeSortIndex,
    this.header,
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
  final Widget? header;
  final bool isSelectable;

  @override
  State<CustomListView> createState() => _CustomListViewState<Item>();
}

class _CustomListViewState<Item extends ListItem>
    extends State<CustomListView<Item>> {
  late List<Item> currentList = List.from(widget.items);
  final _scrollController = ScrollController();
  // final _controller = AnimatedListController();
  late int _selectedSortIndex = widget.initialSortIndex;
  late Setting _longPressActionSetting;
  List<int> _selectedIds = [];
  bool _isSelecting = false;
  // bool _isReordering = false;

  @override
  void initState() {
    super.initState();

    _longPressActionSetting = appSettings
        .getGroup("General")
        .getGroup("Interactions")
        .getSetting("Long Press Action");

    _longPressActionSetting.addListener(_handleUpdateSettings);

    widget.listController.setChangeItems(_handleChangeItems);
    widget.listController.setAddItem(_handleAddItem);
    widget.listController.setDeleteItem(_handleDeleteItem);
    widget.listController.setGetItemIndex(_getItemIndex);
    widget.listController.setDuplicateItem(_handleDuplicateItem);
    widget.listController.setReloadItems(_handleReloadItems);
    widget.listController.setClearItems(_handleClearItems);
    widget.listController.setGetItems(() => widget.items);
    _updateCurrentList();
    // widget.listController.setChangeItemWithId(_handleChangeItemWithId);
  }

  @override
  void dispose() {
    _longPressActionSetting.removeListener(_handleUpdateSettings);
    super.dispose();
  }

  void _handleUpdateSettings(dynamic value) {
    _endSelection();
  }

  void _handleReloadItems(List<Item> items) {
    setState(() {
      widget.items.clear();
      widget.items.addAll(items);

      _updateCurrentList();
    });
  }

  void _updateCurrentList() {
    if (_selectedSortIndex > widget.sortOptions.length) {
      _selectedSortIndex = 0;
    }
    currentList.clear();
    if (_selectedSortIndex != 0) {
      final temp = [...widget.items];
      temp.sort(widget.sortOptions[_selectedSortIndex - 1].sortFunction);
      currentList.addAll(temp);
    } else {
      currentList.addAll(widget.items);
    }
  }

  int _getItemIndex(Item item) =>
      currentList.indexWhere((element) => element.id == item.id);

  // void _updateItemHeight() {
  //   if (_itemCardHeight == 0) {
  //     // _itemCardHeight = _controller.computeItemBox(0)?.height ?? 0;
  //   }
  // }

  bool _handleReorderItems(int oldIndex, int newIndex) {
    if (newIndex >= widget.items.length || _selectedSortIndex != 0) {
      return false;
    }
    widget.onReorderItem?.call(widget.items[oldIndex]);
    widget.items.insert(newIndex, widget.items.removeAt(oldIndex));
    _updateCurrentList();
    widget.onModifyList?.call();

    return true;
  }

  void _handleChangeItems(
      ItemChangerCallback<Item> callback, bool callOnModifyList) {
    callback(widget.items);

    setState(() {
      _updateCurrentList();
    });

    if (callOnModifyList) widget.onModifyList?.call();
  }

  Future<void> _handleDeleteItem(Item deletedItem,
      [bool callOnModifyList = true]) async {
    widget.items.removeWhere((element) => element.id == deletedItem.id);
    setState(() {
      _updateCurrentList();
    });

    await widget.onDeleteItem?.call(deletedItem);
    if (callOnModifyList) widget.onModifyList?.call();
  }

  Future<void> _handleDeleteItemList(List<Item> deletedItems) async {
    for (var item in deletedItems) {
      widget.items.removeWhere((element) => element.id == item.id);
    }
    setState(() {
      _updateCurrentList();
    });

    for (var item in deletedItems) {
      await widget.onDeleteItem?.call(item);
    }

    widget.onModifyList?.call();
  }

  void _handleClearItems() async {
    await _handleDeleteItemList(List<Item>.from(widget.items));
  }

  Future<void> _handleAddItem(Item item, {int index = -1}) async {
    if (index == -1) {
      index = widget.shouldInsertOnTop ? 0 : widget.items.length;
    }
    widget.items.insert(index, item);
    await widget.onAddItem?.call(item);
    setState(() {
      _updateCurrentList();
    });

    int currentListIndex = _getItemIndex(item);
    _scrollToIndex(currentListIndex);
    // _updateItemHeight();
    widget.onModifyList?.call();
  }

  void _handleDuplicateItem(Item item) {
    _handleAddItem(item.copy(), index: _getItemIndex(item) + 1);
  }

  void _scrollToIndex(int index) {
    if (index != 0) return;
    _scrollController.animateTo(index.toDouble(),
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  void _endSelection() {
    setState(() {
      _isSelecting = false;
      // _isReordering = false;
      _selectedIds.clear();
    });
  }

  void _startSelection(Item item) {
    setState(() {
      _isSelecting = true;
      _selectedIds = [item.id];
    });
  }

  void _handleSelect(Item item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else {
        _selectedIds.add(item.id);
      }
    });
    if (_selectedIds.isEmpty) {
      _endSelection();
    }
  }

  void _handleSortChange(int index) {
    setState(() {
      _selectedSortIndex = index;
      widget.onChangeSortIndex?.call(index);
      _updateCurrentList();
    });
  }

  void _handleFilterChange() {
    setState(() {});
  }

  void _handleSelectAll() {
    setState(() {
      _selectedIds = widget.items.map((e) => e.id).toList();
    });
  }

  void _handleCustomAction(ListFilterCustomAction<Item> action) {
    final items = _getActionableItems();
    action.action(items);
    _endSelection();
  }

  void _handleDeleteAction() async {
    Navigator.pop(context);
    final result = await showDeleteAlertDialogue(context);
    if (result == null || result == false) return;

    final list = _getActionableItems();
    final itemsToRemove =
        List<Item>.from(list.where((item) => item.isDeletable));
    _endSelection();
    await _handleDeleteItemList(itemsToRemove);
  }

  List<Item> _getActionableItems() {
    return _isSelecting
        ? widget.items.where((item) => _selectedIds.contains(item.id)).toList()
        : widget.items
            .where((item) => widget.listFilters
                .every((filter) => filter.filterFunction(item)))
            .toList();
  }

  _getItemBuilder() {
    return (BuildContext context, int index) {
      Item item = currentList[index];
      for (var filter in widget.listFilters) {
        if (!filter.filterFunction(item)) {
          return Container(key: ValueKey(item));
        }
      }
      Widget itemWidget = ListItemCard<Item>(
        key: ValueKey(item.id),
        onTap: () {
          if (_isSelecting) {
            _handleSelect(item);
          } else {
            return widget.onTapItem?.call(item, index);
          }
        },
        onLongPress: () {
          if (widget.isSelectable &&
              _longPressActionSetting.value == LongPressAction.multiSelect) {
            if (!_isSelecting) {
              _startSelection(item);
            } else {
              _handleSelect(item);
            }
          }
        },
        onDelete: widget.isDeleteEnabled ? () => _handleDeleteItem(item) : null,
        onDuplicate: () => _handleDuplicateItem(item),
        isDeleteEnabled: item.isDeletable && widget.isDeleteEnabled,
        isDuplicateEnabled: widget.isDuplicateEnabled,
        isSelected: _selectedIds.contains(item.id),
        showReorderHandle:
            _isSelecting && widget.isReorderable && _selectedSortIndex == 0,
        index: index,
        child: widget.itemBuilder(item),
      );
      return itemWidget;
    };
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    if (_selectedSortIndex > widget.sortOptions.length) {
      _updateCurrentList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListFilterBar(
          listFilters: widget.listFilters,
          customActions: widget.customActions,
          sortOptions: widget.sortOptions,
          isSelecting: _isSelecting,
          handleCustomAction: _handleCustomAction,
          handleEndSelection: _endSelection,
          handleDeleteAction: _handleDeleteAction,
          handleSelectAll: _handleSelectAll,
          selectedIds: _selectedIds,
          handleFilterChange: _handleFilterChange,
          selectedSortIndex: _selectedSortIndex,
          handleSortChange: _handleSortChange,
          isDeleteEnabled: widget.isDeleteEnabled,
        ),
        if (widget.header != null) widget.header!,
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
                        style: textTheme.displaySmall?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SlidableAutoCloseBehavior(
              child: AnimatedReorderableListView(
                longPressDraggable: false,
                buildDefaultDragHandles: false,
                proxyDecorator: (widget, index, animation) =>
                    reorderableListDecorator(context, widget),
                items: currentList,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                isSameItem: (a, b) => a.id == b.id,
                scrollDirection: Axis.vertical,
                itemBuilder: _getItemBuilder(),
                enterTransition: [FadeIn()],
                exitTransition: [FadeIn()],
                controller: _scrollController,
                insertDuration: const Duration(milliseconds: 300),
                removeDuration: const Duration(milliseconds: 300),
                onReorder: _handleReorderItems,
              ),
            )
          ]),
        ),
      ],
    );
  }
}
