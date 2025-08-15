import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../managers/subscription_bloc.dart';
import '../widgets/promotion_card.dart';

enum SupposePromoteResult { promoteBySubscription, singlePromote }

@RoutePage()
class SupposePromoteScreen extends StatelessWidget {
  const SupposePromoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.in_app.suppose_promote_screen;

    return Scaffold(
      appBar: AppBar(title: Text(loc.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.description, style: Theme.of(context).textTheme.titleLarge),

              const SizedBox(height: 16),

              const _SubscriptionPromoteCard(),

              const SizedBox(height: 12),

              const _SinglePromotionCard(),

              const SizedBox(height: 24),

              Card.filled(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(loc.description_footer, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscriptionPromoteCard extends StatelessWidget {
  const _SubscriptionPromoteCard();

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.in_app.suppose_promote_screen.subscription_card;

    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        final info = state.subscription;
        final limit = info.subscriptionPromoteLimit;

        return PromotionCard(
          leading: const Icon(Icons.verified, color: Colors.green),
          title: limit != null && limit > 0 ? loc.title : loc.not_available_title,
          subtitle: limit == null
              ? loc.subscription_not_include_promotion
              : limit > 0
              ? loc.description
              : loc.not_available_subtitle,
          buttonText: limit != null && limit > 0 ? loc.promote_button : loc.upgrade_button,
          onTap: () {
            limit != null && limit > 0
                ? context.router.maybePop(SupposePromoteResult.promoteBySubscription)
                : context.router.push(const SupposeSubscriptionRoute());
          },
        );
      },
    );
  }
}

class _SinglePromotionCard extends StatelessWidget {
  const _SinglePromotionCard();

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.in_app.suppose_promote_screen.single_promotion_card;

    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        final limit = state.subscription.singlePromotionLimit;

        return PromotionCard(
          leading: const Icon(Icons.flash_on, color: Colors.deepOrange),
          title: loc.title,
          subtitle: loc.description,
          description: loc.available(available: limit),
          buttonText: limit > 0 ? loc.promote_button : loc.buy_button,
          onTap: () {
            limit > 0
                ? context.router.maybePop(SupposePromoteResult.singlePromote)
                : context.router.push(const BuyProductsRoute());
          },
        );
      },
    );
  }
}
