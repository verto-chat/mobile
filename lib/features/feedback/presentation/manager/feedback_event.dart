part of 'feedback_bloc.dart';

@freezed
sealed class FeedbackEvent with _$FeedbackEvent {
  const factory FeedbackEvent.changeType(FeedbackType type) = _ChangeType;

  const factory FeedbackEvent.changeDescription(String description) = _ChangeDescription;

  const factory FeedbackEvent.sendFeedback() = _SendFeedback;
}
