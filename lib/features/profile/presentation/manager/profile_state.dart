part of 'profile_bloc.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState({
    required String version,
    required UserInfo userInfo,
    @Default(false) bool isLoading,
    @Default(false) bool isShimmerLoading,
  }) = _ProfileState;
}
