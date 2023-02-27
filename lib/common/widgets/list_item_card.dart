import 'package:clock_app/common/widgets/card.dart';
import 'package:clock_app/common/widgets/delete_action_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemCard<T> extends StatefulWidget {
  const ListItemCard({
    Key? key,
    required this.child,
    this.onDelete,
    this.onTap,
    this.onDuplicate,
    this.onInit,
    this.isDeleteEnabled = true,
    this.isDuplicateEnabled = true,
  }) : super(key: key);

  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onTap;
  final Widget child;
  final VoidCallback? onInit;
  final bool isDeleteEnabled;
  final bool isDuplicateEnabled;

  @override
  State<StatefulWidget> createState() => _ListItemCardState<T>();
}

class _ListItemCardState<T> extends State<ListItemCard<T>> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
  }

  @override
  Widget build(BuildContext context) {
    Widget innerWidget = widget.child;

    if (widget.isDeleteEnabled || widget.isDuplicateEnabled) {
      ActionPane startActionPane = widget.isDuplicateEnabled
          ? getDuplicateActionPane(widget.onDuplicate ?? () {}, context)
          : getDeleteActionPane(widget.onDelete ?? () {}, context);
      ActionPane endActionPane = widget.isDeleteEnabled
          ? getDeleteActionPane(widget.onDelete ?? () {}, context)
          : getDuplicateActionPane(widget.onDuplicate ?? () {}, context);
      innerWidget = Slidable(
        groupTag: 'list',
        key: widget.key,
        startActionPane: startActionPane,
        endActionPane: endActionPane,
        child: widget.child,
      );
    }

    return SizedBox(
      width: double.infinity,
      child: CardContainer(
        child: InkWell(
          onTap: widget.onTap,
          child: innerWidget,
        ),
      ),
    );
  }
}
