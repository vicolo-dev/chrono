import 'package:clock_app/common/widgets/fab.dart';
import 'package:flutter/material.dart';

class AlarmTab extends StatefulWidget {
  const AlarmTab({Key? key}) : super(key: key);

  @override
  _AlarmTabState createState() => _AlarmTabState();
}

class _AlarmTabState extends State<AlarmTab> {
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
