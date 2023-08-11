import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';

class CustomizeState {
  bool isSaved = false;
  bool isChanged = false;
}

class CustomizeScreen<Item extends CustomizableListItem>
    extends StatefulWidget {
  const CustomizeScreen({
    super.key,
    required this.item,
    this.onSave,
    required this.builder,
    required this.isNewItem,
  });

  final Item item;
  final void Function(Item item)? onSave;
  final Widget Function(BuildContext context, Item item) builder;
  final bool isNewItem;

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState<Item>();
}

class _CustomizeScreenState<Item extends CustomizableListItem>
    extends State<CustomizeScreen<Item>> {
  late final Item _item = widget.item.copy();
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppTopBar(actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            onPressed: () {
              widget.onSave?.call(_item);
              _isSaved = true;
              Navigator.pop(context, _item);
            },
            child: const Text("Save"),
          ),
        )
      ]),
      body: WillPopScope(
        onWillPop: () async {
          if (_isSaved) return true;
          if (_item.hasSameSettingsAs(widget.item) && !widget.isNewItem) {
            return true;
          }
          bool? shouldPop = await showDialog<bool>(
            context: context,
            builder: (buildContext) {
              return AlertDialog(
                content: const Text("Do you want to leave without saving?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("No",
                        style: TextStyle(color: colorScheme.primary)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child:
                        Text("Yes", style: TextStyle(color: colorScheme.error)),
                  ),
                ],
              );
            },
          );
          return shouldPop ?? false;
        },
        child: widget.builder(context, _item),
      ),
    );
  }
}
