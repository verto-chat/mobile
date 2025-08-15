import 'package:flutter/material.dart';

class AttachDocuments extends StatelessWidget {
  const AttachDocuments({super.key, required this.description});

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
                Text("Добавить документы", style: Theme.of(context).textTheme.titleMedium),
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
