import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../domain/domain.dart';

part 'subscription_bloc.freezed.dart';

@freezed
class SubscriptionEvent with _$SubscriptionEvent {
  const factory SubscriptionEvent.fetchSubscription() = _FetchSubscription;

  const factory SubscriptionEvent.updateSubscription(UserSubscriptionInfo info) = _UpdateSubscription;
}

@freezed
sealed class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({required UserSubscriptionInfo subscription}) = _SubscriptionState;
}

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final IUserSubscriptionRepository _subscriptionRepository;
  final ILogger _logger;

  late StreamSubscription<dynamic> _subscriptionChangesSubscription;

  SubscriptionBloc(this._subscriptionRepository, this._logger)
    : super(
        const SubscriptionState(
          subscription: UserSubscriptionInfo(
            creditsBalance: 0,
            recommendUpgrade: true,
            plan: UserPlanInfo(
              code: 'free',
              name: 'Free',
              isFree: true,
              showAd: true,
              monthlyCreditsGrant: 200,
              asrSecondsPerClipLimit: 30,
            ),
          ),
        ),
      ) {
    on<_FetchSubscription>(_onFetchSubscription);
    on<_UpdateSubscription>((event, emit) {
      emit(state.copyWith(subscription: event.info));
    });

    _subscriptionChangesSubscription = _subscriptionRepository.subscriptionChangesStream.listen(
      (info) {
        _logger.log(LogLevel.info, "Subscription changes received");
        add(SubscriptionEvent.updateSubscription(info));
      },
      onError: (dynamic error) {
        _logger.log(LogLevel.error, "Failed to get subscription changes", exception: error);
      },
    );
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
