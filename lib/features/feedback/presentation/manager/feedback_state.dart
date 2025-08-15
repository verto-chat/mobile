part of 'feedback_bloc.dart';

@freezed
sealed class FeedbackState with _$FeedbackState {
  const factory FeedbackState({
    required FeedbackType type,
    required String description,
    @Default(false) bool isLoading,
  }) = _FeedbackState;
}
