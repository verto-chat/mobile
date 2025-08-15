import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_subscription_info.freezed.dart';

@freezed
sealed class UserSubscriptionInfo with _$UserSubscriptionInfo {
  const factory UserSubscriptionInfo({
    required String subscriptionName,
    required int activeAdvertsCount,
    required int? advertLimit,
    required bool showAd,
    required bool recommendUpgrade,
    required int? subscriptionPromoteLimit,
    required int singlePromotionLimit,
    required bool isFree,
  }) = _UserSubscriptionInfo;
}
