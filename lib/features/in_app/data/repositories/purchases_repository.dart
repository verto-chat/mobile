import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class PurchasesRepository implements IPurchasesRepository {
  final MonetizationApi _monetizationApi;
  final InAppPurchase _inAppPurchase;
  final IUserRepository _userRepository;
  final SafeDio _safeDio;
  final ILogger _logger;

  PurchasesRepository(this._monetizationApi, this._inAppPurchase, this._userRepository, this._logger, this._safeDio);

  @override
  Future<DomainResultDErr<List<ProductInfo>>> getProducts({required String languageCode}) async {
    final apiResult = await _safeDio.execute(() => _monetizationApi.getProducts());

    switch (apiResult) {
      case ApiSuccess(:final data):
        try {
          final available = await _inAppPurchase.isAvailable();

          final List<ProductDetails> details = available
              ? (await _inAppPurchase.queryProductDetails(data.map((dto) => dto.id).toSet())).productDetails
              : [];

          final map = {for (var e in details) e.id: e};

          return Success(data: data.map((d) => d.toEntity(map[d.id])).toList());
        } catch (e) {
          _logger.log(LogLevel.error, "Failed to get products", exception: e);
          return Error(errorData: const DomainErrorType.errorDefaultType());
        }
      case ApiError():
        return Error(errorData: apiResult.toDomain());
    }
  }

  @override
  Future<EmptyDomainResult> buyProduct(ProductInfo product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product.productDetails!,
        applicationUserName: _userRepository.userId.toString(),
      );

      final result = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);

      if (result) {
        return Success(data: null);
      } else {
        return Error(errorData: const DomainErrorType.insufficientAccessRights());
      }
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to buy product", exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }

  @override
  Future<DomainResultDErr<List<SubscriptionInfo>>> getSubscriptions({required String languageCode}) async {
    final apiResult = await _safeDio.execute(() => _monetizationApi.getSubscriptions());

    switch (apiResult) {
      case ApiSuccess(:final data):
        try {
          final available = await _inAppPurchase.isAvailable();

          final List<ProductDetails> details = available
              ? (await _inAppPurchase.queryProductDetails(data.map((dto) => dto.id).toSet())).productDetails
              : [];

          final map = {for (var e in details) e.id: e};

          return Success(data: data.map((d) => d.toEntity(map[d.id])).toList());
        } catch (e) {
          _logger.log(LogLevel.error, "Failed to get subscriptions", exception: e);
          return Error(errorData: const DomainErrorType.errorDefaultType());
        }
      case ApiError():
        return Error(errorData: apiResult.toDomain());
    }
  }

  @override
  Future<EmptyDomainResult> buySubscription(SubscriptionInfo subscription) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: subscription.productDetails!,
        applicationUserName: _userRepository.userId.toString(),
      );

      final result = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      if (result) {
        return Success(data: null);
      } else {
        return Error(errorData: const DomainErrorType.insufficientAccessRights());
      }
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to buy subscription", exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }
}
