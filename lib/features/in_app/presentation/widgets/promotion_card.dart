import 'package:flutter/material.dart';

class PromotionCard extends StatelessWidget {
  const PromotionCard({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.description,
    required this.buttonText,
    required this.onTap,
  });

  final Widget leading;
  final String buttonText;
  final String title;
  final String subtitle;
  final String? description;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: 12,
              children: [
                leading,
                Flexible(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                FilledButton(onPressed: onTap, child: Text(buttonText)),
              ],
            ),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            if (description != null)
              Text(description!, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
