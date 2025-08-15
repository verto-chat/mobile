part of '../../../../../features/in_app/presentation/managers/select_subscription_bloc.dart';

@freezed
sealed class SelectSubscriptionEvent with _$SelectSubscriptionEvent {
  const factory SelectSubscriptionEvent.load({Completer<void>? completer}) = _Load;

  const factory SelectSubscriptionEvent.select(SubscriptionInfo subscription) = _Select;

  const factory SelectSubscriptionEvent.buy(SubscriptionInfo subscription) = _Buy;
}
