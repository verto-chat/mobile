part of 'select_subscription_bloc.dart';

@freezed
sealed class SelectSubscriptionState with _$SelectSubscriptionState {
  const factory SelectSubscriptionState.loading() = Loading;

  const factory SelectSubscriptionState.loaded({
    required List<SubscriptionInfo> subscriptions,
    @Default(false) bool isLoading,
    SubscriptionInfo? selectedSubscription,
  }) = Loaded;

  const factory SelectSubscriptionState.failure() = Failure;
}
