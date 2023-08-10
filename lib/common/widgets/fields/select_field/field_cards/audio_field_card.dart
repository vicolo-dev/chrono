import 'package:clock_app/audio/types/audio.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';

class AudioFieldCard extends StatelessWidget {
  const AudioFieldCard({Key? key, required this.title, required this.choice})
      : super(key: key);

  final String title;
  final SelectChoice<Audio> choice;

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
              choice.value.title,
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
