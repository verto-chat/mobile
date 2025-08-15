import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../domain/domain.dart';

part 'subscription_bloc.freezed.dart';

part 'subscription_event.dart';

part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final IUserSubscriptionRepository _subscriptionRepository;
  final ILogger _logger;

  late StreamSubscription<dynamic> _subscriptionChangesSubscription;

  SubscriptionBloc(this._subscriptionRepository, this._logger)
    : super(
        const SubscriptionState(
          subscription: UserSubscriptionInfo(
            subscriptionName: "Ovdix Free",
            activeAdvertsCount: 0,
            advertLimit: 5,
            showAd: true,
            recommendUpgrade: true,
            subscriptionPromoteLimit: null,
            singlePromotionLimit: 0,
            isFree: true,
          ),
        ),
      ) {
    on<_FetchSubscription>(_onFetchSubscription);

    _subscriptionChangesSubscription = _subscriptionRepository.subscriptionChangesStream.listen(
      (_) {
        _logger.log(LogLevel.info, "Subscription changes received");
        add(const SubscriptionEvent.fetchSubscription());
      },
      onError: (dynamic error) {
        _logger.log(LogLevel.error, "Failed to get subscription changes", exception: error);
      },
    );

    add(const SubscriptionEvent.fetchSubscription());
  }

  @override
  Future<void> close() {
    _subscriptionChangesSubscription.cancel();
    return super.close();
  }

  Future<void> _onFetchSubscription(_FetchSubscription event, Emitter<SubscriptionState> emit) async {
    final result = await _subscriptionRepository.getSubscription();

    switch (result) {
      case Success():
        emit(state.copyWith(subscription: result.data));
      case Error():
        break;
    }
  }
}
