part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.loggedIn() = LoggedInState;

  const factory AuthState.loggedOut() = LoggedOutState;
}
