import 'package:clock_app/common/widgets/fab.dart';
import 'package:flutter/material.dart';

class StopwatchTab extends StatefulWidget {
  const StopwatchTab({Key? key}) : super(key: key);

  @override
  State<StopwatchTab> createState() => _StopwatchTabState();
}

class _StopwatchTabState extends State<StopwatchTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: const []),
      FAB(
        onPressed: () {},
      )
    ]);
  }
}
