part of '../../../../../features/in_app/presentation/managers/buy_products_bloc.dart';

@freezed
sealed class BuyProductsState with _$BuyProductsState {
  const factory BuyProductsState.loading() = Loading;

  const factory BuyProductsState.loaded({
    required List<ProductInfo> products,
    @Default(false) bool isLoading,
    ProductInfo? selectedProduct,
  }) = Loaded;

  const factory BuyProductsState.failure() = Failure;
}
