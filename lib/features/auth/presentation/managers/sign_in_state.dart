part of 'sign_in_bloc.dart';

@freezed
sealed class SignInState with _$SignInState {
  const factory SignInState({
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    @Default(false) bool isLoading,
    @Default(false) bool canSignIn,
  }) = _SignInState;
}
