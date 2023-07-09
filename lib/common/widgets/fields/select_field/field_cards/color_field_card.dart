import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';

class ColorFieldCard extends StatelessWidget {
  const ColorFieldCard({Key? key, required this.title, required this.choice})
      : super(key: key);

  final String title;
  final SelectChoice<Color> choice;

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
          ],
        ),
        const Spacer(),
        Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: choice.value,
            borderRadius:
                (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                    .borderRadius,
          ),
        )
      ],
    );
  }
}
