part of 'forgot_password_bloc.dart';

@freezed
sealed class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(Email.pure()) Email email,
    @Default(false) bool isLoading,
    @Default(false) bool canSend,
  }) = _ForgotPasswordState;
}
