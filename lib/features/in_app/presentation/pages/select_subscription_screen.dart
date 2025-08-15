import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/in_app/presentation/managers/select_subscription_bloc.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

@RoutePage()
class SelectSubscriptionScreen extends StatelessWidget {
  const SelectSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.in_app.select_subscription_screen;

    final backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return PurchasesFeature(
      builder: (context, _) {
        return BlocProvider(
          create: (_) => context.read<CreateSelectSubscriptionBloc>().call(context),
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
                  sliver: BlocBuilder<SelectSubscriptionBloc, SelectSubscriptionState>(
                    builder: (context, state) {
                      return switch (state) {
                        Loading() => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                        Failure() => SliverToBoxAdapter(
                          child: TryAgainButton(
                            tryAgainAction: () =>
                                context.read<SelectSubscriptionBloc>().add(const SelectSubscriptionEvent.load()),
                          ),
                        ),
                        Loaded() => SliverList.separated(
                          itemCount: state.subscriptions.length,
                          separatorBuilder: (_, _) => const Divider(),
                          itemBuilder: (context, index) {
                            final subscription = state.subscriptions[index];

                            return SubscriptionCard(
                              subscription: subscription,
                              isSelected: state.selectedSubscription == subscription,
                              onTap: () => context.read<SelectSubscriptionBloc>().add(
                                SelectSubscriptionEvent.select(subscription),
                              ),
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
    final loc = context.appTexts.in_app.select_subscription_screen;
    final storeName = Platform.isAndroid ? "Google Play" : "App Store";

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
              Text(
                loc.description(storeName: storeName),
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              BlocBuilder<SelectSubscriptionBloc, SelectSubscriptionState>(
                builder: (context, state) {
                  return FilledButton(
                    onPressed: state is Loaded && state.selectedSubscription?.productDetails != null
                        ? () => context.read<SelectSubscriptionBloc>().add(
                            SelectSubscriptionEvent.buy(state.selectedSubscription!),
                          )
                        : null,
                    child: Text(loc.try_1_week_free),
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
