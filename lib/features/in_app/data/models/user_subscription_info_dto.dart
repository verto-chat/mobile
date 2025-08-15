import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/entities.dart';

part 'user_subscription_info_dto.g.dart';

@JsonSerializable()
class UserSubscriptionInfoDto {
  final String subscriptionName;
  final int activeAdvertsCount;
  final int? advertLimit;
  final bool showAd;
  final bool recommendUpgrade;
  final int? subscriptionPromoteLimit;
  final int singlePromotionLimit;
  final bool isFree;

  UserSubscriptionInfoDto(
    this.subscriptionName,
    this.activeAdvertsCount,
    this.advertLimit,
    this.showAd,
    this.recommendUpgrade,
    this.subscriptionPromoteLimit,
    this.singlePromotionLimit,
    this.isFree,
  );

  factory UserSubscriptionInfoDto.fromJson(Map<String, dynamic> json) => _$UserSubscriptionInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserSubscriptionInfoDtoToJson(this);

  UserSubscriptionInfo toEntity() => UserSubscriptionInfo(
    subscriptionName: subscriptionName,
    activeAdvertsCount: activeAdvertsCount,
    advertLimit: advertLimit,
    showAd: showAd,
    recommendUpgrade: recommendUpgrade,
    subscriptionPromoteLimit: subscriptionPromoteLimit,
    singlePromotionLimit: singlePromotionLimit,
    isFree: isFree,
  );
}
