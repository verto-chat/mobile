import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'subscription_info.freezed.dart';

@freezed
sealed class SubscriptionInfo with _$SubscriptionInfo {
  const factory SubscriptionInfo({
    required ProductDetails? productDetails,
    required String name,
    required String period,
    required String benefits,
  }) = _SubscriptionInfo;
}
