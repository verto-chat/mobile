import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';

class AttachDocuments extends StatelessWidget {
  const AttachDocuments({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.core.widgets.attach_documents;
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
                Text(loc.title, style: Theme.of(context).textTheme.titleMedium),
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
