import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/custom_list_view.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:flutter/material.dart';

class PersistentListView<Item extends ListItem> extends StatefulWidget {
  const PersistentListView({
    super.key,
    required this.itemBuilder,
    required this.saveTag,
    required this.listController,
    this.duplicateItem,
    this.onTapItem,
    this.onReorderItem,
    this.onDeleteItem,
    this.onAddItem,
    this.placeholderText = '',
    this.isReorderable = true,
    this.isDeleteEnabled = true,
    this.isDuplicateEnabled = true,
    this.reloadOnPop = false,
  });

  final Widget Function(Item item) itemBuilder;
  final Item Function(Item item)? duplicateItem;
  final void Function(Item item, int index)? onTapItem;
  final void Function(Item item)? onReorderItem;
  final void Function(Item item)? onDeleteItem;
  final void Function(Item item)? onAddItem;
  final String saveTag;
  final String placeholderText;
  final ListController<Item> listController;
  final bool isReorderable;
  final bool isDeleteEnabled;
  final bool isDuplicateEnabled;
  final bool reloadOnPop;

  @override
  State<PersistentListView> createState() => _PersistentListViewState<Item>();
}

class _PersistentListViewState<Item extends ListItem>
    extends State<PersistentListView<Item>> with RouteAware {
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    if (widget.saveTag.isNotEmpty) {
      _items = loadList<Item>(widget.saveTag);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (widget.reloadOnPop) {
      loadItems();
    }
  }

  void loadItems() {
    if (widget.saveTag.isNotEmpty) {
      widget.listController.changeItems((List<Item> items) {
        items = loadList<Item>(widget.saveTag);
      }, callOnModifyList: false);
    }
  }

  void saveItems() {
    if (widget.saveTag.isNotEmpty) {
      saveList<Item>(widget.saveTag, _items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomListView<Item>(
      items: _items,
      itemBuilder: widget.itemBuilder,
      duplicateItem: widget.duplicateItem,
      onTapItem: widget.onTapItem,
      onReorderItem: widget.onReorderItem,
      onDeleteItem: widget.onDeleteItem,
      onAddItem: widget.onAddItem,
      listController: widget.listController,
      placeholderText: widget.placeholderText,
      onModifyList: saveItems,
      isReorderable: widget.isReorderable,
      isDeleteEnabled: widget.isDeleteEnabled,
      isDuplicateEnabled: widget.isDuplicateEnabled,
    );
  }
}
