import 'package:flutter/material.dart';

class NoItemsStub extends StatelessWidget {
  const NoItemsStub({super.key, required this.title, this.description, this.child});

  final String title;
  final String? description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          if (description != null)
            Text(description!, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          if (child != null) child!,
        ],
      ),
    );
  }
}
