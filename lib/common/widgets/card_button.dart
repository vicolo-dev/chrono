import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardContainer(
        child: Padding(
      padding: EdgeInsets.all(8.0),
    ));
  }
}
