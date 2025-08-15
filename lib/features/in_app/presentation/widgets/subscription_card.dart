import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';
import '../../domain/domain.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.subscription, required this.isSelected, required this.onTap});

  final SubscriptionInfo subscription;
  final bool isSelected;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final price = subscription.productDetails != null
        ? "${subscription.productDetails!.price} / ${subscription.period}"
        : context.appTexts.in_app.buy_products_screen.unavailable;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      margin: EdgeInsets.symmetric(horizontal: isSelected ? 0 : 6),
      borderOnForeground: isSelected,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(subscription.name, style: Theme.of(context).textTheme.titleLarge)),
                  Text(
                    price,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),
                  ),
                ],
              ),
              Text(subscription.benefits, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
