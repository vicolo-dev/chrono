import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

ActionPane getDeleteActionPane(VoidCallback onDelete, BuildContext context) =>
    ActionPane(
      motion: const ScrollMotion(),
      // extentRatio: Platform == 0.25,
      children: [
        CustomSlidableAction(
          onPressed: (context) => onDelete(),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete),
              Text('Delete',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
            ],
          ),
        ),
      ],
    );
ActionPane getDuplicateActionPane(
        VoidCallback onDuplicate, BuildContext context) =>
    ActionPane(
      motion: const ScrollMotion(),

      // extentRatio: Platform == 0.25,
      children: [
        CustomSlidableAction(
          onPressed: (context) => onDuplicate(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete),
              Text('Duplicate',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
            ],
          ),
        ),
      ],
    );
