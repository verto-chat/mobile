import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_subscription_info.freezed.dart';

@freezed
sealed class UserSubscriptionInfo with _$UserSubscriptionInfo {
  const factory UserSubscriptionInfo({
    required int creditsBalance,
    required UserPlanInfo plan,
    required bool recommendUpgrade,
  }) = _UserSubscriptionInfo;
}

@freezed
sealed class UserPlanInfo with _$UserPlanInfo {
  const factory UserPlanInfo({
    required String code,
    required String name,
    required bool isFree,
    required bool showAd,
    required int monthlyCreditsGrant,
    required int asrSecondsPerClipLimit,
  }) = _UserPlanInfo;
}
