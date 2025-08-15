import 'package:flutter/material.dart';

class AttachFiles extends StatelessWidget {
  const AttachFiles({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(description, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const Icon(Icons.attach_file),
          ],
        ),
      ),
    );
  }
}
