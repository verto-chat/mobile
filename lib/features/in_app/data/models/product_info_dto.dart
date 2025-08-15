import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../domain/domain.dart';

part 'product_info_dto.g.dart';

@JsonSerializable()
class ProductInfoDto {
  final String id;
  final int count;
  final String name;
  final String description;

  ProductInfoDto(this.id, this.count, this.name, this.description);

  factory ProductInfoDto.fromJson(Map<String, dynamic> json) => _$ProductInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInfoDtoToJson(this);

  ProductInfo toEntity(ProductDetails? details) =>
      ProductInfo(productDetails: details, name: name, description: description);
}
