import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/subscription_info.dart';

part 'subscription_info_dto.g.dart';

@JsonSerializable()
class SubscriptionInfoDto {
  final String id;
  final String name;
  final String period;
  final String benefits;

  SubscriptionInfoDto(this.id, this.name, this.period, this.benefits);

  factory SubscriptionInfoDto.fromJson(Map<String, dynamic> json) => _$SubscriptionInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionInfoDtoToJson(this);

  SubscriptionInfo toEntity(ProductDetails? details) =>
      SubscriptionInfo(productDetails: details, name: name, period: period, benefits: benefits);
}
