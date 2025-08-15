import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';

@RoutePage()
class SupposeSubscriptionScreen extends StatelessWidget {
  const SupposeSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.in_app.suppose_subscription_screen;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Column(
            spacing: 12,
            children: [
              Text(loc.title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const Spacer(),
              Text(loc.description, style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
              FilledButton(
                onPressed: () => context.router.replace(const SelectSubscriptionRoute()),
                child: Text(loc.accept_button),
              ),
              TextButton(onPressed: () => context.router.pop(), child: Text(loc.cancel_button)),
            ],
          ),
        ),
      ),
    );
  }
}
