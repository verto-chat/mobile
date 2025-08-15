part of 'sign_up_bloc.dart';

@freezed
sealed class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default(Username.pure()) Username lastName,
    @Default(Username.pure()) Username firstName,
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    @Default(ConfirmedPassword.pure()) ConfirmedPassword confirmedPassword,
    @Default(false) bool isValid,
    @Default(false) bool isLoading,
    @Default(false) bool isLegalAccepted,
  }) = _SignUpState;
}
