import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';

class AudioFieldCard extends StatelessWidget {
  const AudioFieldCard({super.key, required this.title, required this.choice});

  final String title;
  final SelectChoice<FileItem> choice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 999,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4.0),
              Text(
                choice.value.name,
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
