import 'package:context_di/context_di.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../features.dart';
import 'presentation/managers/buy_products_bloc.dart';
import 'presentation/managers/select_subscription_bloc.dart';

export 'ad_mob_id.dart';
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
export 'production_ad_mob_id.dart';

part 'in_app.g.dart';

void _dispose(BuildContext context, UserSubscriptionRepository instance) => instance.dispose();

@Feature()
@Singleton(UserSubscriptionRepository, as: IUserSubscriptionRepository, dispose: _dispose)
@Factory(SubscriptionBloc)
class InAppFeature extends FeatureDependencies with _$InAppFeatureMixin {
  const InAppFeature({super.key, super.child});

  @override
  List<Registration> register() {
    return [
      registerSingleton((context) {
        final dio = context.read<CreateDio>().call(context, const (backendSupport: true));

        final endpoints = context.read<IEndpoints>();

        return UserSubscriptionApi(dio, baseUrl: "${endpoints.baseUrl}/monetization");
      }),
      ...super.register(),
    ];
  }
}

@Feature()
@Singleton(PurchasesRepository, as: IPurchasesRepository)
@Factory(BuyProductsBloc)
@Factory(SelectSubscriptionBloc)
class PurchasesFeature extends FeatureDependencies with _$PurchasesFeatureMixin {
  const PurchasesFeature({super.key, super.builder});

  @override
  List<Registration> register() {
    return [
      registerSingleton((context) {
        final dio = context.read<CreateDio>().call(context, const (backendSupport: true));

        final endpoints = context.read<IEndpoints>();

        return MonetizationApi(dio, baseUrl: "${endpoints.baseUrl}/monetization");
      }),
      registerSingleton<InAppPurchase>((c) => InAppPurchase.instance),
      ...super.register(),
    ];
  }
}
