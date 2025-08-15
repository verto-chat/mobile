import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_status.freezed.dart';

@freezed
sealed class AuthStatus with _$AuthStatus {
  const factory AuthStatus.authenticated({required bool isRefreshed}) = Authenticated;

  const factory AuthStatus.loggedOut() = LoggedOut;
}
