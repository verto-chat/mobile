import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';
import '../../domain/domain.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.isSelected, required this.onTap});

  final ProductInfo product;
  final bool isSelected;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                  Flexible(child: Text(product.name, style: Theme.of(context).textTheme.titleLarge)),
                  Text(
                    product.productDetails?.price ?? context.appTexts.in_app.buy_products_screen.unavailable,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),
                  ),
                ],
              ),
              Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
