part of 'buy_products_bloc.dart';

@freezed
sealed class BuyProductsEvent with _$BuyProductsEvent {
  const factory BuyProductsEvent.load({Completer<void>? completer}) = _Load;

  const factory BuyProductsEvent.select(ProductInfo product) = _Select;

  const factory BuyProductsEvent.buy(ProductInfo product) = _Buy;
}
