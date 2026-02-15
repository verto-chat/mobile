import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:openapi/openapi.dart';

import '../../domain/domain.dart';

extension ProductInfoDtoExtensions on ProductInfoDto {
  ProductInfo toEntity(ProductDetails? details) =>
      ProductInfo(productDetails: details, name: name, description: description);
}

extension SubscriptionInfoDtoExtensions on SubscriptionInfoDto {
  SubscriptionInfo toEntity(ProductDetails? details) =>
      SubscriptionInfo(productDetails: details, name: name, period: period, benefits: benefits);
}

extension UserSubscriptionInfoDtoExtensions on UserSubscriptionInfoDto {
  UserSubscriptionInfo toEntity() =>
      UserSubscriptionInfo(creditsBalance: creditsBalance, plan: plan.toDomain(), recommendUpgrade: recommendUpgrade);
}

extension _UserPlanDtoExtensions on UserPlanDto {
  UserPlanInfo toDomain() => UserPlanInfo(
    code: code,
    name: name,
    isFree: isFree,
    showAd: showAd,
    monthlyCreditsGrant: monthlyCreditsGrant,
    asrSecondsPerClipLimit: asrSecondsPerClipLimit,
  );
}
