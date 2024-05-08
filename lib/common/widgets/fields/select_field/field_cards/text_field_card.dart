import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';

class TextFieldCard extends StatelessWidget {
  const TextFieldCard({super.key, required this.title, required this.choice});

  final String title;
  final SelectChoice choice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
              const SizedBox(height: 4.0),
              Text(
                choice.name,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ],
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
        )
      ],
    );
  }
}
