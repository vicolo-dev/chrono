import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/action_pane.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemCard<T> extends StatefulWidget {
  const ListItemCard({
    super.key,
    required this.child,
    this.onDelete,
    this.onTap,
    this.onDuplicate,
    this.onInit,
    this.isDeleteEnabled = true,
    this.isDuplicateEnabled = true,
  });

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
  late Setting swipeActionSetting;

  void update(dynamic value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
    swipeActionSetting =
        appSettings.getGroup("General").getSetting("Swipe Action");
    swipeActionSetting.addListener(update);
  }

  @override
  void dispose() {
    swipeActionSetting.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget innerWidget = widget.child;

    if ((widget.isDeleteEnabled || widget.isDuplicateEnabled) && swipeActionSetting.value == SwipeAction.cardActions) {
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
        onTap: widget.onTap,
        child: innerWidget,
      ),
    );
  }
}
