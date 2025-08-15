part of 'sign_up_bloc.dart';

@freezed
class SignUpEvent with _$SignUpEvent {
  const factory SignUpEvent.firstNameChanged(String name) = _FirstNameChanged;

  const factory SignUpEvent.lastNameChanged(String name) = _LastNameChanged;

  const factory SignUpEvent.passwordChanged(String password) = _PasswordChanged;

  const factory SignUpEvent.confirmPasswordChanged(String confirmPassword) = _ConfirmPasswordChanged;

  const factory SignUpEvent.emailChanged(String email) = _EmailChanged;

  const factory SignUpEvent.register() = _Register;

  const factory SignUpEvent.legalAcceptedChanged(bool isAccepted) = _LegalAcceptedChanged;
}
