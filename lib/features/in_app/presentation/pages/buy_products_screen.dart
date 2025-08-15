import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../features.dart';
import '../managers/buy_products_bloc.dart';

@RoutePage()
class BuyProductsScreen extends StatelessWidget {
  const BuyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    final loc = context.appTexts.in_app.buy_products_screen;

    return PurchasesFeature(
      builder: (context, _) {
        return BlocProvider(
          create: (_) => context.read<CreateBuyProductsBloc>().call(context),
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: IconButton(onPressed: () => context.router.pop(), icon: const Icon(Icons.close)),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Text(
                    loc.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 24),
                  sliver: BlocBuilder<BuyProductsBloc, BuyProductsState>(
                    builder: (context, state) {
                      return switch (state) {
                        Loading() => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                        Failure() => SliverToBoxAdapter(
                          child: TryAgainButton(
                            tryAgainAction: () => context.read<BuyProductsBloc>().add(const BuyProductsEvent.load()),
                          ),
                        ),
                        Loaded() => SliverList.separated(
                          itemCount: state.products.length,
                          separatorBuilder: (_, _) => const Divider(),
                          itemBuilder: (context, index) {
                            final product = state.products[index];

                            return ProductCard(
                              product: product,
                              isSelected: state.selectedProduct == product,
                              onTap: () => context.read<BuyProductsBloc>().add(BuyProductsEvent.select(product)),
                            );
                          },
                        ),
                      };
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _BottomBar(),
          ),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<BuyProductsBloc, BuyProductsState>(
                builder: (context, state) {
                  return FilledButton(
                    onPressed: state is Loaded && state.selectedProduct?.productDetails != null
                        ? () => context.read<BuyProductsBloc>().add(BuyProductsEvent.buy(state.selectedProduct!))
                        : null,
                    child: Text(context.appTexts.in_app.buy_products_screen.buy_button),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
