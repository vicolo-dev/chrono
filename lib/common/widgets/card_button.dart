import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
    ));
  }
}
