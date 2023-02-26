import 'package:flutter/material.dart';
import 'package:great_list_view/great_list_view.dart';

class ListItemMeasurer extends StatefulWidget {
  const ListItemMeasurer({
    super.key,
    required this.controller,
    required this.index,
  });

  final AnimatedListController controller;
  final int index;

  @override
  State<ListItemMeasurer> createState() => _ListItemMeasurerState();
}

class _ListItemMeasurerState extends State<ListItemMeasurer> {
  late double? height;

  @override
  void initState() {
    super.initState();
    height = widget.controller.computeItemBox(0, true)?.height;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
