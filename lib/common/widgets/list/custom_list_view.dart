import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/list/list_filter_chip.dart';
import 'package:clock_app/common/widgets/list/list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  });

  final List<Item> items;
  final Widget Function(Item item) itemBuilder;
  final void Function(Item item, int index)? onTapItem;
  final void Function(Item item)? onReorderItem;
  final void Function(Item item)? onDeleteItem;
  final void Function(Item item)? onAddItem;
  // Called whenever an item is added, deleted or reordered
  final void Function()? onModifyList;
  final String placeholderText;
  final ListController<Item> listController;
  final bool isReorderable;
  final bool isDeleteEnabled;
  final bool isDuplicateEnabled;
  final bool shouldInsertOnTop;
  final List<ListFilter<Item>> listFilters;

  @override
  State<CustomListView> createState() => _CustomListViewState<Item>();
}

class _CustomListViewState<Item extends ListItem>
    extends State<CustomListView<Item>> {
  double _itemCardHeight = 0;
  late int lastListLength = widget.items.length;
  final _scrollController = ScrollController();
  final _controller = AnimatedListController();
  late ListFilter<Item> _selectedFilter = widget.listFilters.isEmpty
      ? ListFilter("Default", (item) => true)
      : widget.listFilters[0];

  @override
  void initState() {
    super.initState();
    widget.listController.setChangeItems(_changeItems);
    widget.listController.setAddItem(_handleAddItem);
    widget.listController.setDeleteItem(_handleDeleteItem);
    widget.listController.setGetItemIndex(_getItemIndex);
    widget.listController.setDuplicateItem(_handleDuplicateItem);
  }

  int _getItemIndex(Item item) =>
      widget.items.indexWhere((element) => element.id == item.id);

  void _updateItemHeight() {
    if (_itemCardHeight == 0) {
      _itemCardHeight = _controller.computeItemBox(0)?.height ?? 0;
    }
  }

  void _changeItems(ItemChangerCallback<Item> callback, bool callOnModifyList) {
    setState(() {
      callback(widget.items);
    });
    _notifyChangeList();

    if (callOnModifyList) widget.onModifyList?.call();
  }

  void _notifyChangeList() {
    _controller.notifyChangedRange(
      0,
      widget.items.length,
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
    if (newIndex >= widget.items.length) return false;
    widget.onReorderItem?.call(widget.items[oldIndex]);
    widget.items.insert(newIndex, widget.items.removeAt(oldIndex));
    widget.onModifyList?.call();

    return true;
  }

  _handleDeleteItem(Item deletedItem) {
    widget.onDeleteItem?.call(deletedItem);
    int index = _getItemIndex(deletedItem);
    setState(() {
      widget.items.removeAt(index);
    });

    _controller.notifyRemovedRange(
      index,
      1,
      _getChangeWidgetBuilder(deletedItem),
    );
    widget.onModifyList?.call();
    lastListLength = widget.items.length;
  }

  void _handleAddItem(Item item, {int index = -1}) {
    if (index == -1) {
      index = widget.shouldInsertOnTop ? 0 : widget.items.length;
    }
    setState(() => widget.items.insert(index, item));
    widget.onAddItem?.call(item);
    _controller.notifyInsertedRange(index, 1);
    _scrollToIndex(index);
    Future.delayed(const Duration(milliseconds: 250), () {
      _scrollToIndex(index);
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
    _scrollController.animateTo(index * _itemCardHeight,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  _getItemBuilder(ListFilter<Item> filter) {
    return (BuildContext context, Item item, data) {
      if (!filter.filterFunction(item)) return Container();
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

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.75;
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widget.listFilters
                      .map((filter) => ListFilterChip<Item>(
                            listFilter: filter,
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _notifyChangeList();
                              });
                            },
                            isSelected: _selectedFilter == filter,
                          ))
                      .toList()),
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
                list: widget.items,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                comparator: AnimatedListDiffListComparator<Item>(
                  sameItem: (a, b) => a.id == b.id,
                  sameContent: (a, b) => a.id == b.id,
                ),
                itemBuilder: _getItemBuilder(widget.listFilters.isEmpty
                    ? ListFilter("Default", (item) => true)
                    : _selectedFilter),
                // animator: DefaultAnimatedListAnimator,
                listController: _controller,
                scrollController: _scrollController,
                addLongPressReorderable: widget.isReorderable,
                reorderModel: widget.isReorderable
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
