import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';

class TextFieldCard extends StatelessWidget {
  const TextFieldCard({Key? key, required this.title, required this.choice})
      : super(key: key);

  final String title;
  final SelectChoice choice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4.0),
            Text(
              choice.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const Spacer(),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
        )
      ],
    );
  }
}
