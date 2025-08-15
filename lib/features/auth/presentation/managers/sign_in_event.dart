part of 'sign_in_bloc.dart';

@freezed
class SignInEvent with _$SignInEvent {
  const factory SignInEvent.passwordChanged(String password) = _PasswordChanged;

  const factory SignInEvent.emailChanged(String email) = _EmailChanged;

  const factory SignInEvent.forgotPassword() = _ForgotPassword;

  const factory SignInEvent.signIn() = _SignIn;

  const factory SignInEvent.signInWithGoogle() = _SignInWithGoogle;

  const factory SignInEvent.signInWithApple() = _SignInWithApple;

  const factory SignInEvent.signUp() = _SignUp;
}
