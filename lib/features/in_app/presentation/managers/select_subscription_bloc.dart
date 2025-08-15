import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

part 'select_subscription_bloc.freezed.dart';
part 'select_subscription_event.dart';
part 'select_subscription_state.dart';

class SelectSubscriptionBloc extends ContextBloc<SelectSubscriptionEvent, SelectSubscriptionState> {
  final IPurchasesRepository _purchasesRepository;

  SelectSubscriptionBloc(BuildContext context, this._purchasesRepository)
    : super(const SelectSubscriptionState.loading(), context) {
    on<_Load>(_onLoad);
    on<_Select>(_onSelect);
    on<_Buy>(_onBuy);

    add(const SelectSubscriptionEvent.load());
  }

  Future<void> _onLoad(_Load event, Emitter<SelectSubscriptionState> emit) async {
    final result = await _purchasesRepository.getSubscriptions(languageCode: languageCode);

    switch (result) {
      case Success():
        emit(SelectSubscriptionState.loaded(subscriptions: result.data, selectedSubscription: result.data.firstOrNull));
      case Error():
        emit(const SelectSubscriptionState.failure());
        showError(result.errorData);
    }

    event.completer?.complete();
  }

  void _onSelect(_Select event, Emitter<SelectSubscriptionState> emit) {
    final state = this.state;

    if (state is! Loaded) return;

    emit(state.copyWith(selectedSubscription: event.subscription));
  }

  Future<void> _onBuy(_Buy event, Emitter<SelectSubscriptionState> emit) async {
    final state = this.state;

    if (state is! Loaded) return;

    emit(state.copyWith(isLoading: true));

    final result = await _purchasesRepository.buySubscription(event.subscription);

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success():
        router?.maybePop();
      case Error():
        showError(result.errorData);
    }
  }
}
