part of 'new_password_bloc.dart';

@freezed
sealed class NewPasswordEvent with _$NewPasswordEvent {
  const factory NewPasswordEvent.currentPasswordChanged(String value) = _CurrentPasswordChanged;

  const factory NewPasswordEvent.passwordChanged(String value) = _PasswordChanged;

  const factory NewPasswordEvent.confirmPasswordChanged(String value) = _ConfirmPasswordChanged;

  const factory NewPasswordEvent.submit() = _Submit;
}
