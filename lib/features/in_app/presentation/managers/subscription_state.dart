part of 'subscription_bloc.dart';

@freezed
sealed class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({required UserSubscriptionInfo subscription}) = _SubscriptionState;
}
