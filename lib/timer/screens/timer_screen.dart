import 'package:clock_app/common/widgets/fab.dart';
import 'package:flutter/material.dart';

class TimerTab extends StatefulWidget {
  const TimerTab({Key? key}) : super(key: key);

  @override
  _TimerTabState createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab> {
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
