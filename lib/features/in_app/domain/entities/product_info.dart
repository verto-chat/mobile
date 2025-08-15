import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'product_info.freezed.dart';

@freezed
sealed class ProductInfo with _$ProductInfo {
  const factory ProductInfo({
    required ProductDetails? productDetails,
    required String name,
    required String description,
  }) = _ProductInfo;
}
