part of 'new_password_bloc.dart';

@freezed
sealed class NewPasswordState with _$NewPasswordState {
  const factory NewPasswordState({
    required NewPasswordNavigationPurpose navigationPurpose,
    @Default(Password.pure()) Password currentPassword,
    @Default(Password.pure()) Password password,
    @Default(ConfirmedPassword.pure()) ConfirmedPassword confirmedPassword,
    @Default(false) bool isLoading,
    @Default(false) bool isValid,
  }) = _NewPasswordState;
}
