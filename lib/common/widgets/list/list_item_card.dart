import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/action_pane.dart';
import 'package:clock_app/common/widgets/list/animated_reorderable_list/component/drag_listener.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    this.isSelected = false,
    this.showReorderHandle = false,
    required this.index,
    this.onLongPress,
  });

  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final VoidCallback? onInit;
  final bool isDeleteEnabled;
  final bool isDuplicateEnabled;
  final bool isSelected;
  final bool showReorderHandle;
  final int index;

  @override
  State<StatefulWidget> createState() => _ListItemCardState<T>();
}

class _ListItemCardState<T> extends State<ListItemCard<T>> {
  late Setting swipeActionSetting;
  late Setting longPressActionSetting;

  void update(dynamic value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
    final interactionSettingsGroup =
        appSettings.getGroup("General").getGroup("Interactions");
    swipeActionSetting = interactionSettingsGroup.getSetting("Swipe Action");
    longPressActionSetting =
        interactionSettingsGroup.getSetting("Long Press Action");
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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    if ((widget.isDeleteEnabled || widget.isDuplicateEnabled) &&
        swipeActionSetting.value == SwipeAction.cardActions) {
      ActionPane startActionPane = widget.isDuplicateEnabled
          ? getDuplicateActionPane(widget.onDuplicate ?? () {}, context)
          : getDeleteActionPane(widget.onDelete ?? () {}, context);
      ActionPane endActionPane = widget.isDeleteEnabled
          ? getDeleteActionPane(widget.onDelete ?? () {}, context)
          : getDuplicateActionPane(widget.onDuplicate ?? () {}, context);
      innerWidget = Slidable(
        enabled: !widget.showReorderHandle,
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
        onLongPress: widget.onLongPress,
        isSelected: widget.isSelected,
        child: Row(
          children: [
            AnimatedContainer(
              duration: 150.ms,
              width: widget.showReorderHandle ? 28 : 0,
              color: Colors.transparent,
              // decoration: const BoxDecoration(),
              clipBehavior: Clip.hardEdge,
              child: ReorderableGridDragStartListener(
                  key: widget.key,
                  index: widget.index,
                  enabled: true,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 16.0, bottom: 16.0),
                      child: Icon(Icons.drag_indicator,
                          color: colorScheme.onSurface.withOpacity(0.6)))),
            ),
            Expanded(child: innerWidget),
          ],
        ),
      ),
    );
  }
}
