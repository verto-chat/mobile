import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

part 'buy_products_bloc.freezed.dart';
part 'buy_products_event.dart';
part 'buy_products_state.dart';

class BuyProductsBloc extends ContextBloc<BuyProductsEvent, BuyProductsState> {
  final IPurchasesRepository _purchasesRepository;

  BuyProductsBloc(BuildContext context, this._purchasesRepository) : super(const BuyProductsState.loading(), context) {
    on<_Load>(_onLoad);
    on<_Select>(_onSelect);
    on<_Buy>(_onBuy);

    add(const BuyProductsEvent.load());
  }

  Future<void> _onLoad(_Load event, Emitter<BuyProductsState> emit) async {
    final result = await _purchasesRepository.getProducts(languageCode: languageCode);

    switch (result) {
      case Success():
        emit(BuyProductsState.loaded(products: result.data, selectedProduct: result.data.firstOrNull));
      case Error():
        emit(const BuyProductsState.failure());
        showError(result.errorData);
    }

    event.completer?.complete();
  }

  void _onSelect(_Select event, Emitter<BuyProductsState> emit) {
    final state = this.state;

    if (state is! Loaded) return;

    emit(state.copyWith(selectedProduct: event.product));
  }

  Future<void> _onBuy(_Buy event, Emitter<BuyProductsState> emit) async {
    final state = this.state;

    if (state is! Loaded) return;

    emit(state.copyWith(isLoading: true));

    final result = await _purchasesRepository.buyProduct(event.product);

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success():
        router?.maybePop();
      case Error():
        showError(result.errorData);
    }
  }
}
