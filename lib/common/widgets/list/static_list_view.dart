import 'package:flutter/material.dart';

class StaticListView extends StatelessWidget {
  const StaticListView({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ...children,
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
