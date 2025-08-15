import '../../../../common/common.dart';
import '../domain.dart';

abstract interface class IPurchasesRepository {
  Future<DomainResultDErr<List<ProductInfo>>> getProducts({required String languageCode});

  Future<EmptyDomainResult> buyProduct(ProductInfo product);

  Future<DomainResultDErr<List<SubscriptionInfo>>> getSubscriptions({required String languageCode});

  Future<EmptyDomainResult> buySubscription(SubscriptionInfo subscription);
}
