part of 'user_select_bloc.dart';

@freezed
sealed class UserSelectState with _$UserSelectState {
  const factory UserSelectState.loading() = Loading;

  const factory UserSelectState.loaded({
    required List<UserInfo> users,
    @Default(false) bool isLoading,
  }) = Loaded;

  const factory UserSelectState.failure() = Failure;
}
